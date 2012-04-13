function [out,n,cts] = colorthreshold(im,thresholdmethod)

%COLORTHRESHOLD thresholds color images. Please read Dr. Yingzi (Eliza)
% Du's paper in Optical Engineering and Dr.Du's Dissertation,  
% Y.Du; C.-I Chang; and P.D. Thouin, "An Unsupervised Approach to Color Video Thresholding", 
% Optical Engineering, Vol. 43, No. 2, 282-289, (2004).
% Y.Du, Text Detection and Restoration of Color Video Image, Univ. of
% Maryland, Baltimore County, (2003).
% Y.Du, Matlab code for color image thresholding,
% http://www.gl.umbc.edu/~ydu1
%
%   COLORTHRESHOLD takes a color image IM as its input, and lets the user selects the threholding
%    method. The function returns a color thresholded image OUT of the same size as IM, 
%    total number of colors in N, and the center of colors in CTS.
%
%   COLORTHRESHOLD supports seven different gray-scale thresholding methods:
%   Summary of different gray-scale thresholding methods you can select           
%   -----------------------------------------------------------------------
%   OTSU    using the OTSU's method
%   LE      using Local Entropy Method
%   JE      using Joint Entropy Method
%   GE      using Globle Entropy Method
%   LRE     using Local Relative Entropy Method
%   JRE     using Joint Relative Entropy Method
%   GRE     using Globle Relative Entropy Method
%
%   Example
%   -------
%   Threshold the color image laden.jpg using the OTSU and JRE method:
%
%       im = imread('laden.jpg');
%       out1 = colorthreshold(im,'otsu');
%       out2 = colorthreshold(im,'JRE');
%       imshow(out1);
%       figure, imshow(out2)
%
%  The following programs must be downloaded and put in the same directory
%  in order to use this function:
%  otsu.m          the function to threshold gray-scale image using Otsu's method
%  hist2D.m        the function to generate the 2D histogram based on the
%                  cooccurence matrics
%  entropythreshold2D.m the function to threshold gray-scale image using
%                       local/joint/global entropy methods
%  rltentrpthreshold2D.m the function to threshold gray-scale image using
%                        local/joint/global relative entropy methods
%  cluster3D.m     the function to recluster the color centers
%
%   Copyright Yingzi (Eliza) Du 
%   Date: Mar. 8, 2004 

im=double(im);
co=size(im,1);
ro=size(im,2);

im1=im(:,:,1);
im2=im(:,:,2);
im3=im(:,:,3);

tmethod = 0;
if strcmpi(thresholdmethod,'otsu')
    tmethod = 1;
    rk=otsu(im1);
    gk=otsu(im2);
    bk=otsu(im3);
end;
if strcmpi(thresholdmethod,'le') | strcmpi(thresholdmethod,'Je') | strcmpi(thresholdmethod,'Ge')
    tmethod = 2;
    [KL1,KJ1,KG1] = entropythreshold2D(im1);
    [KL2,KJ2,KG2] = entropythreshold2D(im2);
    [KL3,KJ3,KG3] = entropythreshold2D(im3);
    if strcmpi(thresholdmethod,'le') 
        rk = KL1;
        gk = KL2;
        bk = KL3;
    end;
    if strcmpi(thresholdmethod,'je') 
        rk = KJ1;
        gk = KJ2;
        bk = KJ3;
    end;
    if strcmpi(thresholdmethod,'ge') 
        rk = KG1;
        gk = KG2;
        bk = KG3;
    end;
end;

if strcmpi(thresholdmethod,'lre') | strcmpi(thresholdmethod,'jre') | strcmpi(thresholdmethod,'gre')
    tmethod = 3;
    [KL1,KJ1,KG1]=rltentrpthreshold2D(im1);
    [KL2,KJ2,KG2]=rltentrpthreshold2D(im2);
    [KL3,KJ3,KG3]=rltentrpthreshold2D(im3);
    if strcmpi(thresholdmethod,'lre') 
        rk = KL1;
        gk = KL2;
        bk = KL3;
    end;
    if strcmpi(thresholdmethod,'jre') 
        rk = KJ1;
        gk = KJ2;
        bk = KJ3;
    end;
    if strcmpi(thresholdmethod,'gre') 
        rk = KG1;
        gk = KG2;
        bk = KG3;
    end;
end;

if tmethod == 0  %input wrong methods
    error('Unrecognized thresholding method');
end;    
imt = zeros(co,ro,3); %The pre-thresholded thresholded image 
imt(:,:,1)=(im2>rk);
imt(:,:,2)=(im2>gk);
imt(:,:,3)=(im3>bk);
[out, n, cts] = cluster3D(im,imt);

