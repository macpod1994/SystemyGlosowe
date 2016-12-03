%% Perform CWT of digit in English

%% Load signal
load start_Marcin;
y=sig(:,1);
t=(0:length(y)-1)'/fs;
figure;
plot(t,y);

%% Compute and plot CWT
freq=[2e2 fs/2];
wname='dmey';
fc=centfrq(wname);
scaler=fc*fs./(freq);
scales=floor(scaler(end)):1:ceil(scaler(1));
freqs=scal2frq(scales,wname,1/fs);
sig_cwt=cwt(y,scales,wname,'plot');

%% Compute DWT
order=9;
wname='dmey';
[C,L]=wavedec(y,order,wname);
figure;
subplot(order+1,1,1);
plot(C(1:L(1)));
for i=1:order;
    subplot(order+1,1,i+1);
    plot(C(sum(L(1:i))+1:sum(L(1:i+1))));
end

%% Compute SWT
order=9;
div=length(y)*2^(-7);
len=ceil(div)*2^7;
y_swt=[y; zeros(len-length(y),1)];
[SWA,SWD]=swt(y_swt,order,wname);
figure;
subplot(order+1,1,1);
plot(SWA(end,:));
for i=1:order
    subplot(order+1,1,order+2-i)
    plot(SWD(i,:));
end