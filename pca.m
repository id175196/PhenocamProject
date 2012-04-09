function [coeff,score,latent,tsquare] = pca(img)

mask = img(:,:,:,1);
r = zeros(size(mask,1)*size(mask,2),size(mask,3)*size(img,4));
for n=1:size(img,4);
    imgtemp = img(:,:,:,n);
    pmat = zeros(size(r,1),size(mask,3));
    for m = 1:size(mask,3);
        pmat(:,m) = reshape(imgtemp(:,:,m),size(imgtemp,1)*size(imgtemp,2),1);
        %r(:,(n-1)*size(mask,3) + m) = reshape(imgtemp(:,:,m),size(imgtemp,1)*size(imgtemp,2),1);
    end
    [coeff,score,latent,tsquare] = princomp(pmat);
    pca1 = score(:,1);
    pca2 = score(:,2);
    pca3 = score(:,3);
    figure
    subplot(1,3,1); imagesc(reshape(pca1,size(mask,1),size(mask,2)));
    subplot(1,3,2); imagesc(reshape(pca2,size(mask,1),size(mask,2)));
    subplot(1,3,3); imagesc(reshape(pca3,size(mask,1),size(mask,2)));
    
end
%[coeff,score,latent,tsquare] = princomp(r);
%aww yeah. 
%testing this comment works.
%merges should come up here.
[coeff,score,latent,tsquare] = princomp(r);
end