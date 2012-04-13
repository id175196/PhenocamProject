function [coeff,score,latent,tsquare, mask] = pca(img)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function makes a mask file of non-vegetative areas given a stack of
% images.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mask = img(:,:,:,1);
r1 = zeros(size(mask,1)*size(mask,2),size(img,4));
%r = zeros(size(mask,1)*size(mask,2),size(mask,3)*size(img,4));
for n=1:size(img,4);
    imgtemp = img(:,:,:,n);
    pmat = zeros(size(r1,1),size(mask,3));
    for m = 1:size(mask,3);
        pmat(:,m) = reshape(imgtemp(:,:,m),size(imgtemp,1)*size(imgtemp,2),1);
        %r(:,(n-1)*size(mask,3) + m) = reshape(imgtemp(:,:,m),size(imgtemp,1)*size(imgtemp,2),1);
    end
    [coeff,score,latent,tsquare] = princomp(pmat);
    %{
    for m = 1:size(mask,3);
        r(:,(n - 1)*size(img,3) + m) = score(:,m);
    end
    %}
    r1(:,n) = score(:,1);
    
end
%[coeff,score,latent,tsquare] = princomp(r);
%aww yeah. 
%testing this comment works.
%merges should come up here.
[coeff,score,latent,tsquare] = princomp(r1);
tempr = reshape(score(:,1),size(mask,1),size(mask,2));
m2 = max(max(tempr));
m1 = min(min(tempr));
mask = ones(size(tempr,1),size(tempr,2));
mask(tempr < m1 + .6*(m2-m1)) = 0;
%figure
%imagesc(mask);
%% commented out for supercomputer run.
%{
for i = 1:12;
    tempr = reshape(score(:,i),size(mask,1),size(mask,2));
    figure
    imagesc(tempr);
end
%}
end