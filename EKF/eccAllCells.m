%f=[1:20,22,24:53,55:67,69:70,72:74,76:95]
fps=30;
for f = 108
    newTrak_ob1 = cell2mat(newTrak(f));
    frmWithBlob_ob1 = cell2mat(frmWithBlob(f));
    
    
    %     for jj=1:1:size(newTrak{f},1)-1
    %         d = pdist2(newTrak{f}(jj,:),newTrak{f}(jj+1,:));
    %         vel(jj) = d/(1/fps);
    %     end
    %
    %     [~,il] = findpeaks(-1*vel,'MINPEAKDISTANCE',3);
    f
    for j=2:1:size(frmWithBlob_ob1,1)
        [centt,cellbox,img] = blobdetBackim(all_xy_time(:,:,:,frmWithBlob_ob1(j)),backim);
        value = 1;
        
        D = pdist2(newTrak_ob1(j,:),cellbox(:,1:2));
        [d,idx]=min(D);
        position=[cellbox(idx,1)-d/2,cellbox(idx,2)-d/2];
        %position=[cellbox(idx,1),cellbox(idx,2)];
        bbox = round([position, cellbox(idx,3),cellbox(idx,4)]);
        %RGB = insertShape(all_xy_time(:,:,:,frmWithBlob_ob1(j)),'Rectangle',bbox,'LineWidth',1);
        obj1{j-1} = img(bbox(2):bbox(2)+bbox(4),bbox(1):bbox(1)+bbox(3),:);
        
    end
    
    
    ct=1
    for k=1:1:size(obj1,2)
        %for k=il
        im = im2double(obj1{k});
        binim  = im2bw(im,0.08);
        s = regionprops(binim,'Centroid','Area');
        if(size(s,1)~=0)
            cn = s(1,:).Centroid;
            
            [row,col] = find(binim==1);
            indxs = [row,col];
            centered = indxs-repmat(cn,size(indxs,1),1);
            C = cov(centered);
            [U,S,V]=eig(C);
            ellaxis = diag(S);
            majtheta = (atan(V(1,1)/V(2,1))*(180/pi))-90;
            
            a = ellaxis(2)/2;
            b = ellaxis(1)/2;
            ecc{f}(k) = sqrt(1-(b/a)^2);
            gof{f}(k) = s(1,:).Area/(pi*a*b);
        else
            gof{f}(k) = 0;
        end
%         trad = majtheta*(pi/180);
%         t = linspace(0,2*pi);
        
        ct=ct+1
        
    end
    clear obj1
end