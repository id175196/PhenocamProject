function [conf,rate]=confmat(Y,T)
%CONFMAT Compute a confusion matrix.
%
%	Description
%	[CONF, RATE] = CONFMAT(Y, T) computes the confusion matrix C and
%	classification performance RATE for the predictions Y compared
%	with the targets T. Y and T both should be column or both should be 
%	row vectors.
%
%	In the confusion matrix, the rows represent the true classes and the
%	columns the predicted classes.  The vector RATE has two entries: the
%	percentage of correct classifications and the total number of correct
%	classifications.
%
%	Rajen Bhatt,
%   Indian Institute of Technology Delhi

if length(Y)~=length(T) 
   error('Outputs and targets are different lengths')
end

c = unique(T);

for i = 1:length(c)
   for j = 1:length(c)
      conf(i,j) = (sum ((Y==j).*(T==i))/sum(T == i))*100;
   end
end

correct = (Y == T);

rate=(sum(correct)/length(correct)) * 100;