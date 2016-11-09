function komenda(y)

%% Analysis
order=9;
wname='dmey';
[C,L]=wavedec(y,order,wname);
sums=cumsum(L);
DWT_val=zeros(1,order+1);
DWT_val(1)=sqrt(sum(C(1:L(1)).^2)/L(1));
for i=2:order+1
    DWT_val(i)=sqrt(sum(C(sums(i-1)+1:sums(i)).^2)/L(i));
end
six=DWT_val(6)/max(DWT_val);

%% Decision
if DWT_val(9)/max(DWT_val)>0.05
    if six>0.27
        disp('Start');
    else
        disp('Stop');
    end
else
    if six>0.1
        disp('Prawo');
    else
        disp('Lewo');
    end
end
end