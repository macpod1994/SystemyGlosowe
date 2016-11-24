
% ------------------------------------------
% Tabela 19-5 (str. 574)
% �wiczenie:  Rozpoznawanie izolowanych s��w
% ------------------------------------------

function y = cisza(x, fpr)
% usuni�cie ciszy na pocz�tku i ko�cu s�owa

dt1 = 0.010; Mlen  = floor(dt1*fpr); % d�ugo�� okna czasowego do liczenia energii [msek], liczba pr�bek
dt2 = 0.001; Mstep = floor(dt2*fpr); % przesuni�cie okna czasowego [msek], liczba pr�bek
prog = 0.25*fpr/8000;                % pr�g g�o�no�ci

N = length(x);                       % d�ugo�� sygna�u
Nramek = floor((N-Mlen)/Mstep+1);    % liczba fragment�w (ramek) jest do przetworzenia

xn = x / max(abs(x));                                 % normowanie
for nr1 = 1 : Nramek                                  % DETEKCJA ciszy na pocz�tku nagrania
   bx = xn( 1+(nr1-1)*Mstep : Mlen + (nr1-1)*Mstep ); % pobranie fragmentu sygna�u
   if(bx'*bx >= prog) break; end                      % przerwij, je�li energia > od progu
end
for nr2 = Nramek :-1: nr1                             % DETEKCJA ciszy na ko�cu nagrania
   bx = xn( 1+(nr2-1)*Mstep : Mlen + (nr2-1)*Mstep ); % pobranie fragmentu sygna�u
   if(bx'*bx >= prog) break; end                      % przerwij, je�li energia > od progu
end

y = x( 1+(nr1-1)*Mstep : Mlen + (nr2-1)*Mstep );      % obci�cie cichych brzeg�w

subplot(211); plot(x); title('przed obci�ciem');      % sprawdzenie wzrokowe
subplot(212); plot(y); title('po obci�ciu');          % skuteczno�ci obci�cia brzeg�w
