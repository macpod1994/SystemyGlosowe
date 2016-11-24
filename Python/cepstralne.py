import numpy as np
import math
import matplotlib.pyplot as plt


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
        glob = np.arange(len(Nwzr))

        for numer in range(len(Nwzr)):        # porównaj Cx z Cwzr wszystkich wzorców
            Nw = Nwzr[numer]                  # liczba wektorów wsp. cepstralnych wzorca
            Q = round(0.2*max(Ns, Nw))        # współczynnik szerokości ścieżki
            d = np.inf * np.ones((Ns, Nw))    # inicjalizacja macierzy odległości,
            tg = (Nw - Q) / (Ns - Q)          # tangens kąta
            for ns in range(Ns):              # dla każdego cepstrum rozpoznawanego słowa
                down[ns] = max(1, math.floor(tg * ns - Q * tg))  # ograniczenie dolne
                up[ns] = min(Nw, math.ceil(tg*ns+Q))             # ograniczenie górne
                for nw in range(down[ns]-1, up[ns], 1):             # % dla każdego cepstrum wzorca
                    d[ns, nw] = math.sqrt(np.sum((Cx[ns, 0:Np] - Cwzr[nw, 0:Np, numer])**2)) # % odległość


            # Obliczenie odległości zakumulowanej g()
            g = d                                               # inicjalizacja
            temp = np.arange(3)                                 # alokacja

            for ns in range(1, Ns):
                g[ns, 0] = g[ns-1, 0] + d[ns, 0]                # zakumuluj pierwsza kolumne
            for nw in range(1, Nw):                             #
                g[0, nw] = g[0, nw-1] + d[0, nw]                # zakumuluj pierwszy wiersz
            for ns in range(1, Ns, 1):                          # akumuluj w pionie
                for nw in range(max(down[ns], 1), up[ns], 1):   # akumuluj w poziomie
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
        m=1
        w=1 + Alg.Np * math.sin(math.pi* m / Alg.Nc) / 2                #
        sygnal = sygnal - 0.9375*np.concatenate(([0],sygnal[0:(N-1)]))    # pre-em faza
        Cx = np.arange(0.)
        for nr in range(Nramek):
            bx = sygnal[(nr*self.Mstep): (self.Mlen + nr*self.Mstep)]
            bx = bx - np.mean(bx)
            bx = bx * np.hamming(self.Mlen)
            r = np.arange(Alg.Np+1)
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
            for m in range(1,Alg.Nc):
                k = np.arange(m)
                c[m]= a[m] + np.sum(c[k] * a[m - k] * k / m)


            cw = c * w
            Cx = np.concatenate((Cx,cw))
        Cx = Cx.reshape((Nramek,(len(cw))))
        return (Cx, Nramek)



if __name__ == '__main__':

    a=Alg()
    syg=np.random.randn(1,44100)*np.hamming(44100)*3
    syg2=a.cisza(syg[0,:])
    print(len(syg2))
    plt.plot(syg2)
    plt.plot(syg[0,:])
    N = len(syg2)
    print(syg2[0:(N - 1)])
    sygnal = syg2 - 0.9375 * np.concatenate(([0], syg2[0:(N - 1)]))
    Cx=a.cepstrum(syg2)
    print(Cx)