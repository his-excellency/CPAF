%Load orientation & velocity dip data

cv = VideoReader('CLASS_4_FOLLOW.avi');
all_xy_time = read(cv);


angor = - ((180/pi)*ori);
angor(angor>90) = -(180-angor(angor>90));
%Required Indexes/frames of least angle of rotation
[~,ix]=find(angor<20);
%check by plot('axisratio'(ix)) etc

for i =1:1:100
    
    subplot(5,1,1)
    imshow(all_xy_time(:,:,:,i))
    title('Video Frame Sequence','FontSize',12)
    
    subplot(5,1,2)
    imshow(2*cellrgbsma{i},'InitialMagnification',300)
    hold on
    plot(X(i,:),Y(i,:),'LineWidth',2,'Color','w')
    x=sprintf('Tracked Cell with Fit Ellipse- Orientation: %0.1f , Frame: %d',angor(i),i);
    title(x,'FontSize',12)
    
    subplot(5,1,3)
    plot(vel(1:i),'-*r')
    xlim([0 100])
    ylim([0 400])
    title('Velocity','FontSize',15)
    
    axrat=aa(1:i)./bb(1:i);
    subplot(5,1,4)
    plot(axrat(1:i),'-*b')
    xlim([0  100])
    ylim([1 2])
    title('Axis ratio/Elongation','FontSize',15)
    
    subplot(5,1,5)
    plot(gof(1:i),'-*g')
    xlim([0 100])
    ylim([0.8 1])
    title('Goodness of Fit/Membrane Compactness','FontSize',15)
    
        set(gcf, 'Position', get(0, 'Screensize'));
    
        im{i}=frame2im(getframe(gcf));
    
    %     subplot(5,1,5)
    %     plot(angor(1:i),'-*')
    %     title('Orientation')
    
    
    pause(0.1);
    
end



