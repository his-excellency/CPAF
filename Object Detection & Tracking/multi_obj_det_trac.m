% dataDir = 'D:/thesis/codes/mpc3highdensity.avi';
% 
% cv = VideoReader(dataDir);
% all_xy_time = read(cv);
% k=3;
% [m,n,c,frm] = size(all_xy_time);
 boxim = cell(frm,1);
ct = 0;
%f=1;
for f=1:1:1%frm
    orgim =all_xy_time(:,:,:,f);
    
    img = rgb2gray(all_xy_time(:,:,:,f)-backim); %all_xy_time(:,:,:,1200))
    %img=im2double(img);
    g1 = fspecial('Gaussian', 21, 10);
    g2 = fspecial('Gaussian', 21, 15);
    dog = g1 - g2;
    dogfim = conv2(double(img), dog, 'same');
    imshow(dogfim)
    imgbin = im2bw(dogfim,0.20);
    [imagec, numc] = bwlabel(imgbin);
    cstats = regionprops(imagec, 'BoundingBox','Centroid');
    
    %centt(f,:) = cstats.Centroid;
    cellbox =zeros(size(cstats,1),4);
    
    for ii = 1:1:size(cstats,1)
        Ccellcentroid(ii,:) = cstats(ii).Centroid;
        cellbox(ii,:) = cstats(ii).BoundingBox;
    end
    value = 1:size(cellbox,1);
    position=cellbox(:,1:2);
    RGB = insertShape(orgim,'Rectangle',cellbox,'LineWidth',2);
    RGB = insertText(RGB,position,value,'AnchorPoint','RightTop','BoxOpacity',0,'TextColor','green');
    boxim{f} = RGB;
    figure;imshow(2*RGB)
    ct=ct+1
end

%imtool(RGB)
% hold on
% plot(round(Ccellcentroid(:,1)),round(Ccellcentroid(:,2)),'*b')

% bv = VideoWriter('detected_cells_1.avi');
% open(bv);
% 
% for i=1:1:1110
%     writeVideo(bv,2*boxim{i});
% end
% close(bv);