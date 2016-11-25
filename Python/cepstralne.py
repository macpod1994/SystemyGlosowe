import numpy as np
import math
import matplotlib.pyplot as plt
import scipy.io as sio

class Alg(object):
    fpr = 44100                    # czestotliwość próbkowania
    Np = 10                       # liczba biegunów w filtrze predykcji
    Nc = 12                        # liczba wyznaczanych współczynników cepstralnych
    twind = 30                     # długość okna obserwacji (ramki danych) w milisekundach
    tstep = 10                     # przesunięcie pomiędzy kolejnymi położeniami okna w milisekundach
    slowa = ['lewo', 'prawo', 'start', 'stop']

    def __init__(self):
        self.Mlen = int((Alg.twind*0.001)*Alg.fpr)
        self.Mstep = int((Alg.tstep*0.001)*Alg.fpr)
        self.M = len(Alg.slowa)

    def cisza(self, sygnal):

        dt1 = 0.010
        Mlen = math.floor(dt1 * Alg.fpr)

        dt2 = 0.001
        Mstep = math.floor(dt2 * Alg.fpr)

        prog = 0.25 * Alg.fpr / 8000
        N = len(sygnal)
        Nramek = math.floor((N-Mlen)/Mstep+1)
        sygnaln = sygnal / np.max(np.abs(sygnal))

        nr1_i = 0
        for nr1 in range(Nramek):
            bx = sygnaln[nr1*Mstep: Mlen + nr1*Mstep]
            if bx.dot(bx) > prog:
                break
            nr1_i += 1

        nr2_i = Nramek-1
        for nr2 in range(Nramek-1, -1, -1):
            bx = sygnaln[nr2*Mstep: (Mlen + nr2*Mstep)]
            if bx.dot(bx) > prog:
                break
            nr2_i -= 1

        y = sygnal[(nr1_i*Mstep): (Mlen + nr2_i*Mstep)]
        return y

    def dtw(self, Cx, Cwzr, Nwzr):

        Ns, Np = np.shape(Cx)

        down = np.arange(Ns)  #alokacja
        up = np.arange(Ns)
        glob = np.arange(float(len(Nwzr)))

        for numer in range(len(Nwzr)):        # porównaj Cx z Cwzr wszystkich wzorców
            Nw = Nwzr[numer]                  # liczba wektorów wsp. cepstralnych wzorca
            Q = round(0.2*max(Ns, Nw))        # współczynnik szerokości ścieżki
            d = np.inf * np.ones((Ns, Nw))    # inicjalizacja macierzy odległości,
            tg = (Nw - Q) / (Ns - Q)          # tangens kąta
            for ns in range(Ns):              # dla każdego cepstrum rozpoznawanego słowa
                down[ns] = max(1, math.floor(tg * (ns+1) - Q * tg))  # ograniczenie dolne
                up[ns] = min(Nw, math.ceil(tg*(ns+1)+Q))             # ograniczenie górne
                for nw in range(down[ns]-1, up[ns], 1):             # % dla każdego cepstrum wzorca
                    C=Cwzr[numer]
                    d[ns, nw] = math.sqrt(np.sum((Cx[ns, 0:Np] - C[nw, 0:Np])**2)) # % odległość


            # Obliczenie odległości zakumulowanej g()
            g = np.copy(d)                                               # inicjalizacja
            temp = np.arange(3.)                                 # alokacja

            for ns in range(1, Ns):
                g[ns, 0] = g[ns-1, 0] + d[ns, 0]                # zakumuluj pierwsza kolumne
            for nw in range(1, Nw):                             #
                g[0, nw] = g[0, nw-1] + d[0, nw]                # zakumuluj pierwszy wiersz
            for ns in range(1, Ns, 1):                          # akumuluj w pionie
                for nw in range(max(down[ns], 1), up[ns]):   # akumuluj w poziomie
                    dd = d[ns, nw]                              # odległość cepstrum "ns" słowa od wzorca "nw"
                    temp[0] = g[ns - 1, nw] + dd                # ruch do góry
                    temp[1] = g[ns - 1, nw-1] + 2*dd            # ruch po przekątnej (do góry w prawo)
                    temp[2] = g[ns, nw - 1] + dd                # ruch w prawo
                    g[ns, nw] = np.amin(temp)                   # wybierz minimalną wartość zakumulowaną
            glob[numer] = g[Ns-1, Nw-1] / math.sqrt(Ns**2 + Nw**2)  # % wartość zakumulowana "najkrótszej" ścieżki

        nr = np.argmin(glob)                                    #  numer wzorca o najmniejszej wartości zakumulowanej
        return nr

    def cepstrum(self, sygnal):
        N = len(sygnal)                                                 #
        Nramek = math.floor((N - self.Mlen) / self.Mstep + 1)           #
        m=np.arange(1.,13.)
        w=1 + Alg.Np * np.sin(math.pi* m / Alg.Nc) / 2                #
        sygnal = sygnal - 0.9375*np.concatenate(([0],sygnal[0:(N-1)]))    # pre-em faza
        Cx = np.arange(0.)
        for nr in range(Nramek):
            bx = sygnal[(nr*self.Mstep): (self.Mlen + nr*self.Mstep)]
            bx = bx - np.mean(bx)
            bx = bx * np.hamming(self.Mlen)
            r = np.arange(Alg.Np+1.)
            for k in range(Alg.Np+1):
                r[k] = np.sum(bx[0:(self.Mlen-k)] * bx[k: self.Mlen])

            rr=r[1:(Alg.Np+1),None]
            R=np.zeros((Alg.Np,Alg.Np))
            for m in range(Alg.Np):
                R[m, :] = np.concatenate((r[range(m,0,-1)], r[0:(Alg.Np-m)]))


            a = np.linalg.inv(R)
            a = a.dot(rr)
            a = np.transpose(a)
            zera=np.zeros((1,(Alg.Nc-Alg.Np)))
            a = np.concatenate((a[0, :], zera[0, :]))
            c = np.arange(12.)
            c[0] = a [0]
            for mm in range(1,Alg.Nc):
                k = np.arange(mm)
                c[mm]= a[mm] + np.sum(c[k] * a[mm -1 - k] * (k+1) / (mm+1))


            cw = c * w
            Cx = np.concatenate((Cx,cw))
        Cx = Cx.reshape((Nramek,12))
        return (Cx, Nramek)



if __name__ == '__main__':

    a=Alg()
    C = []
    Nramek = []
    for i in range(4):  # Tworzenie bazy danych
        y = sio.loadmat('../SG/{}_Karolina_1'.format(a.slowa[i]))
        y = y['y']
        y = y[:, 0]
        syg = a.cisza(y)
        Cx = a.cepstrum(syg)
        C.append(Cx[0])
        Nramek.append(Cx[1])

    for i in range(4): # Test
        for k in range(4):
            y = sio.loadmat('../SG/{}_Karolina_{}'.format((a.slowa[i]),(k+1)))
            y = y['y']
            y = y[:, 0]
            syg = a.cisza(y)
            Cx = a.cepstrum(syg)
            nr = a.dtw(Cx[0],C,Nramek)
            print('{} to {}'.format(a.slowa[i],a.slowa[nr]))
