function [coeff,score,latent,tsquare, res] = pcafilters(img, mask)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function makes a mask file of non-vegetative areas given a stack of
% images.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

res = img(:,:,:,1);
ind = numel(find(mask));
r1 = zeros(ind,size(img,4));
for n=1:size(img,4);
    imgtemp = img(:,:,:,n);
    pmat = zeros(size(r1,1),size(res,3));
    amt = 1;
    for x = 1:size(res,1)
        for y = 1:size(res,2)
            if(mask(x,y) ~= 0)
                for m = 1:size(res,3);
                    pmat(amt,m) = imgtemp(x,y,m);
                end
                amt = amt + 1;
            end
        end
    end
    [coeff,score,latent,tsquare] = princomp(pmat);
    r1(:,n) = score(:,1);
    
end
[coeff,score,latent,tsquare] = princomp(r1);
tempr = zeros(size(mask,1),size(mask,1));
amt = 1;
for x = 1:size(res,1)
    for y = 1:size(res,2)
        if(mask(x,y) ~= 0)
            tempr(x,y) = score(amt,1);
            amt = amt + 1;
        end
    end
end
imagesc(tempr);
m2 = max(max(tempr));
m1 = min(min(tempr));
res = ones(size(tempr,1),size(tempr,2));
res(tempr < m1 + .6*(m2-m1)) = 0;
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