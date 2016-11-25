
% ------------------------------------------
% Tabela 19-5 (str. 574)
% Æwiczenie:  Rozpoznawanie izolowanych s³ów
% ------------------------------------------

function [Cx, Nramek] = cepstrum( x )
% obliczenie macierzy Cx wspó³czynników cepstralnych dla s³owa x
  
  global Mlen Mstep Np Nc               % parametry globalne
  
  c=[]; cw=[]; Cx=[];                   % usuwanie zawartoœci macierzy
  
  N = length(x);                        % liczba próbek sygna³u
  Nramek = floor((N-Mlen)/Mstep+1);     % liczba fragmentów (ramek) jest do przetworzenia
  m = 1:Nc; w = 1 + Np*sin(pi*m/Nc)/2;  % wspó³czynniki wagowe
  
  x = x - 0.9375*[0; x(1:N-1)];         % filtracja wstêpna (pre-emfaza)
  
% PÊTLA G£ÓWNA
  for  nr = 1 : Nramek
      % Pobranie kolejnego fragmentu sygna³u
        n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep; bx = x(n);
      % Przetwarzanie wstêpne
        bx = bx - mean(bx);                                   % usuñ wartoœæ œredni¹
        bx = bx .* hamming(Mlen);                             % zastosuj okno czasowe
             % Obliczenie wspó³czynników cepstralnych ze wspó³czynników filtra LPC
        for k = 0 : Np
            r(k+1) = sum( bx(1 : Mlen-k) .* bx(1+k : Mlen) ); % funkcja autokorelacji
        end
        rr(1:Np,1)=(r(2:Np+1))';                              % wektor autokorelacji
        for m = 1 : Np
            R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))];              % macierz autokorelacji
        end
        a = inv(R)*rr; a = a';                                % wsp. transmitancji filtra LPC
        a = [a zeros(1,Nc-Np)];                               % uzupe³nij zerami
        c(1) = a(1);
        for m = 2 : Nc
            k = 1:m-1;
            c(m) = a(m) + sum(c(k).*a(m-k).*k/m);  % wspó³czynniki cepstralne
        end
      % Obliczenie wspó³czynników cepstralnych metod¹ FFT
      % c1 = real( ifft( log( abs(fft(bx)).^2 ) ) );          % zrób to sam
      % c2 = rceps(bx);                                       % za pomoc¹ funkcji Matlaba
      % c = c1; c = c'; c = c(2:Nc+1);                        % c1 lub c2; wytnij fragment
      %  Wa¿enie wyznaczonych wspó³czynników cepstralnych
        cw = c .* w;                                          % ich wymno¿enie z wagami
        Cx = [Cx;  cw];                                       % oraz zapamiêtanie w macierzy
    end
