for i=1:4
    load(['lewo_Karolina_' num2str(i)]);
    komenda(y(:,1));
    komenda(y(:,2));
end
for i=1:4
    load(['prawo_Karolina_' num2str(i)]);
    komenda(y(:,1));
    komenda(y(:,2));
end
for i=1:5
    load(['start_Karolina_' num2str(i)]);
    komenda(y(:,1));
    komenda(y(:,2));
end
for i=1:4
    load(['stop_Karolina_' num2str(i)]);
    komenda(y(:,1));
    komenda(y(:,2));
end