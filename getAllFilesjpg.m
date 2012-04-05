function jpgFiles = getAllFilesjpg(dirName)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% getAllFiles grabs single file in a directory and all of its
% subdirectoris.  This function takes in just one argument, indir, which is
% the directory to search.
%
% SYNTAX:
%       getAllFiles(dirName)
%           indir = input directory to search through
%
% EXAMPLE:
%       files = getAllFiles('/home')
% This code was originally written by Kenneth Eaton, but revised to be used
% for the phenocam project.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  dirData = dir(dirName);      %# Get the data for the current directory
  dirIndex = [dirData.isdir];  %# Find the index for directories
  fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
  jpgFiles = [];
  for i = 1:size(fileList,1);
      %parts = regexp(fileList(i),'\.jpg','split');
      %numexps = size(parts{1},2);
      %if numexps > 1
      if strcmp(fileList{i}(size(fileList{i},2)-3:size(fileList{i},2)),'.jpg') == 1
          jpgFiles = [jpgFiles; fileList(i)];
      end
  end
  
  if ~isempty(jpgFiles)
    jpgFiles = cellfun(@(x) fullfile(dirName,x),...  %# Prepend path to files
                       jpgFiles,'UniformOutput',false);
    %fileList = cellfun(@(x) strcmp({},'*.jpg'),fileList,'UniformOutput',false);
  end
  subDirs = {dirData(dirIndex).name};  %# Get a list of the subdirectories
  validIndex = ~ismember(subDirs,{'.','..'});  %# Find index of subdirectories
                                               %#   that are not '.' or '..'
  for iDir = find(validIndex)                  %# Loop over valid subdirectories
    nextDir = fullfile(dirName,subDirs{iDir});    %# Get the subdirectory path
    jpgFiles = [jpgFiles; getAllFilesjpg(nextDir)];  %# Recursively call getAllFiles
  end
end