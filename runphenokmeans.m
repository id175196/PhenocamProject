function runphenokmeans(indir)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code runs the pheno kmeans, pca, and entropy functions on a
% directory containing sites that contain years of data.  The variables are
% the same as for a phenokmeans, so I will leave the syntax of phenokmeans
% below for now.
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
%% Get all the subdirectories to run phenokmeans on 
dirData = dir(indir);      %# Get the data for the current directory
dirIndex = [dirData.isdir];  %# Find the index for directories
subDirs = {dirData(dirIndex).name};  %# Get a list of the subdirectories
validIndex = ~ismember(subDirs,{'.','..'});  %# Find index of subdirectories
                                           %#   that are not '.' or '..'
%% run codes and store in given directory
for iDir = find(validIndex)                  %# Loop over valid subdirectories
    nextDir = fullfile(indir,subDirs{iDir});    %# Get the subdirectory path
    
    %get directories of year per site
    dirData2 = dir(nextDir);      %# Get the data for the current directory
    dirIndex2 = [dirData2.isdir];  %# Find the index for directories
    subDirs2 = {dirData2(dirIndex2).name};  %# Get a list of the subdirectories
    validIndex2 = ~ismember(subDirs2,{'.','..'});  %# Find index of subdirectories
                                               %#   that are not '.' or '..'
    for iDir2 = find(validIndex2)
        year_dir = fullfile(nextDir,subDirs2{iDir2});    %# Get the subdirectory path
        disp(year_dir);
        [imgs,kmat,kresults,entres] = phenokmeanscompression2(year_dir,year_dir,...
            0,1,23,15,6,365,...
            2);

        [coeff,score,latent,tsquare, mask] = pca(imgs);
        kresname = strcat(year_dir,subDirs{iDir},'_',subDirs2{iDir2},'_kres.txt');
        pcaname = strcat(year_dir,subDirs{iDir},'_',subDirs2{iDir2},'_pca.txt');
        entresname = strcat(year_dir,subDirs{iDir},'_',subDirs2{iDir2},'_entres.txt');
        %save files to directory
        cd(year_dir);
        dlmwrite(kresname,kresults);
        dlmwrite(pcaname,mask);
        dlmwrite(entresname,entres);
    end
end
