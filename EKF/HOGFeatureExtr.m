dataDir = 'D:/thesis/codes/CellsCropped.avi';
ct=0;
cv = VideoReader(dataDir);
all_xy_time = read(cv);
k = 3;
[m,n,c,frm] = size(all_xy_time);
Im = cell(frm,1);
frmWithBlob = cell(size(newTrak,2),1);
%frameBlobs = cell(frm,1);
backim = imread('backim.jpg');
discnt = 0;

for i=1:1:size(newTrak,2)
    frmWithBlob{i} = (reqObjFrm(i):(size(newTrak{i},1)+reqObjFrm(i)-1))';
end
%All frames in which each object is visible
frmWithBlob = frmWithBlob';

for i=1:1:size(frmWithBlob,2)
    for j=1:1:size(frmWithBlob{i},1)
        [cntt,cellbox] = blobdet(all_xy_time(:,:,:,frmWithBlob{i}(j)),backim);
        value = i;
        D = pdist2(newTrak{i}(j,:),cellbox(:,1:2));
        [~,idx]=min(D);
        position=cellbox(idx,1:2);
        %Distance based class labels
        % 30 for start frame 
        if(i<96 && j>30)
            ds = pdist2(newTrak{i}(j-1,:),newTrak{i}(j,:));
            if(ds<4)
                discnt = discnt + 1;
            end
            if(discnt>25)
                %RGB = insertShape(all_xy_time(:,:,:,frmWithBlob{i}(j)),'Rectangle',cellbox(idx,:),'LineWidth',2);
                [hog1,valpt, Viz] = extractHOGFeatures(all_xy_time(:,:,:,frmWithBlob{i}(j)),cntt(idx,:),...
                    'CellSize',[2 2],'NumBins',18);
                
                if(~(isempty(hog1)))
                    hogCell{i}(j-30,:)= hog1;
                else
                    hogCell{i}(j-30,:)= zeros(1,36);
                end
                
                classLabel(i) = 1;
%                 all_xy_time(:,:,:,frmWithBlob{i}(j)) = insertText(RGB,position,value,'AnchorPoint','RightTop',...
%                     'BoxOpacity',0,'TextColor','green');
%                 all_xy_time(:,:,:,frmWithBlob{i}(j)) = insertText(all_xy_time(:,:,:,frmWithBlob{i}(j)),position,...
%                     'Class: 1','AnchorPoint','CenterBottom',...
%                     'BoxOpacity',0,'TextColor','yellow','FontSize',11);
                ct=ct+1
            else
                %RGB = insertShape(all_xy_time(:,:,:,frmWithBlob{i}(j)),'Rectangle',cellbox(idx,:),'LineWidth',2);
                [hog1,valpt, Viz] = extractHOGFeatures(all_xy_time(:,:,:,frmWithBlob{i}(j)),cntt(idx,:),...
                    'CellSize',[2 2],'NumBins',18);
                if(~(isempty(hog1)))
                    hogCell{i}(j-30,:)= hog1;
                else
                    hogCell{i}(j-30,:)= zeros(1,36);
                end
                classLabel(i) =0;
%                 all_xy_time(:,:,:,frmWithBlob{i}(j)) = insertText(RGB,position,value,'AnchorPoint','RightTop',...
%                     'BoxOpacity',0,'TextColor','green');
%                 all_xy_time(:,:,:,frmWithBlob{i}(j)) = insertText(all_xy_time(:,:,:,frmWithBlob{i}(j)),position,...
%                     'Class: 0','AnchorPoint','CenterBottom',...
%                     'BoxOpacity',0,'TextColor','white','FontSize',11);
                ct=ct+1
            end
        else
        %end of distance based labeling
%         RGB = insertShape(all_xy_time(:,:,:,frmWithBlob{i}(j)),'Rectangle',cellbox(idx,:),'LineWidth',2);
%         all_xy_time(:,:,:,frmWithBlob{i}(j)) = insertText(RGB,position,value,'AnchorPoint','RightTop',...
%             'BoxOpacity',0,'TextColor','green');
        ct=ct+1
        end
    end
    
    ct=0;
    discnt=0;
end

save('Cell_HOG_Feature_Vectors','hogCell','classLabel')
