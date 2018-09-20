% y1=imread('Snapshot_20150112.jpg');
% y2=imread('Snapshot_20150112_1.jpg');
% y3=imread('Snapshot_20150112_2.jpg');
% y4=imread('Snapshot_20150112_3.jpg');
% y5=imread('Snapshot_20150112_4.jpg');
% y6=imread('Snapshot_20150112_5.jpg');
% y7=imread('Snapshot_20150112_6.jpg');
% y8=imread('Snapshot_20150112_7.jpg');
% y9=imread('Snapshot_20150112_8.jpg');
%y10=imread('Snapshot_20150111_16.jpg');
%y11=imread('Snapshot_20150111_17.jpg');
%y12=imread('Snapshot_20150111_18.jpg');

for i=1:1:100
[x1{i}, n{i}]=rgb2ind(im{i},256);
end
% [x2,n1]=rgb2ind(y2,256);
% [x3,n2]=rgb2ind(y3,256);
% [x4,n3]=rgb2ind(y4,256);
% [x5,n4]=rgb2ind(y5,256);
% [x6,n5]=rgb2ind(y6,256);
% [x7,n6]=rgb2ind(y7,256);
% [x8,n7]=rgb2ind(y8,256);
% [x9,n8]=rgb2ind(y9,256);
%[x10,n9]=rgb2ind(y10,256);
%[x11,n10]=rgb2ind(y11,256);
%[x12,n11]=rgb2ind(y12,256);

map=cat(3,n{:});
frames=cat(4,x1{:});
imwrite(frames,map,'CellPropSequence','gif','DelayTime',0.8,'LoopCount',inf);