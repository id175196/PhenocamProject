function [res] = pcafiltersconifers(img,mask)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function runs a pca filter on areas not included in mask.  Will be
% used to find the conifers
% Syntax:
%    [coeff,score,latent,tsquare, res] = pcafilters(img, mask)
%        img = stack of images to run filters on
%        mask = binary mask where not to consider data
%
% This method is currently very accurate at filtering out all of the
% non-vegetative areas.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 1;
    res = zeros(size(img,1),size(img,2),size(img,3));
    val = size(img,1)*size(img,2);
    for m=1:size(img,3);
        tmat = zeros(size(img,1)*size(img,2),size(img,4));
        for n = 1:size(img,4) - 3;
            tmat(:,n) = reshape(img(:,:,m,n),val,1)*100/mean2(img(:,:,m,n));
        end
        sdmat = std(tmat,0,2);
        sdmat = sum(sdmat,2);
        res(:,:,m) = reshape(sdmat,size(img,1),size(img,2));
    end
    finalsdmat = sum(res,3);
    big = max(max(finalsdmat));
    %hist(finalsdmat);
    figure
    I = img(:,:,1,1);
    I(finalsdmat <=big*.6) = 1;
    I(finalsdmat <=big*.1) = 0;
    I(finalsdmat > big*.6) = 0;
    imagesc(I);
    res = I;
else
    ind = numel(find(mask));
    res = zeros(size(img,1),size(img,2),size(img,3));
    for m=1:size(img,3);
        tmat = zeros(ind,size(img,4));
        for n = 1:size(img,4) - 3;
            imgtemp = img(:,:,m,n);
            imgtemp = imgtemp(mask ~= 0);
            tmat(:,n) = reshape(imgtemp,ind,1)/mean2(imgtemp);
        end
        sdmat = std(tmat,0,2);
        sdmat = sum(sdmat,2);
        amt = 1;
        for x = 1:size(res,1)
            for y = 1:size(res,2)
                if(mask(x,y) ~= 0)
                    res(x,y,m) = sdmat(amt,1);
                    amt = amt + 1;
                end
            end
        end
        disp(amt);
    end
    disp(numel(mask));
    figure;
    imagesc(res(:,:,1)/max(max(res(:,:,1))));
end