function [conf,rate] = getallconfmat(trainingdata,compression)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%gets all the confusion matrix stuff in one easy function rather than 3
%function calls or so.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[kmat,kres2] = phenokmeanscompression('/home/dmitri/Documents/Sample_year','/home/dmitri/Documents/Sample_year',30,1,21,15,4,10);
kres2 = majorityfilter(kres2, 4,1);
y = getconfstats(trainingdata,kres2,compression);
[conf,rate] = confmat(y(:,1),y(:,2));

end