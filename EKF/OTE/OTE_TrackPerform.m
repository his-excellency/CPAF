dataDir = 'D:/thesis/codes/CellsCropped.avi';

cv = VideoReader(dataDir);
all_xy_time = read(cv);
k = 3;
[m,n,c,frm] = size(all_xy_time);
%Im = cell(frm,1);
%trackMatx = cell(1,frm);
% trackMatx1 = cell(1,frm);
% CenttMatx = cell(1,frm);
Cenntpredmin=cell(1,frm);
backim = imread('backim.jpg');
ct = 0;

%Im{1} =all_xy_time(:,:,:,1);
[Centt,cellbox] = blobdet(all_xy_time(:,:,:,1),backim);
%trackMatx{1,1} = Centt;    
%value = 1:size(Centt,1);
%position=cellbox(:,1:2);
%RGB = insertMarker(Im{1},Centt,'+','color','blue','size',6);
%Im{1} = insertText(RGB,position,value,'AnchorPoint','RightTop','BoxOpacity',0,'TextColor','green');

for i=2:1:frm
    point_track = vision.PointTracker('MaxBidirectionalError', 2);
    if(size(Centt,1)~=0)
        
        initialize(point_track,Centt,all_xy_time(:,:,:,i-1));
        [pts,vl]=step(point_track,all_xy_time(:,:,:,i));
        %Saving Tracks 
        D = pdist2(Centt,pts);
        [~,Idx]=sort(D,2);
        pts = pts(Idx(:,1),:);
       
        %end of saving tracks
        [x,~] = find(pts(:,1)<762);
        pts1 = pts(x,:);
        %trackMatx{1,i} = pts1;
        
%         value = 1:size(pts1,1);
%         position=cellbox(x,1:2);
        if(x~=0)
%             RGB=insertMarker(all_xy_time(:,:,:,i),pts1,'+','color','blue','size',6);
%             Im{i} = insertText(RGB,position,value,'AnchorPoint','RightTop','BoxOpacity',0,'TextColor','green');
              [Centtnext,~] = blobdet(all_xy_time(:,:,:,i),backim);
              D1 = pdist2(Centtnext,pts);
              Cenntpredmin{1,i}=min(D1,[],2);  
        end
%     else
%          Im{i} = all_xy_time(:,:,:,i);
    end

   [Centt,cellbox] = blobdet(all_xy_time(:,:,:,i),backim);
   
   
    
    release(point_track);
    ct=ct+1
    
end
save('OTE_DATA','Cenntpredmin');