
% ------------------------------------------
% Tabela 19-5 (str. 574)
% �wiczenie:  Rozpoznawanie izolowanych s��w
% ------------------------------------------

function [ nr ] = dtw( Cx, Cwzr, Nwzr)
% rozpoznawanie s�owa poprzez por�wnanie macierzy jego wsp. cepstralnych Cx z wzorcami Cwzr metod� DTW 

[ Ns, Np ] = size(Cx);             % liczba wektor�w wsp�czynnik�w cepstralnych s�owa, ich d�ugo��

for numer = 1 : length(Nwzr)       % por�wnaj Cx z Cwzr wszystkich wzorc�w

   %  Obliczenie odleg�o�ci d(ns, nw) pomi�dzy poszczeg�lnymi cepstrami sygna�u (ns) i sprawdzanego wzorca (nw)
    Nw = Nwzr( numer );                          % liczba wektor�w wsp. cepstralnych wzorca
    Q = round( 0.2 * max(Ns,Nw) );               % wsp�czynnik szeroko�ci �cie�ki
    d = Inf*ones(Ns,Nw); tg=(Nw-Q)/(Ns-Q);       % inicjalizacja macierzy odleg�o�ci, tangens k�ta
    for ns = 1:Ns                                % dla ka�dego cepstrum rozpoznawanego s�owa
        down(ns) = max( 1, floor(tg*ns-Q*tg));   % ograniczenie dolne
        up(ns)   = min( Nw, ceil(tg*ns+Q));      % ograniczenie g�rne
        for nw = down(ns) : up(ns)               % dla ka�dego cepstrum wzorca
            d(ns,nw) = sqrt( sum((Cx(ns, 1:Np) - Cwzr(nw, 1:Np, numer)).^2 )); % odleg�o��
        end
    end
    
  % Obliczenie odleg�o�ci zakumulowanej g()
    g = d;                                             % inicjalizacja
    for ns = 2:Ns, g(ns,1) = g(ns-1,1) + d(ns,1); end  % zakumuluj pierwsz� kolumn�
    for nw = 2:Nw, g(1,nw) = g(1,nw-1) + d(1,nw); end  % zakumuluj pierwszy wiersz
    for ns = 2:Ns                                % akumuluj w pionie (s�owo)
        for nw = max( down(ns), 2 ) : up(ns)     % akumuluj w poziomie (wzorzec)
            dd = d(ns,nw);                       % odleg�o�� cepstrum "ns" s�owa od wzorca "nw"
            temp(1) = g(ns-1,nw) + dd;           % ruch do g�ry
            temp(2) = g(ns-1,nw-1) + 2*dd;       % ruch po przek�tnej (do g�ry w prawo)
            temp(3) = g(ns,nw-1) + dd;           % ruch w prawo
            g(ns,nw) = min( temp );              % wybierz minimaln� warto�� zakumulowan�
        end
    end
    glob(numer) = g(Ns,Nw)/sqrt(Ns^2+Nw^2)       % warto�� zakumulowana "najkr�tszej" �cie�ki
end
[ xxx nr ] = min( glob );                        % numer wzorca o najmniejszej warto�ci zakumulowanej
