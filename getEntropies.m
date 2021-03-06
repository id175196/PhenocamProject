function res = getEntropies(img)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code takes in a cell array of image names and returns a 4d matrix
% containing images of the entropy of each selected image.
%
% 
%
% SYNTAX:
%     getEntropies(img)
%         img = 2d cell array containing file locations of images to do
%         entropies of.
%
%     
%
% EXAMPLE:
%     getEntropies(['c:\data\harvard\2009\01_01_0837.jpg'])
%       This use of the function takes the image
%       c:\data\harvard\2009\01_01_0837.jpg and runs an entropy on it.
%
% Uses the colorentropy functions, written by Y. Du,; C. Chang, and P.D.
% Thouin for their work "An Unsupervised Approach to Color Video
% Thresholding", Optical Engineering, Vol. 43, No. 2, 282-289, (2004).
%
% Matlab function file written by Dmitri Ilushin, dilushin@college.harvard.edu,
% February 14, 2012
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mask = imread(img{1,1});
res = zeros(size(mask,1),size(mask,2),size(mask,3),size(img,2));

for n=1:size(img,2);
    imgtemp = imread(img{1,n});
    red = imgtemp(:,:,1);
    green = imgtemp(:,:,2);
    blue = imgtemp(:,:,3);
    %res1 = green./(green + red + blue)*256;%floor(green/(green + red + blue)*256);
    %[k] = otsu(res1);
    %res(:,:,n) = k;
    [res(:,:,:,n),n2,cts] = colorthreshold(imgtemp,'le');
    %figure; imagesc(out/256); title(img{n});
end
%{
imgtemp = imread(img{1,1});
[res,n2,cts] = colorthreshold(imgtemp,'le');
%}