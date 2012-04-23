function [coeff,score,latent,tsquare] = pcadiffhsv(img)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code runs a pca on the difference between two subsequent images in a
% set of data, returning the results.
%
% SYNTAX:
%     pcadiffhsv(img)
%         img = a 4d double of all the images
%
% Matlab function file written by Dmitri Ilushin, dilushin@college.harvard.edu,
% February 14, 2012
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r1 = zeros(size(img,1)*size(img,2),size(img,4));
%r = zeros(size(mask,1)*size(mask,2),size(mask,3)*size(img,4));
for n=1:size(img,4) - 1;
    imgtemp = imabsdiff(img(:,:,:,n),img(:,:,:,n+1));
    htemp = imgtemp(:,:,1);
    stemp = imgtemp(:,:,2);
    imgtemp(:,:,1) = htemp;
    imgtemp(:,:,2) = stemp;
    
    figure()
    imagesc(imgtemp/max(max(max(imgtemp))));
    pmat = zeros(size(r1,1),size(img,3));
    for m = 1:2;
        pmat(:,m) = reshape(imgtemp(:,:,m),size(imgtemp,1)*size(imgtemp,2),1);
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
realr = reshape(score(:,1),size(img,1),size(img,2));
figure
imagesc(realr);
end