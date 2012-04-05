function minikmeans(imgloc)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
img = imread(imgloc);
figure
h_im = image(img);
kmat = zeros(size(img,1)*size(img,2),size(img,3));
for i = 1: size(img,1);
    for j = 1: size(img,2);
        for k = 1: size(img,3);
            kmat((i - 1)*size(img,2) + j, k) = img(i,j,k);
        end
    end
end
results = kmeans(kmat,4);
results = reshape(results,size(img,2),size(img,1));
results = fliplr(results);
results = rot90(results);
figure
imagesc(results); colormap(gray)
end

