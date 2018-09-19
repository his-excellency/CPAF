function test_labels = LogisticRegression(train_data,test_bow)

train_labels = double(train_data(:,size(train_data,2)));
train_bow = train_data(:,1:size(train_data,2)-1);

%train_labels=double(train_labels');
ind=find(train_labels==-1);
train_labels(ind)=0;

[r,c]=size(train_bow);
w=zeros(c,1);

alpha=0.001;

l=0.8;
n=10000;
J=999;
i=0;
for i=1:1:n
%while(J>0.001)
    
    
    J=(train_labels'*((train_bow*w)...
        -log(1+sigmf(train_bow*w,[1 0]))+(l/2)*(w'*w)));
    if(isnan(J))
        J=10;
    end

    w = w - (alpha).*((train_bow)'*(sigmf(train_bow*w,[1 0])-train_labels)+l*w);
    
 end


test_labels=zeros(size(test_bow,1),1);
Pred=test_bow*w;
indp=find(Pred>=0);
indn=find(Pred<0);
test_labels(indp)=1;
test_labels(indn)=0;


end



    