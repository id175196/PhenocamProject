function [KL,KJ,KG]=rltentrpthreshold2D(im)
% RLTENTRPTHRESHOLD2D thresholds gray-scale image using Local Relative Entropy, 
% Joint Relative Entropy and Globle Relative Entropy methods
% input is image IM
% output are:
% KL : local relative entropy threshold
% KJ : joint relative entropy threshold
% KG : global relative entropy threshold
% Programmed By Yingzi (Eliza) Du on 03/08/2004

mn=min(min(im))+1;
mx=max(max(im))+1;
his2 = hist2D(im);
Nm=zeros(1,256);
k=0;

ml=100000;
mj=100000;
mg=-100000;
his=hist(im);
for i=mn:mx
    if his(i)>0
       k=k+1;
    end;
    Nm(i)=k;
end;  

for i=mn:mx-1;
   Hge=0;
   Hle=0;
   Hje=0;
   Pa=sum(sum(his2(mn:i,mn:i)));
   Pb=sum(sum(his2(mn:i,i+1:mx)));
   Pc=sum(sum(his2(i+1:mx,i+1:mx)));
   Pd=sum(sum(his2(i+1:mx,mn:i)));
   qa=0;
   qb=0;
   qc=0;
   qd=0;
   %this part to make sure there is no 0 for the information calculation
   %calculate the new local, joint and relative entgopy
   Hr=0;
   hisa=his2(mn:i,mn:i);
   hisb=his2(mn:i,i:mx);
   hisc=his2(i+1:mx,i+1:mx);
   hisd=his2(i+1:mx,mn:i);
   area1=Nm(i);
   area2=Nm(mx)-area1;
   if (Pa>0)
      qa=Pa/area1/area1;
      Hle=-Pa.*log(qa./(Pa+Pc));
      hisa=(hisa==0)+hisa;
      Hle=Hle+sum(sum(hisa.*log(hisa)));
      Hge=Pa*log(qa);
   end;
   if (Pb>0)
      qb=Pb/area2/area1;
      Hje=-Pb*log(qb/(Pb+Pd));
      hisb=(hisb==0)+hisb;
      Hje=Hje+sum(sum(hisb.*log(hisb)));
      Hge=Hge+Pb*log(qb);
  end;
   if (Pc>0 )
     qc=Pc/area2/area2;
     Hle=Hle-Pc*log(qc/(Pa+Pc));
     hisc=(hisc==0)+hisc;
     Hle=Hle+sum(sum(hisc.*log(hisc)));
     Hge=Hge+Pc*log(qc);
   end;
   if (Pd>0)
      qd=Pd/area1/area2;
      Hje=Hje+Pd*log(qd/(Pb+Pd));
      hisd=(hisd==0)+hisd;
      Hje=Hje+sum(sum(hisd.*log(hisd)));
      Hge=Hge+Pd*log(qd);
   end;
   if Pa+Pc>0
     Hle=Hle./(Pa+Pc)-log(Pa+Pc);
     if Hle<ml
      ml=Hle;
      KL=i-1;
     end; 
   end;
   if (Pb+Pd>0)
      Hje=Hje./(Pb+Pd)-log(Pb+Pd);
      if(Hje<mj )
       mj=Hje;
       KJ=i-1;
      end;
   end;
   if Hge>mg
      mg=Hge;
      KG=i-1;
   end;
end;



   
   
   
   
   
   
   
   
   
   
   

      