
% ------------------------------------------
% Tabela 19-5 (str. 574)
% �wiczenie:  Rozpoznawanie izolowanych s��w
% ------------------------------------------

function [Cx, Nramek] = cepstrum( x )
% obliczenie macierzy Cx wsp�czynnik�w cepstralnych dla s�owa x
  
  global Mlen Mstep Np Nc               % parametry globalne
  
  c=[]; cw=[]; Cx=[];                   % usuwanie zawarto�ci macierzy
  
  N = length(x);                        % liczba pr�bek sygna�u
  Nramek = floor((N-Mlen)/Mstep+1);     % liczba fragment�w (ramek) jest do przetworzenia
  m = 1:Nc; w = 1 + Np*sin(pi*m/Nc)/2;  % wsp�czynniki wagowe
  
  x = x - 0.9375*[0; x(1:N-1)];         % filtracja wst�pna (pre-emfaza)
  
% P�TLA G��WNA
  for  nr = 1 : Nramek
      % Pobranie kolejnego fragmentu sygna�u
        n = 1+(nr-1)*Mstep : Mlen + (nr-1)*Mstep; bx = x(n);
      % Przetwarzanie wst�pne
        bx = bx - mean(bx);                                   % usu� warto�� �redni�
        bx = bx .* hamming(Mlen);                             % zastosuj okno czasowe
             % Obliczenie wsp�czynnik�w cepstralnych ze wsp�czynnik�w filtra LPC
        for k = 0 : Np
            r(k+1) = sum( bx(1 : Mlen-k) .* bx(1+k : Mlen) ); % funkcja autokorelacji
        end
        rr(1:Np,1)=(r(2:Np+1))';                              % wektor autokorelacji
        for m = 1 : Np
            R(m,1:Np)=[r(m:-1:2) r(1:Np-(m-1))];              % macierz autokorelacji
        end
        a = inv(R)*rr; a = a';                                % wsp. transmitancji filtra LPC
        a = [a zeros(1,Nc-Np)];                               % uzupe�nij zerami
        c(1) = a(1);
        for m = 2 : Nc
            k = 1:m-1;
            c(m) = a(m) + sum(c(k).*a(m-k).*k/m);  % wsp�czynniki cepstralne
        end
      % Obliczenie wsp�czynnik�w cepstralnych metod� FFT
      % c1 = real( ifft( log( abs(fft(bx)).^2 ) ) );          % zr�b to sam
      % c2 = rceps(bx);                                       % za pomoc� funkcji Matlaba
      % c = c1; c = c'; c = c(2:Nc+1);                        % c1 lub c2; wytnij fragment
      %  Wa�enie wyznaczonych wsp�czynnik�w cepstralnych
        cw = c .* w;                                          % ich wymno�enie z wagami
        Cx = [Cx;  cw];                                       % oraz zapami�tanie w macierzy
    end
