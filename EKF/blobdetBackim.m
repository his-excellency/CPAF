function [Centt,cellbox,img,dogfim] = blobdetBackim(orgim,backim)
    img = rgb2gray(orgim-backim);

    g1 = fspecial('Gaussian', 21, 15);
    g2 = fspecial('Gaussian', 21, 20);
    dog = g1 - g2;
    dogfim = conv2(double(img), dog, 'same');
    
    imgbin = im2bw(dogfim,0.20);
    %imgbin = im2bw(dogfim);
    [imagec, numc] = bwlabel(imgbin);
    cstats = regionprops(imagec, 'BoundingBox','Centroid');
    
    for j=1:1:size(cstats,1)
        Centt(j,:) = cstats(j,:).Centroid;
        cellbox(j,:) = cstats(j,:).BoundingBox;
    end
end