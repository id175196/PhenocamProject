function [coeff,score,latent,tsquare] = pcadiff(img,mask)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code runs a pca on the difference between subsequent images
%
%
% SYNTAX:
%     pcadiff(img, mask)
%         img = 4d stack of images to run data on
%         mask = binary mask to indicate where not to consider
%     
% Matlab function file written by Dmitri Ilushin, dilushin@college.harvard.edu,
% February 14, 2012
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r1 = zeros(size(mask,1)*size(mask,2),size(img,4));
for n=1:size(img,4) - 1;
    imgtemp = imabsdiff(img(:,:,:,n),img(:,:,:,n+1));
    redtemp = imgtemp(:,:,1);
    greentemp = imgtemp(:,:,2);
    bluetemp = imgtemp(:,:,3);
    redtemp(mask == 1) = 0;
    greentemp(mask == 1) = 0;
    bluetemp(mask == 1) = 0;
    
    imgtemp(:,:,1) = redtemp;
    imgtemp(:,:,2) = greentemp;
    imgtemp(:,:,3) = bluetemp;
    
    figure()
    imagesc(imgtemp/max(max(max(imgtemp))));
    pmat = zeros(size(r1,1),size(mask,3));
    for m = 1:size(mask,3);
        pmat(:,m) = reshape(imgtemp(:,:,m),size(imgtemp,1)*size(imgtemp,2),1);
    end
    [coeff,score,latent,tsquare] = princomp(pmat);
    r1(:,n) = score(:,1);
    
end
[coeff,score,latent,tsquare] = princomp(r1);
realr = reshape(score(:,1),size(mask,1),size(mask,2));
figure
imagesc(realr);
end