function [out, n, cts] = cluster3D(im,imt)
%CLUSTER3D clustering different colors in the thresholded image via
%between-class and within-class distances
% inputs are IM and IMT
%outputs are the color clastered image OUT
% the number of the colors N, and the color centers cts.
% Programmed by Dr. Yingzi (Eliza) Du

clast=zeros(8,3);
dist=ones(8,8,3)*5000000; %this is to save the distance between the class and within the class.
co = size(imt, 1);
ro = size(imt, 2);
imap=zeros(co,ro);
imap=imt(:,:,1)*4+imt(:,:,2)*2+imt(:,:,3);
flag=zeros(8,1);
sm_ar=zeros(8,1);
for i=0:7
  sm=sum(sum(imap==i));
  sm_ar(i+1)=sm;
 if sm>0
  flag(i+1)=1;
  clast(i+1,1)=sum(sum((imap==i).*im(:,:,1)))/sm;
  clast(i+1,2)=sum(sum((imap==i).*im(:,:,2)))/sm;
  clast(i+1,3)=sum(sum((imap==i).*im(:,:,3)))/sm;
  dist(i+1,i+1,1)=sqrt(sum(sum(((imap==i).*im(:,:,1)-clast(i+1,1)).^2))/sm);
  dist(i+1,i+1,2)=sqrt(sum(sum(((imap==i).*im(:,:,2)-clast(i+1,2)).^2))/sm);
  dist(i+1,i+1,3)=sqrt(sum(sum(((imap==i).*im(:,:,3)-clast(i+1,3)).^2))/sm);
end;
end;

for i=0:6
   if flag(i+1)>0
    for j=i+1:7
        if flag(j+1)>0
        dist(i+1,j+1,1)=(clast(i+1,1)-clast(j+1,1)).^2;
        dist(i+1,j+1,2)=(clast(i+1,2)-clast(j+1,2)).^2;
        dist(i+1,j+1,3)=(clast(i+1,3)-clast(j+1,3)).^2;
        dist(j+1,i+1,:)=dist(i+1,j+1,:);
    end;     
    end;
end;
end;

dist2=sqrt((dist(:,:,1).^2+dist(:,:,2).^2+dist(:,:,3).^2))/3;
shortdist=min(dist2);
d=zeros(8,1);
j=0;
for i=1:8
    if flag(i)==1 
    d(i)=find(dist2(:,i)==shortdist(i) & dist(:,i) >0);
    end;
end;
flag=flag*9;
for i=1:8
    if flag(i)>0
        for j=1:8
           if flag(j)>0 & d(j)==i & j~=i & sm_ar(j)>0 & flag(i)~=j
               if flag(i)==9
                    flag(j)=i;
                    clast(i,:)=(clast(i,:)*sm_ar(i)+clast(j,:)*sm_ar(j))/(sm_ar(i)+sm_ar(j));
                    sm_ar(i)=sm_ar(i)+sm_ar(j);
                    sm_ar(j)=0;
                else
                    flag(j)=flag(i);
                    clast(flag(i),:)=(clast(flag(i),:)*sm_ar(flag(i))+clast(j,:)*sm_ar(j))/(sm_ar(flag(i))+sm_ar(j));
                    sm_ar(flag(i))=sm_ar(flag(i))+sm_ar(j);
                    sm_ar(j)=0;
                end;
           end;
       end;
    end;
end;


%this part will recluster the whole thing
j=0;
for i=1:8
    if flag(i)==9
        j=j+1;
       true_clast(j,:)=clast(i,:);
   end;
end;

dist_im=ones(co,ro).*500000000000000;
class_im=zeros(co,ro);
for i=1:j
    tp=((im(:,:,1)-true_clast(i,1)).^2+(im(:,:,2)-true_clast(i,2)).^2+(im(:,:,1)-true_clast(i,1)).^2)/3;
    class_im=(tp<dist_im).*i+(tp>=dist_im).*class_im;
    dist_im=(tp>dist_im).*dist_im+(tp<=dist_im).*tp;
end;
nim=zeros(co,ro,3);
for i=1:j
    nim(:,:,1)=nim(:,:,1)+true_clast(i,1).*(class_im==i);
    nim(:,:,2)=nim(:,:,2)+true_clast(i,2).*(class_im==i);
    nim(:,:,3)=nim(:,:,3)+true_clast(i,3).*(class_im==i);
end;

n = j;
cts = true_clast;
out = nim;
clear nim true_clast dist_im imap;