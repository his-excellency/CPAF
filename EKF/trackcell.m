dataDir = 'D:/thesis/codes/mpc3highdensity.avi';

cv = VideoReader(dataDir);
all_xy_time = read(cv);
k=3;
[m,n,c,frm] = size(all_xy_time);
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



%%%%EKF parameters%%%%
dt = 1;
q=0.01; %process std
Q = (q^2)*eye(4); %covariance of process
F = [1,0,dt,0;0,1,0,dt;0,0,1,0;0,0,0,1];
posx = centt(1,1);
posy = centt(1,2);
vx = 0;
vy = 0;
x_i = [posx;posy;vx;vy];%+q*randn(2,1);
X_k = x_i + q*rand(4,1); %initial state with noise
f = @(x) (((F*x)));
h = @(x) ([(x(1)+x(3)*dt);(x(2)+x(4)*dt);x(3);x(4)]);
%h = @(x) ((x));
R = [0.1 , 0,0,0; 0 , 0.1,0,0;0,0,0.1,0;0,0,0,0.1];
P = eye(4);

N = objendfrm - objstartfrm + 2;
mes = zeros(4,N);
for i=2:1:N
    if(i==2)
        z_k = h([centt(i-1,1);centt(i-1,2);0;0]) + 0.1*randn(4,1);
    else
        z_k = h([centt(i-1,1);centt(i-1,2);(centt(i-1,1)-centt(i-2,1))/dt;
            (centt(i-1,2)-centt(i-2,2))/dt]) + 0.1*randn(4,1);
    end
    mes(:,i-1)=z_k;
    [xp,X_k,P] = ekf(f,X_k,P,h,z_k,Q,R);
    centt_pred(:,i-1) = xp;
    X_k = f(X_k) + q*randn(4,1);
    %x_i = f(x_est) + q*randn(2,1);
end
%centt_est(1,:)=[centt(1,1);centt(1,2)];

imshow(all_xy_time(:,:,:,objstartfrm));
hold on
plot(centt(:,1),centt(:,2),'-b')
hold on
plot(centt_pred(1,:),centt_pred(2,:),'-y')
%%end of EKF %%%

%Velocity calculations
perframetime = 0.01;

for j=1:1:size(centt,1)-1
    d(j)=pdist2(centt(j,:),centt(j+1,:));
    d_est(j)=pdist2(centt_pred(1:2,j)',centt_pred(1:2,j+1)');
    vel(j)=d(j)/perframetime;
    vel_est(j)=d_est(j)/perframetime;
end

figure;
title('Velocity');
plot(vel,'-b');
hold on
plot(vel_est,'-k');

% imshow(frmvid)
% hold on
% plot(centt(2),centt(1),'*b');
%  bv = VideoWriter('kmeans_segmented_cells.avi');
%  open(bv);
%  
%  for i=1:1:frm
%      writeVideo(bv,outim{i});
%  end
%  close(bv);