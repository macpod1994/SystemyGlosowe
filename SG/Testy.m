  clear all; close all;
  
  global Mlen Mstep Np Nc     %  parametry globalne opisane poni¿ej
  
  fpr = 44100;%8000;          %  czêstotliwoœæ próbkowania
  Np = 10;                    %  liczba biegunów w filtrze predykcji
  Nc = 12;                    %  liczba wyznaczanych wspó³czynników cepstralnych
  twind = 30;                 %  d³ugoœæ okna obserwacji (ramki danych) w milisekundach
  tstep = 10;                 %  przesuniêcie pomiêdzy kolejnymi po³o¿eniami okna w milisekundach
  Mlen  = (twind*0.001)*fpr;  %  liczba próbek okna (ramki danych)
  Mstep = (tstep*0.001)*fpr;  %  liczba próbek przesuniêcia pomiêdzy kolejnymi po³o¿eniami okna
  
  slowa = {'lewo'; 'prawo'; 'start'; 'stop'};
  imie='Marcin';
  
  M = length( slowa );        %  liczba rozpoznawanych s³ów
  
% Tworzenie bazy wzorców
  Cwzr = [];
  recorder=audiorecorder(fpr,8,1);
  for k = 1 : M
      load([slowa{k} '_' imie '_1']);
      wz=y(:,1);
      %wz = wavrecord(3*fpr, fpr, 1);              %  liczba próbek, cz. próbkowania, jeden kana³
      wz = cisza( wz, fpr );                      %  usuñ ciche brzegi na pocz¹tku i koñcu nagrania
     [Cwz, Nramek] = cepstrum( wz );              %  oblicz macierz wspó³czynników cepstralnych
     [Nw, Nk] = size(Cwz);                        %  odczytaj wymiary macierzy
     Cwzr(1:Nw,1:Nk,k) = Cwz ;  Nwzr(k)=Nramek;   %  dodaj j¹ do zbioru wzorców
  end
  
% Rozpoznawanie s³owa, które ma swój wzorzec w bazie 
  for sl=1:4
      for pr=1:4
          load([slowa{sl} '_' imie '_' num2str(pr)]);
          x=y(:,1);
          %x = wavrecord(3*fpr, fpr, 1);        %  liczba próbek, cz. próbkowania, liczba kana³ów
          x = cisza( x, fpr );                 %  usuñ ciche brzegi na pocz¹tku i koñcu nagrania
          disp('Cisza');
          Cx = cepstrum( x );                  %  oblicz macierz wspó³czynników cepstralnych
          disp('Cepstrum');
          nr = dtw( Cx, Cwzr, Nwzr );          %  rozpoznaj s³owo metod¹ DTW; zwróæ numer wzorca
          disp('DWT');
          disp( strcat( 'Powiedziano s³owo: ', slowa(nr) ) );
      end
  end
