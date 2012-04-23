function runphenokmeans(indir)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code runs the pheno kmeans, pca, and entropy functions on a
% directory containing sites that contain years of image data.  

% SYNTAX:
%     runphenokmeans(indir)
%         indir = input directory of sites that contains a directory of 
%             images per year (JPEG only)
%
% EXAMPLE:
%     runphenokmeans('C:\data\')
%       This use of the function finds images in
%       'C:\data\', outputs to 'C:\data\', using the
%       kmeans function.
%
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
%get current location
curloc = pwd;
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
        cd(curloc);
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
