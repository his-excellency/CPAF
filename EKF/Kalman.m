% dataDir = 'D:/thesis/codes/mpc3highdensity.avi';
% 
% cv = VideoReader(dataDir);
% all_xy_time = read(cv);
% k=3;
% [m,n,c,frm] = size(all_xy_time);
ct=0;
objstartfrm = 1026;
objendfrm = 1110;
for ff=objstartfrm:1:objendfrm;
    frmvid = all_xy_time(:,:,:,ff)-all_xy_time(:,:,:,1200);
    frmvid(:,:,1)=0;
    [imagec, numc] = bwlabel(im2bw(rgb2gray(frmvid)));
    cstats = regionprops(imagec, 'BoundingBox','Centroid');
    centt(ff,:) = cstats.Centroid;
    ct=ct+1;
end

centt = centt(objstartfrm:objendfrm,:);


dt = 0.7;
m = [centt(1,1);centt(1,2);0;0];
c = [0;0;0;0];
x = m + 0.2*randn(4,1);

A = [1,0,dt,0;0,1,0,dt;0,0,1,0;0,0,0,1];
B = eye(4);

H = [1,0,1,0;0,1,0,1;0,0,0,0;0,0,0,0];
Q = [0,0,0,0;0,0,0,0;0,0,0.2,0;0,0,0,0.3];

R = 0.1*eye(4);

P = eye(4);
I = eye(4);

N = objendfrm - objstartfrm + 2;

for j=2:1:N
    
    
    %Predict
    x = A*x + B*c;
    predx = (A*x)+(B*c);
    centpred(j-1,:)=[predx(1),predx(2)];
    P = A*P*A' + Q;
    %correct
    S = (H*P*H')+R;
    K = (P*H')*inv(S);
    y = m - (H*x);
    %estimate of true position & velocity
    x = x+(K*y);
    P = (I-(K*H))*P;
    
    centest(j-1,:) = [x(1),x(2)];
    
    %new measurement
    if(j<N)
    m = [centt(j,1);centt(j,2);(centt(j,1) - centt(j-1,1))/dt;(centt(j,2) - centt(j-1,2))/dt];
    end

    


end

imshow(all_xy_time(:,:,:,objstartfrm));
hold on
plot(centt(:,1),centt(:,2),'-b')
hold on
plot(centest(:,1),centest(:,2),'-y')
hold on
plot(centpred(:,1),centpred(:,2),'-w')

