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
q=0.4; %process std
Q = (q^2)*eye(2); %covariance of process
x_i = [centt(1,1);centt(1,2)];%+q*randn(2,1);
%X_k = x_i + q*rand(2,1); %initial state with noise
f = @(x) ((x));
h = @(x) (sin(x.^2));
R = [(var(centt(:,1))) , 0; 0 , (var(centt(:,2)))];
P = eye(2);

N = objendfrm - objstartfrm + 2;

for i=2:1:N
    z_k = h(x_i) + 0.2*randn(2,1);
    mes(i-1,:)=z_k;
    [x_est,P] = ukf(f,x_i,P,h,z_k,Q,R);
    centt_est(i-1,:) = x_est;
    x_i = f((centt(i-1,:))') + q*randn(2,1);
    %x_i = f(x_est) + q*randn(2,1);
end
%centt_est(1,:)=[centt(1,1);centt(1,2)];

imshow(all_xy_time(:,:,:,objstartfrm));
hold on
plot(centt(:,1),centt(:,2),'-b')
hold on
plot(centt_est(:,1),centt_est(:,2),'-y')

%Velocity calculations
perframetime = 0.01;

for j=1:1:size(centt,1)-1
    d=pdist2(centt(j,:),centt(j+1,:));
    d_est=pdist2(centt_est(j,:),centt_est(j+1,:));
    vel(j)=d/perframetime;
    vel_est(j)=d_est/perframetime;
end

figure;
title('Velocity');
plot(vel,'-b');
hold on
plot(vel_est,'-k');