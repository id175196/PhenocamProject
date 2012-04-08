function res = getEntropies(img)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code creates a kmeans clustering matrix for which there are a 
% predefined number of regions of interest to split the stack of a given 
% dierctory of images into.  The function also needs date2jd, 
% isleapyear to be in the search path.  The easiest way is to make sure the 
% source files are in the same directory as this function.
%
% Default for values not specified are as follows:
% indir: must be specified
% outdir: must be specified
% windowsize: must be specified
% sttime: 1
% endtime: 23
% threshold: 15
% numclusters: 4
% numpics: 12
% compression: 1
% sampledata: assumes no sampledata
%
% SYNTAX:
%     phenokmeanscompression(indir,outdir,windowsize)
%         indir = input directory with images (JPEG only)
%         outdir = output directory where kmeans results will be written
%         windowsize = window size in days
%
%     phenokmeanscompression(indir,outdir,windowsize,sttime,endtime)
%         indir = input directory with images (JPEG only) and mask
%         outdir = output directory where ASCII results will be written
%         windowsize = window size in days
%         sttime, endtime = starting and ending hour for processing images,
%                                       default is 7h00 and 17h00
%     phenokmeanscompression(indir,outdir,windowsize,sttime,endtime, threshold)
%         indir = input directory with images (JPEG only) and mask
%         outdir = output directory where ASCII results will be written
%         windowsize = window size in days
%         sttime, endtime = starting and ending hour for processing images,
%                                       default is 7h00 and 17h00
%         threshold = threshold of mean blue/red/green color values to be
%                considered.
%     phenokmeanscompression(indir,outdir,windowsize,sttime,endtime,...
%                            threshold, numclusters, numpics)
%         indir = input directory with images (JPEG only) and mask
%         outdir = output directory where ASCII results will be written
%         windowsize = window size in days
%         sttime, endtime = starting and ending hour for processing images,
%                                       default is 7h00 and 17h00
%         threshold = threshold of mean blue/red/green color values to be
%                considered.
%         numclusters = the number of clusters to create with kmeans. 
%                default is 6.
%         numpics = the number of pictures to be used for kmeans.  default
%         is 10.
%
%     
%
% EXAMPLE:
%     phenokmeanscompression('C:\data\harvard\2009','C:\data\harvard',
%     3)
%       This use of the function finds images in
%       'C:\data\harvard\2009', outputs to 'C:\data\harvard\', uses the
%       kmeans function on this information; the window size for smoothing is 3
%       days.
%
% Original code written by Koen Hufkens, khufkens@bu.edu, Sept. 2011,
% published under a GPLv2 license and is free to redistribute.
%
% Matlab function file written by Dmitri Ilushin, dilushin@college.harvard.edu,
% February 14, 2012
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mask = imread(img{1,1});
res = zeros(size(mask,1),size(mask,2),size(mask,3),size(img,2));

for n=1:size(img,2);
    imgtemp = imread(img{1,n});
    [res(:,:,:,n),n,cts] = colorthreshold(imgtemp,'le');
    %figure; imagesc(out/256); title(img{n});
end

