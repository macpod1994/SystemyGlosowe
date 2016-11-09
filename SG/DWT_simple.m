%% Load signal
load test_4;
y=sig(:,1);
t=(0:length(y)-1)'/fs;
order=9;
wname='dmey';
[C,L]=wavedec(y,order,wname);
%figure;
%plot(C);
times=zeros(1,order+1);
maxs=zeros(1,order+1);
thr=zeros(1,order+1);
sums=cumsum(L);
DWT_val=zeros(1,order+1);
DWT_val(1)=sqrt(sum(C(1:L(1)).^2)/L(1));
times(1)=(1:L(1))*abs(C(1:L(1)))/sum(abs(C(1:L(1))))/L(1);
[val,ind]=max(abs(C(1:L(1))));
maxs(1)=ind/L(1);
thr(1)=sum(abs(C(1:L(1)))>0.1)/L(1);
for i=2:order+1
    DWT_val(i)=sqrt(sum(C(sums(i-1)+1:sums(i)).^2)/L(i));
    times(i)=(1:L(i))*abs(C(sums(i-1)+1:sums(i)))/sum(abs(C(sums(i-1)+1:sums(i))))/L(i);
    [val,ind]=max(abs(C(sums(i-1)+1:sums(i))));
    maxs(i)=ind/L(i);
    thr(i)=sum(abs(C(sums(i-1)+1:sums(i)))>0.1)/L(i);
end
six=DWT_val(6)/max(DWT_val);
figure;
hold on;
plot(DWT_val,'b');
plot(times,'r');
plot(maxs,'g');
plot(thr,'m');
plot(six,'*');