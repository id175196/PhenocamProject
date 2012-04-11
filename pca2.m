function [coeff,score,latent,tsquare, mask] = pca2(img)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function makes a mask file of non-vegetative areas given a stack of
% images.  The main difference is here we have a function that takes all 3
% pca vectors each time and constructs the resulting pca.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mask = img(:,:,:,1);
r = zeros(size(mask,1)*size(mask,2),size(img,4));
for n=1:size(img,4);
    red = img(:,:,1,n);
    green = img(:,:,2,n);
    blue = img(:,:,3,n);
    imgtemp = green ./(red + green + blue);
    r(:,n) = reshape(imgtemp,size(r,1),1);
end
r(isnan(r) | r == Inf) = 0;
[coeff,score,latent,tsquare] = princomp(r);
tempr = reshape(score(:,1),size(mask,1),size(mask,2));
realr = zeros(size(tempr,1),size(tempr,2));
realr(tempr <= 0) = 1;
figure
imagesc(realr); colorbar;
end