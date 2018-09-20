%load('OLE_DATA.mat')
ct=1;
for i=1:1:size(Cenntpredmin,2)
    if(~isempty(Cenntpredmin{i}))
        errdis{ct}=Cenntpredmin{i};
    end
    ct=ct+1;
end

for i=1:1:size(errdis,2)
    innAv(i)=sum(errdis{i})/size(errdis{i},1);
end

OTE = sum(innAv)/size(innAv,2);