imie='Karolina';
ilosc=[1 1 1 1];
for i=1:ilosc(1)
    name=['lewo_' imie '_'];
    [y,fs]=audioread([name num2str(i) '.mp3']);
    save([name num2str(i) '.mat'],'y','fs');
end
for i=1:ilosc(2)
    name=['prawo_' imie '_'];
    [y,fs]=audioread([name num2str(i) '.mp3']);
    save([name num2str(i) '.mat'],'y','fs');
end
for i=1:ilosc(3)
    name=['start_' imie '_'];
    [y,fs]=audioread([name num2str(i) '.mp3']);
    save([name num2str(i) '.mat'],'y','fs');
end
for i=1:ilosc(4)
    name=['stop_' imie '_'];
    [y,fs]=audioread([name num2str(i) '.mp3']);
    save([name num2str(i) '.mat'],'y','fs');
end