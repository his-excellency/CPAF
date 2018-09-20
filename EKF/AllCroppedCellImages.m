dataDir = 'D:/thesis/codes/CellsCropped.avi';
ct=0;
cv = VideoReader(dataDir);
all_xy_time = read(cv);
k = 3;
[m,n,c,frm] = size(all_xy_time);
%Im = cell(frm,1);
frmWithBlob = cell(size(newTrak,2),1);
%frameBlobs = cell(frm,1);
backim = imread('backim.jpg');
discnt = 0;
% mkdir('AllCellImagesActual');

for i=1:1:size(newTrak,2)
    frmWithBlob{i} = (reqObjFrm(i):(size(newTrak{i},1)+reqObjFrm(i)-1))';
end
%All frames in which each object is visible
frmWithBlob = frmWithBlob';

for i=[1:22,24:53,55:67,69:74,76:96] %size(frmWithBlob,2)
    for j=2:1:size(frmWithBlob{i},1)
        [cntt,cellbox,im] = blobdetBackim(all_xy_time(:,:,:,frmWithBlob{i}(j)),backim);
        D = pdist2(newTrak{i}(j,:),cellbox(:,1:2));
        [~,idx]=min(D);
        position=cellbox(idx,1:2);
        bbox = round([position, cellbox(idx,3),cellbox(idx,4)]);
        img =im(bbox(2):bbox(2)+bbox(4),bbox(1):bbox(1)+bbox(3));
        img(img(:,:)<6)=0;
%        obj1{j-1}=img;
        %Resizing - a seemingly necessary step for HoG
        img = imresize(img,[14 15]);
        [hog,~] = extractHOGFeatures(im2double(img),'CellSize',[4 4]);
        obj1{j-1} = img;
        hogfeat{i}(j-1,:) = hog;
        ct=ct+1
    end
%     ff = sprintf('AllCellImagesActual/Cell_%d_Image',i);
%     save(ff,'obj1');
%     clear obj1
     ct=0;
end


%save('Cell_HOG_Feature_Vectors',hogfeat);