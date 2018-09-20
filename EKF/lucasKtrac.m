%Test Script

dataDir = 'D:/thesis/codes/mpc3highdensity.avi';

cv = VideoReader(dataDir);
all_xy_time = read(cv);
k = 3;
[m,n,c,frm] = size(all_xy_time);
Im = cell(frm,1);
trackMatx = cell(1,frm);
ct = 0;

% Im{1} =all_xy_time(:,:,:,1);
[Centt,cellbox] = blobdet(all_xy_time(:,:,:,1),all_xy_time(:,:,:,1200));
trackMatx{1,1} = Centt;    
value = 1:size(Centt,1);
position=cellbox(:,1:2);
% RGB = insertMarker(Im{1},Centt,'+','color','blue','size',6);
% Im{1} = insertText(RGB,position,value,'AnchorPoint','RightTop','BoxOpacity',0,'TextColor','green');
i=2;
%for i=201:1:frm-100
    point_track = vision.PointTracker('MaxBidirectionalError', 2);
    if(size(Centt,1)~=0)
        
        initialize(point_track,Centt,all_xy_time(:,:,:,i-1));
        [pts,vl]=step(point_track,all_xy_time(:,:,:,i));
        %Saving Tracks 
        D = pdist2(Centt,pts);
        D = D';
        [~,Idx]=sort(D);
        pts = pts(Idx(1,:),:);
        %trackMatx{1,2} = pts;
        %end of saving tracks
        
        [x,~] = find(pts(:,1)<762);
        pts1 = pts(x,:);
        value = 1:size(pts1,1);
        position=cellbox(x,1:2);
%         if(x~=0)
%             RGB=insertMarker(all_xy_time(:,:,:,i),pts1,'+','color','blue','size',6);
%             Im{i} = insertText(RGB,position,value,'AnchorPoint','RightTop','BoxOpacity',0,'TextColor','green');
%         end
    else
        ppp=0;
%         Im{i} = all_xy_time(:,:,:,i);
    end

   %[Centt,cellbox] = blobdet(all_xy_time(:,:,:,i),all_xy_time(:,:,:,1200));
    
    release(point_track);
    
%end

% bv = VideoWriter('klttrack_cons_frame_update.avi');
% open(bv);
% 
% for i=1:1:frm
%     writeVideo(bv,Im{i});
% end
% close(bv);

