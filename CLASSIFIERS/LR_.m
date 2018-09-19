load('newHoG4x4.mat')
labl=zeros(96,1);
labl([1,6,7,13,17,96])=1;
classLabel=labl;
for pp=[9,10,11,12,13]
load('AllEllipticFeatinCell.mat')
dataDir = 'D:/thesis/codes/mpc3highdensity.avi';
ct=0;
cv = VideoReader(dataDir);
all_xy_time = read(cv);
k = 3;
[m,n,c,frm] = size(all_xy_time);
Im = cell(frm,1);
%frmWithBlob = cell(size(newTrak,2),1);
%frameBlobs = cell(frm,1);
backim = imread('backim.jpg');
discnt = 0;



% %TRAIN DATA
% %Don't Run
% load('Cell_HOG_Feature_Vectors.mat')
% load('GoFAllCells.mat')
% load('EccAll.mat')
% hogfeat{21} = [];
% hogfeat{71} = [];
% 
for i =1:1:size(hogfeat,2)
    if(size(hogfeat{i},1)>500)
        hogfeat{i} = hogfeat{i}([1:60,size(hogfeat{i},1)-60:size(hogfeat{i},1)],:);
        ecc{i} = ecc{i}([1:60,size(hogfeat{i},1)-60:size(hogfeat{i},1)]);
        axrt{i} = axrt{i}([1:60,size(hogfeat{i},1)-60:size(hogfeat{i},1)]);
        gof{i} = gof{i}([1:60,size(hogfeat{i},1)-60:size(hogfeat{i},1)]);
    end
end
% 
 hogfeat = hogfeat';
 ecc=ecc';
 axrt=axrt';
 gof=gof';
 
% 
 ecc = vertcat(ecc{:});
 %ecc = ecc';
% clear eccc
 gof = vertcat(gof{:});
 %gof = gof';
 axrt = vertcat(axrt{:});
 %axrt = axrt';
 
TheData = [hogfeat{1},repmat(classLabel(1),size(hogfeat{1},1),1)];

for i =2:1:size(hogfeat,1)
    if(~isempty(hogfeat{i}))
        TheData = [TheData;[hogfeat{i},repmat(classLabel(i),size(hogfeat{i},1),1)]];
    end
end
 
clabel = TheData(:,size(TheData,2));
 TheData = [TheData(:,1:size(TheData,2)-1),ecc,gof,axrt,clabel];
%TheData = [TheData(:,1:size(TheData,2)-1),clabel];
% save('TheHoGData_3x3_with_Ecc_and_gof','TheData')
% %Don't Run

%RUN FROM HERE
%load('TheHOGData_3x3_with_Ecc_and_gof.mat')
TheData = TheData(1:1200,:);
% [~,score] = pca(TheData(:,1:size(TheData,2)-1));
% dim = 41;
% TheData = [score(:,1:dim),TheData(:,size(TheData,2))];
%TEST DATA
frm =pp;
[cntt,cellbox,im] = blobdetBackim(all_xy_time(:,:,:,frm),backim);
size(cellbox,1)
for k=1:1:size(cellbox,1)
    position=cellbox(k,1:2);
    bbox = round([position, cellbox(k,3),cellbox(k,4)]);
    img =im(bbox(2):bbox(2)+bbox(4),bbox(1):bbox(1)+bbox(3));
    
    %
    imx = im2double(img);
    binim  = im2bw(imx,0.04);
    %
    %forHOG
    img(img(:,:)<6)=0;
    
    %Eccentricity Calculation
    s = regionprops(binim,'Centroid','Area','MajorAxisLength','MinorAxisLength');
    [val,imx] = max([s.Area]);
    cn = s(imx,:).Centroid;
    [row,col] = find(binim==1);
    indxs = [row,col];
    centered = indxs-repmat(cn,size(indxs,1),1);
    C = cov(centered);
    [U,S,V]=eig(C);
    ellaxis = diag(S);
    majtheta = (atan(V(1,1)/V(2,1))*(180/pi))-90;
    a = s(imx).MajorAxisLength/2;
    b = s(imx).MinorAxisLength/2;
    ecc_test = sqrt(1-(b/a)^2);
    axrt_test=a/b;
    %Ar = max(s(:).Area);
    gof_test = val/(pi*a*b);
    %End of Eccentricity & goodness of fit Calculation
   
    img = imresize(img,[14 15]);
    [hogv] = extractHOGFeatures(img,'CellSize',[4 4]);
    
    hog_test(k,:) = [hogv,ecc_test,gof_test,axrt_test];
    %hog_test(k,:) = hogv;
end

% [~,sc] = pca(hog_test(:,:));
% dim = 41;
% hog_test = sc(:,1:dim);
 svm_
% figure



% test_labels = LogisticRegression(TheData,hog_test);
% 
% for i=1:1:size(test_labels,1)
%     RGB = insertShape(all_xy_time(:,:,:,frm),'Rectangle',cellbox(i,:),'LineWidth',2);
%     if(test_labels(i)==0)
%         cl = sprintf('Class: %d',test_labels(i));
%         
%         all_xy_time(:,:,:,frm) = insertText(RGB,cellbox(i,1:2),cl,'AnchorPoint','CenterBottom',...
%             'BoxOpacity',0,'TextColor','green','FontSize',11);
%     else
%         cl = sprintf('Class: %d',test_labels(i));
%         
%         all_xy_time(:,:,:,frm) = insertText(RGB,cellbox(i,1:2),cl,'AnchorPoint','CenterBottom',...
%             'BoxOpacity',0,'TextColor','White','FontSize',11);
%     end
% end
% imshow(all_xy_time(:,:,:,frm))

figure
clear 

load('newHoG4x4.mat')
labl=zeros(96,1);
labl([1,6,7,13,17,96])=1;
classLabel=labl;

end

%TRAIN ERROR
% t_labels = LogisticRegression(TheData,TheData(:,1:434));
% train_labels=TheData(:,435);
% 
% incc=xor(t_labels,train_labels);
% 
% err=sum(incc)/size(incc,1);




