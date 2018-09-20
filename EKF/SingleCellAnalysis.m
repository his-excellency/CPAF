%run the two files then run this
%f=[1:20,22,24:53,55:67,69:70,72:74,76:95]
%Thresholds for green are 6 and 0.08
%Thresholds for red are 8 and 0.03
fps=30;
ct=0;
for f = [1:22,24:53,55:67,69:74,76:96]
    newTrak_ob1 = cell2mat(newTrak(f));
    frmWithBlob_ob1 = cell2mat(frmWithBlob(f));
    
%     for jj=1:1:size(newTrak{f},1)-1
%         d = pdist2(newTrak{f}(jj,:),newTrak{f}(jj+1,:));
%         vel(jj) = d/(1/fps);
%     end
%     
%     [~,il] = findpeaks(-1*vel,'MINPEAKDISTANCE',3);%velocity drop indexes
    
%     for j=2:1:size(frmWithBlob_ob1,1)
%         I = all_xy_time(:,:,:,frmWithBlob_ob1(j));
%         [centt,cellbox,img] = blobdetBackim(I,backim);
%         value = 1;
%         
%         D = pdist2(newTrak_ob1(j,:),cellbox(:,1:2));
%         [d,idx]=min(D);
%         position=[cellbox(idx,1)-d/2,cellbox(idx,2)-d/2];
%         %position=[cellbox(idx,1),cellbox(idx,2)];
%         bbox = round([position, cellbox(idx,3)+d,cellbox(idx,4)+d]);
%         %RGB = insertShape(all_xy_time(:,:,:,frmWithBlob_ob1(j)),'Rectangle',bbox,'LineWidth',1);
%         ims = img(bbox(2):bbox(2)+bbox(4),bbox(1):bbox(1)+bbox(3),:);
%         %ims(ims(:,:)<6)=0;%Threshold 1
%         objCellsma{j-1} = ims; 
%         cellrgbsma{j-1} = I(bbox(2):bbox(2)+bbox(4),bbox(1):bbox(1)+bbox(3),:);
%     end
    for j=2:1:size(frmWithBlob{f},1)
        [cntt,cellbox,im] = blobdetBackim(all_xy_time(:,:,:,frmWithBlob{f}(j)),backim);
        D = pdist2(newTrak{f}(j,:),cellbox(:,1:2));
        [~,idx]=min(D);
        position=cellbox(idx,1:2);
        bbox = round([position, cellbox(idx,3),cellbox(idx,4)]);
        objCellsma{j-1} =im(bbox(2):bbox(2)+bbox(4),bbox(1):bbox(1)+bbox(3));
    end
    f
    size(objCellsma,2)
    for k=1:1:size(objCellsma,2)
        %for k=il
        im = im2double(objCellsma{k});
        binim  = im2bw(im,0.04);%threshold 2
        s = regionprops(binim,'Centroid','Area','MajorAxisLength','MinorAxisLength');
        if(size(s,1)~=0)
            [val,imx] = max([s.Area]);
            cn = s(imx,:).Centroid;
            [row,col] = find(binim==1);
            indxs = [row,col];
            centered = indxs-repmat(cn,size(indxs,1),1);
            C = cov(centered);
            [U,S,V]=eig(C);
            ellaxis = diag(S);
            majtheta = (atan(V(1,1)/V(2,1))*(180/pi))-90;
            
            a{f}(k) = s(imx).MajorAxisLength/2;
            b{f}(k) = s(imx).MinorAxisLength/2;
            ecc{f}(k) = sqrt(1-(b{f}(k)/a{f}(k))^2);
            gof{f}(k) = val/(pi*a{f}(k)*b{f}(k));
        else
            gof{f}(k) = 0;
        end

%         trad(k) = majtheta*(pi/180);
%         t = linspace(0,2*pi);
%         %plot ellipse
%         X(k,:) = cn(1,1) + a{f}(k)*cos(t)*cos(trad(k)) - b{f}(k)*sin(t)*sin(trad(k));
%         Y(k,:) = cn(1,2) + a{f}(k)*cos(t)*sin(trad(k)) + b{f}(k)*sin(t)*cos(trad(k));
        %ct=ct+1
%         imshow(binim,'Initialmagnification',400)
%         hold on
%         plot(X(k,:),Y(k,:))
%         pause(0.1)
    end
    
    clear objCellsma 
    
end

%save('SingleRedCellPropsma','objCellsma','cellrgbsma','a','b','gof','X','Y','vel','il','trad')
save('ellipticfeatures','a','b','gof','ecc')
%[7:12,18:25,30:39,46:53,61:70,81:88,95:100] for red label 4
%[1:5,9:12,17:20,25:29,35:39,44:48,54:59,64:69,74:76] for green label 108
%[1:3,6:9,12:15,19:22,26:30,35:41,48:54,60:67] for green label 107 then
%[1:26,30:33,37:end]
%[1:4,9:11,15:19,22:26,31:35,40:44,48:53,58:63] for green cell label 105
%then [1:11,15,18:end]
%[3:5,9:11,15:18,20:25,29:32,35:39,42:46,50:53] for green 103 then
%[1:9,13:end]
%[1:5,10:15,20:24,30:35,39:43,48:53,58:63,68:74]; for green 100
%then [1:32,35:end]
%[3:6,11:14,19:22,26:30,34:36,40:44,48:51] for red 61
%[1:3,7:10,13:16,20:23,28:31,34:37,41:44,48:51] for red 32
%[5:11,16:20,25:30,35:39,43:47,51:55,60:63] for red 60
%[1:4,10:15,21:27,33:39,45:52,58:64,70:76,82:86] for red 94
