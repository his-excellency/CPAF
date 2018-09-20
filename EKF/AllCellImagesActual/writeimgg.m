

G=dir('D:\thesis\codes\EKF\AllCellImagesActual\');



for i=3:1:size(G,1)-1
    f=G(i).name;
    load(f);
    p=sprintf('D:/thesis/codes/EKF/AllCellImagesActual/%s',f(1:size(f,2)-4));
    mkdir(p);
    for j=1:1:size(obj1,2)
        kk=sprintf('%s/imf_%d.jpg',p,j);
        
        imwrite(obj1{j},kk);
    end
    clear obj1
end

        
