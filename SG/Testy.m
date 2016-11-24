  clear all; close all;
  
  global Mlen Mstep Np Nc     %  parametry globalne opisane poni�ej
  
  fpr = 44100;%8000;          %  cz�stotliwo�� pr�bkowania
  Np = 10;                    %  liczba biegun�w w filtrze predykcji
  Nc = 12;                    %  liczba wyznaczanych wsp�czynnik�w cepstralnych
  twind = 30;                 %  d�ugo�� okna obserwacji (ramki danych) w milisekundach
  tstep = 10;                 %  przesuni�cie pomi�dzy kolejnymi po�o�eniami okna w milisekundach
  Mlen  = (twind*0.001)*fpr;  %  liczba pr�bek okna (ramki danych)
  Mstep = (tstep*0.001)*fpr;  %  liczba pr�bek przesuni�cia pomi�dzy kolejnymi po�o�eniami okna
  
  slowa = {'lewo'; 'prawo'; 'start'; 'stop'};
  imie='Marcin';
  
  M = length( slowa );        %  liczba rozpoznawanych s��w
  
% Tworzenie bazy wzorc�w
  Cwzr = [];
  recorder=audiorecorder(fpr,8,1);
  for k = 1 : M
      load([slowa{k} '_' imie '_1']);
      wz=y(:,1);
      %wz = wavrecord(3*fpr, fpr, 1);              %  liczba pr�bek, cz. pr�bkowania, jeden kana�
      wz = cisza( wz, fpr );                      %  usu� ciche brzegi na pocz�tku i ko�cu nagrania
     [Cwz, Nramek] = cepstrum( wz );              %  oblicz macierz wsp�czynnik�w cepstralnych
     [Nw, Nk] = size(Cwz);                        %  odczytaj wymiary macierzy
     Cwzr(1:Nw,1:Nk,k) = Cwz ;  Nwzr(k)=Nramek;   %  dodaj j� do zbioru wzorc�w
  end
  
% Rozpoznawanie s�owa, kt�re ma sw�j wzorzec w bazie 
  for sl=1:4
      for pr=1:4
          load([slowa{sl} '_' imie '_' num2str(pr)]);
          x=y(:,1);
          %x = wavrecord(3*fpr, fpr, 1);        %  liczba pr�bek, cz. pr�bkowania, liczba kana��w
          x = cisza( x, fpr );                 %  usu� ciche brzegi na pocz�tku i ko�cu nagrania
          disp('Cisza');
          Cx = cepstrum( x );                  %  oblicz macierz wsp�czynnik�w cepstralnych
          disp('Cepstrum');
          nr = dtw( Cx, Cwzr, Nwzr );          %  rozpoznaj s�owo metod� DTW; zwr�� numer wzorca
          disp('DWT');
          disp( strcat( 'Powiedziano s�owo: ', slowa(nr) ) );
      end
  end
