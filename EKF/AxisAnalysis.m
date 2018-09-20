%Run connectTracks.m
%Run associatedlabels.m upto line 18
%red=[4,5,22,30,32,60,77,94]
%green=[96,98,100,103,104,105,107,108]
f=98;
fps=30;
newTrak_ob1 = cell2mat(newTrak(f));
frmWithBlob_ob1 = cell2mat(frmWithBlob(f));


for jj=1:1:size(newTrak{f},1)-1
    d = pdist2(newTrak{f}(jj,:),newTrak{f}(jj+1,:));
    vel(jj) = d/(1/fps);
end

[~,il] = findpeaks(-1*vel,'MINPEAKDISTANCE',3);


%     if(f==100)
%         pp=3;
%     end
for j=2:1:size(frmWithBlob_ob1,1)
    [centt,cellbox,img] = blobdetBackim(all_xy_time(:,:,:,frmWithBlob_ob1(j)),backim);
    value = 1;
    
    D = pdist2(newTrak_ob1(j,:),cellbox(:,1:2));
    [d,idx]=min(D);
    position=[cellbox(idx,1)-d/2,cellbox(idx,2)-d/2];
    bbox = round([position, cellbox(idx,3)+d,cellbox(idx,4)+d]);
    %RGB = insertShape(all_xy_time(:,:,:,frmWithBlob_ob1(j)),'Rectangle',bbox,'LineWidth',1);
    obj1{j-1} = img(bbox(2):bbox(2)+bbox(4),bbox(1):bbox(1)+bbox(3),:);
    
end

%Load the values
%Code for Ellipse Fitting
%load('Cell_3_green.mat');

ct=1;
for k=1:1:size(obj1,2)
%for k=il
    im = im2double(obj1{k});
    binim  = im2bw(im,0.04);
    k
    s = regionprops(binim,'Centroid','Area','MajorAxisLength','MinorAxisLength');
    for i=1:1:size(s,1)
        ss(i)=s(i).Area;
    end
    [~,maxidx]=max(ss);
    cn = s(maxidx,:).Centroid;
    [row,col] = find(binim==1);
    indxs = [row,col];
    centered = indxs-repmat(cn,size(indxs,1),1);
    
 
    C = cov(centered);
    [U,S,V]=eig(C);
    ellaxis = diag(S);
    majtheta = (atan(V(1,1)/V(2,1))*(180/pi))-90;

    %a = ellaxis(2)/2;
    a=s(maxidx).MajorAxisLength/2;
    aa(k)=a;
    %[a,a1,a/a1]
    %b = ellaxis(1)/2;
    b = s(maxidx).MinorAxisLength/2;
    bb(k)=b;
    %ecc(k) = sqrt(1-(b/a)^2);
    gof(k) = s(maxidx,:).Area/(pi*a*b);
    trad = majtheta*(pi/180);
    ori(k) = trad;
    t = linspace(0,2*pi);
    %plot ellipse
    X(k,:) = cn(1,1) + a*cos(t)*cos(trad) - b*sin(t)*sin(trad);
    Y(k,:) = cn(1,2) + a*cos(t)*sin(trad) + b*sin(t)*cos(trad);
    
    
    imshow(binim,'Initialmagnification',400)
    hold on
    plot(X(k,:),Y(k,:))
    pause(0.2)
    clear ss
    
    %if(k==il(ct))
%         majax(ct) = a;
%         minax(ct) = b;
%         centrr(ct,:) = cn; 
%         ori(ct) = majtheta;
%         eccEvent(ct) = ecc(k);
%         CellIm{ct} = obj1{k};
%         ellipseX{ct} = X;
%         ellipseY{ct} = Y;
%         ct=ct+1;
    %end
    
        %subplot(4,4,ct)
%         imshow(im)
%         hold on
%         plot(X,Y,'-b')
end

% filename = sprintf('GREEN_CELLS/Cell_%d/cell_%d_props_Collision_EVENTS',f,f);
% %mkdir(filename);
% save(filename,'majax','minax','centrr','ori','eccEvent','CellIm','ellipseX','ellipseY');
% clear majax minax ori eccEvent CellIm ellipseX ellipseY centrr obj1 ecc il vel








