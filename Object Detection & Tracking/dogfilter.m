% dataDir = 'D:/thesis/codes/mpc3highdensity.avi';
% 
% cv = VideoReader(dataDir);
% all_xy_time = read(cv);
% k=3;
% [m,n,c,frm] = size(all_xy_time);
% boxim = cell(frm,1);
% ct = 0;
% f=200;

orgimgray =rgb2gray(all_xy_time(:,:,:,f));

g1 = fspecial('Gaussian', 21, 15);
g2 = fspecial('Gaussian', 21, 20);
dog = g1 - g2;
dogfim = conv2(double(orgimgray), dog, 'same');

imtool(dogfim)
imhist(dogfim)