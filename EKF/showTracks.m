% dataDir = 'D:/thesis/codes/CellsCropped.avi';
% cv = VideoReader(dataDir);
% all_xy_time = read(cv);
% k = 3;
% [m,n,c,frm] = size(all_xy_time);




imshow(all_xy_time(:,:,:,1))
for F=12:1:12
    hold on
    plot(theTracks{F}(:,1),theTracks{F}(:,2),'-*b')
end
% 
%  bv = VideoWriter('CellsCropped.avi');
%  open(bv);
%  
%  for i=175:1:1110
%      writeVideo(bv,all_xy_time(:,:,:,i));
%  end
%  close(bv);

%red[4,5,22,30,32,60,77,94]
%red[96,98,100,103,104,105,107,108]
fps = 30;
F = 108;
for j=1:1:size(newTrak{F},1)-1
    d = pdist2(newTrak{F}(j,:),newTrak{F}(j+1,:));
    vel(j) = d/(1/fps);
end
filename = sprintf('GREEN_CELLS/Cell_%d/cell_speed_%d',F,F);
%mkdir(filename);
save(filename,'vel');
clear vel
%plot(theTracks{83}(:,1),theTracks{83}(:,2),'-r')

%plot(vel,'-r')

figure
subplot(2,1,1);
plot(vel,'-g')
title('Green Cell 2 speed')
subplot(2,1,2);
plot(ecc,'-b')
title('Green Cell 2 Eccentricity')

%Minima Peak Detection and Eccentricity calc at events(Collisions)
[~,il] = findpeaks(-1*vel,'MINPEAKDISTANCE',3);
minpks = vel(il);
subplot(2,1,1)
plot(vel,'-g')
hold on
plot(il,minpks,'*b')
title('Red Cell (5) speed ( * shows Collisions)')
xlabel('Time')
subplot(2,1,2)
plot(il,ecc(il),'-or')
title('Red Cell (5) Eccentricity')
xlabel('Events')





