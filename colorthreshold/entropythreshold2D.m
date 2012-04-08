function [KL, KJ, KG] = entropythreshold2D (im)
% ENTROPYTHREHOLD thresholds gray-scale image using Local Entropy, Joint Entropy and Global Entropy
% method. 
% input is image IM
% output are:
% KL : local entropy threshold
% KJ : joint entropy threshold
% KG : Global entropy threshold
% Programmed By Yingzi (Eliza) Du on 03/08/2004
ml=0;
mj=0;
mg=0;
his2 = hist2D(im);

mn = min(min(im))+1;
mx = max(max(im))+1;
for i=mn:mx-1
   hisa=zeros(i);
   hisb=zeros(i,256-i);
   hisc=zeros(256-i);
   hisd=zeros(256-i,i);
   Pa=sum(sum(his2(1:i,1:i)));
   Pb=sum(sum(his2(1:i,i+1:256)));
   Pc=sum(sum(his2(i+1:256,i+1:256)));
   Pd=sum(sum(his2(i+1:256,1:i)));
   %this part to make sure there is no 0 for the information calculation
   %calculate the new local, joint and relative entropy
   Hl=0;
   Hj=0;
   Hg=0;
   if (Pa>0)
      hisa=his2(1:i,1:i)./Pa;
      hisa=(hisa==0)+hisa;
      Hl=sum(sum(-hisa.*log(hisa)));
      Hg=Hl;
    end;
   if (Pb>0)
      hisb=his2(1:i,i+1:256)./Pb;
      hisb=(hisb==0)+hisb;
      Hj=sum(sum(-hisb.*log(hisb)));
      Hg=Hg+Hj;
   end;
   if (Pc>0)
      hisc=his2(i+1:256,i+1:256)./Pc;
      hisc=(hisc==0)+hisc;
      tmp=sum(sum(-hisc.*log(hisc)));
      Hl=Hl+tmp;
      Hg=Hg+tmp;
  end;
  if (Pd>0)
      hisd=his2(i+1:256,1:i)./Pd;
      hisd=(hisd==0)+hisd;
      tmp=sum(sum(-hisd.*log(hisd)));
      Hj=Hj+tmp;
      Hg=Hg+tmp;
    end;

   if(Hl>ml)
      ml=Hl;
      KL=i-1;
      hhg=Hg;
   end;
   if(Hj>mj)
      mj=Hj;
      KJ=i-1;
      hhl=Hl;
   end;
   if(Hg>mg)
      mg=Hg;
      KG=i-1;
   end;
end;


   
   
   
   
   
   
   
   
   

      