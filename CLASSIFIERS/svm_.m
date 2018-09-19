%run videoreader from LR_

% load('TheHoGData_3x3_with_Ecc_and_gof')
TheData = TheData(1:1200,:);

options = statset('MaxIter',20000)

SVMStruct = svmtrain(TheData(:,1:size(TheData,2)-1),TheData(:,size(TheData,2)),'options',options);

%Get Test Data From LR_

test_labels = svmclassify(SVMStruct,hog_test);

for i=1:1:size(test_labels,1)
    RGB = insertShape(all_xy_time(:,:,:,frm),'Rectangle',cellbox(i,:),'LineWidth',2);
    if(test_labels(i)==0)
        cl = sprintf('Class: %d',test_labels(i));
        
        all_xy_time(:,:,:,frm) = insertText(RGB,cellbox(i,1:2),cl,'AnchorPoint','CenterBottom',...
            'BoxOpacity',0,'TextColor','green','FontSize',11);
    else
        cl = sprintf('Class: %d',test_labels(i));
        
        all_xy_time(:,:,:,frm) = insertText(RGB,cellbox(i,1:2),cl,'AnchorPoint','CenterBottom',...
            'BoxOpacity',0,'TextColor','White','FontSize',11);
    end
end
imshow(all_xy_time(:,:,:,frm))

% %TRAIN ERROR
% t_labels = svmclassify(SVMStruct,TheData(:,1:434));
% train_labels=TheData(:,435);
% 
% incc=xor(t_labels,train_labels);
% 
% err=sum(incc)/size(incc,1);