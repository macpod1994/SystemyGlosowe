for i=1:8
    load(['test_' num2str(i)]);
    komenda(sig(:,1));
    komenda(sig(:,2));
end