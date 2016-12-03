
% ------------------------------------------
% Tabela 19-5 (str. 574)
% Æwiczenie:  Rozpoznawanie izolowanych s³ów
% ------------------------------------------

function [ nr ] = dtw( Cx, Cwzr, Nwzr)
% rozpoznawanie s³owa poprzez porównanie macierzy jego wsp. cepstralnych Cx z wzorcami Cwzr metod¹ DTW 

[ Ns, Np ] = size(Cx);             % liczba wektorów wspó³czynników cepstralnych s³owa, ich d³ugoœæ

for numer = 1 : length(Nwzr)       % porównaj Cx z Cwzr wszystkich wzorców

   %  Obliczenie odleg³oœci d(ns, nw) pomiêdzy poszczególnymi cepstrami sygna³u (ns) i sprawdzanego wzorca (nw)
    Nw = Nwzr( numer );                          % liczba wektorów wsp. cepstralnych wzorca
    Q = round( 0.2 * max(Ns,Nw) );               % wspó³czynnik szerokoœci œcie¿ki
    d = Inf*ones(Ns,Nw); tg=(Nw-Q)/(Ns-Q);       % inicjalizacja macierzy odleg³oœci, tangens k¹ta
    for ns = 1:Ns                                % dla ka¿dego cepstrum rozpoznawanego s³owa
        down(ns) = max( 1, floor(tg*ns-Q*tg));   % ograniczenie dolne
        up(ns)   = min( Nw, ceil(tg*ns+Q));      % ograniczenie górne
        for nw = down(ns) : up(ns)               % dla ka¿dego cepstrum wzorca
            d(ns,nw) = sqrt( sum((Cx(ns, 1:Np) - Cwzr(nw, 1:Np, numer)).^2 )); % odleg³oœæ
        end
    end
    
  % Obliczenie odleg³oœci zakumulowanej g()
    g = d;                                             % inicjalizacja
    for ns = 2:Ns, g(ns,1) = g(ns-1,1) + d(ns,1); end  % zakumuluj pierwsz¹ kolumnê
    for nw = 2:Nw, g(1,nw) = g(1,nw-1) + d(1,nw); end  % zakumuluj pierwszy wiersz
    for ns = 2:Ns                                % akumuluj w pionie (s³owo)
        for nw = max( down(ns), 2 ) : up(ns)     % akumuluj w poziomie (wzorzec)
            dd = d(ns,nw);                       % odleg³oœæ cepstrum "ns" s³owa od wzorca "nw"
            temp(1) = g(ns-1,nw) + dd;           % ruch do góry
            temp(2) = g(ns-1,nw-1) + 2*dd;       % ruch po przek¹tnej (do góry w prawo)
            temp(3) = g(ns,nw-1) + dd;           % ruch w prawo
            g(ns,nw) = min( temp );              % wybierz minimaln¹ wartoœæ zakumulowan¹
        end
    end
    glob(numer) = g(Ns,Nw)/sqrt(Ns^2+Nw^2)       % wartoœæ zakumulowana "najkrótszej" œcie¿ki
end
[ xxx nr ] = min( glob );                        % numer wzorca o najmniejszej wartoœci zakumulowanej
