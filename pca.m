function [coeff,score,latent,tsquare] = pca(img)

mask = img(:,:,:,1);
r = zeros(size(mask,1)*size(mask,2),size(mask,3)*size(img,4));
disp(size(r));
disp(size(img,1)*size(img,2));
for n=1:size(img,4);
    imgtemp = img(:,:,:,n);
    for m = 1:size(mask,3);
        r(:,(n-1)*size(mask,3) + m) = reshape(imgtemp(:,:,m),size(imgtemp,1)*size(imgtemp,2),1);
    end
end
%merges should come up here.
[coeff,score,latent,tsquare] = princomp(r);
end