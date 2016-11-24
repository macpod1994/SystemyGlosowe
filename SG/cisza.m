
% ------------------------------------------
% Tabela 19-5 (str. 574)
% Æwiczenie:  Rozpoznawanie izolowanych s³ów
% ------------------------------------------

function y = cisza(x, fpr)
% usuniêcie ciszy na pocz¹tku i koñcu s³owa

dt1 = 0.010; Mlen  = floor(dt1*fpr); % d³ugoœæ okna czasowego do liczenia energii [msek], liczba próbek
dt2 = 0.001; Mstep = floor(dt2*fpr); % przesuniêcie okna czasowego [msek], liczba próbek
prog = 0.25*fpr/8000;                % próg g³oœnoœci

N = length(x);                       % d³ugoœæ sygna³u
Nramek = floor((N-Mlen)/Mstep+1);    % liczba fragmentów (ramek) jest do przetworzenia

xn = x / max(abs(x));                                 % normowanie
for nr1 = 1 : Nramek                                  % DETEKCJA ciszy na pocz¹tku nagrania
   bx = xn( 1+(nr1-1)*Mstep : Mlen + (nr1-1)*Mstep ); % pobranie fragmentu sygna³u
   if(bx'*bx >= prog) break; end                      % przerwij, jeœli energia > od progu
end
for nr2 = Nramek :-1: nr1                             % DETEKCJA ciszy na koñcu nagrania
   bx = xn( 1+(nr2-1)*Mstep : Mlen + (nr2-1)*Mstep ); % pobranie fragmentu sygna³u
   if(bx'*bx >= prog) break; end                      % przerwij, jeœli energia > od progu
end

y = x( 1+(nr1-1)*Mstep : Mlen + (nr2-1)*Mstep );      % obciêcie cichych brzegów

subplot(211); plot(x); title('przed obciêciem');      % sprawdzenie wzrokowe
subplot(212); plot(y); title('po obciêciu');          % skutecznoœci obciêcia brzegów
