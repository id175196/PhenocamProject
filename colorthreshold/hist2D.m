function [his2]=hist2D(im)
%HIST2D is to generate the 2-D histogram based on the cooccurence matrics
%IM is the imput, hist2 is the output 2D 256-by-256 metrics
%Programmed by Dr. Yingzi (Eliza) Du

his2=zeros(256); %to rember the 2-D histogram

co=size(im,1);
ro=size(im,2);
%get the 2-D histogram
for i=1:co-1
   for j=1:ro-1
      his2(im(i,j)+1,im(i+1,j)+1)=his2(im(i,j)+1,im(i+1,j)+1)+1;
      his2(im(i,j)+1,im(i,j+1)+1)=his2(im(i,j)+1,im(i,j+1)+1)+1;
  end;
end;

for j = 1:ro-1
    his2(im(co,j)+1,im(co,j+1)+1)=his2(im(co,j)+1,im(co,j+1)+1)+1;
end;

his2=his2./sum(sum(his2));


