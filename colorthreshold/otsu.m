function [K] = otsu(im) 

% OTSU thresholds gray-scale image using Otsu's method. 
% input is image IM, and output is the threshold value.
% Programmed By Yingzi (Eliza) Du on 03/08/2004

im = uint8(im); %Change it back to uint8 
h = imhist(im)';%Get the histogram of the image
h = h/sum(h); %normalize the histogram
im = double(im);
mn = min(min(im))+1;
mx = max(max(im))+1;
j = 0:255;
ut=sum(h.*j);
dett=sum(h.*((j-ut).^2));
w0 = 0;
mxvalue = 0;
for i=mn:mx-1
   j=0:i-1;
   w0 = w0 + h(i);
   w1 = 1 - w0;
   u0 = sum(h(j+1).*j)/w0;
   u1=(ut-w0.*u0)/w1;
   detb=w0.*w1.*((u0-u1).^2);
   n = detb/dett;
   if (n > mxvalue)
      mxvalue = n;
      K=i-1;
  end;
end;


