function groundhog(indir,outdir,stmonth,endmonth,stday,endday)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This code takes a subset of directory of images based on starting and 
%ending dates and allows the client to write a description of the image, 
%which is stored in a .mat file when completed.
%
% SYNTAX:
%     groundhog(indir,outdir,stmonth,endmonth,stday,endday)
%         indir = input directory with images (JPEG only)
%         outdir = output directory where kmeans results will be written
%         stmonth = month to start image processing from
%         endmonth = month to end image processing
%         stday = day to start image processing from
%         endday = day to end image processing
%
%
% EXAMPLE:
%     phenokmeans('/home/dmitri/Documents/Groundhog_sample_imgs', 
%          '/home/dmitri/Documents/MATLAB', 1, 12, 1, 5)
%       This use of the function finds images in
%       '/home/dmitri/Documents/Groundhog_sample_imgs', outputs to 
%       '/home/dmitri/Documents/MATLAB', sets the timeframe to be from
%       January 1st to December 5th.
%   
%
%
% getAllFiles code written by Kenneth Eaton, Kenneth.Eaton@cchmc.org, Apr.
% 2011.
%
% Matlab function file written by Dmitri Ilushin, dilushin@college.harvard.edu,
% February 14, 2012
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 6 % check input arguments
    error('Not enough input arguments. Please see help file for phenotimeseries')
elseif nargin == 6
    if ischar(indir) == 0
       error('Input directory must be string')
    end
    if ischar(outdir) == 0
       error('Output directory must be string')
    end
elseif nargin > 6
    error('too many inputs')
end


% set current directory and add to search path
cd(indir)
addpath(indir)


% list all jpeg files in valid directory
% and get the number of jpegs in the directory
jpeg_files = getAllFilesjpg(indir);
nrjpegs = size(jpeg_files,1);

%create matrix to hold data information
dates = zeros(nrjpegs, 2);

%create matrix to store results
results = cell(nrjpegs,2);

%grab date information
 for i=1:nrjpegs
     
   % split strings by the underscore
   parts = regexp(jpeg_files(i),'_','split');
   
   %finds the number of splits and grabs 3rd and 2nd from last
   numexps = size(parts{1},2);
   dates(i,1) =  str2double(parts{1}(numexps - 2));
   dates(i,2) =  str2double(parts{1}(numexps - 1));
 end

 %subset images based on date
 subset_images = jpeg_files(dates(:,1) >= stmonth & dates(:,1) <= endmonth...
     & dates(:,2) >=stday & dates(:,2) <= endday);


%sets directory to specified outdir
cd(outdir)

%starting point in images to run on.  will change if wanted to.
start = 1;

%checks to see if there has already been work
if exist('jpeginfo.mat', 'file')
    answer = input(...
        'Would you like to continue from where you left off? (y/n)  ','s');
    %checks to see if you would like to continue from the previous point
    if strcmpi(answer,'y')
        struct = open('jpeginfo.mat');
        %set starting point to be the point left off from last time
        start = struct.i;
        %sets the results to the previous results of the values.
        results = struct.results;
        %sets the image set to work on to previous dataset
        subset_images = struct.subset_images;
    end
end

%makes sure files are found
if size(subset_images,1) == 0
    error('Contains no valid images, please select another directory')
else
    i = start;
    while i < size(subset_images,1);
        %grabs image, shows it in a figure, prompts for description of
        %picture, and saves current values in jpegingo.mat file
        
        %grab image
        img = imread(subset_images{i,:});
        
        %open figure
        figure
        h_im = image(img);
   
        %sets name of jpeg in 1st cell column, description inputed into
        %second column
        results{i,1} = jpeg_files{i};
        
        %grabs description, stop or back keywords
        str = input('Description: ','s');
        
        %split the string up in case a back is called
        exp_parts = regexp(str, ' ', 'split');
        
        %close the figure
        close;
        
        %check to see if a person wishes to move back
        if strcmpi(exp_parts(1), 'back') == 1
            amtback = str2double(exp_parts(2));
            if i > amtback
                i = i - amtback;
            end
            
        elseif strcmpi(exp_parts(1), 'forward') == 1
            amtback = str2double(exp_parts(2));
            if i + amtback <= size(subset_images,1)
                i = i + amtback;
            end
        %checks to see if the person is done checking pictures
        elseif strcmpi(str, 'stop') == 1
            %breaks from checking more images
            break;
            
        %continues otherwise
        else 
            results{i,2} = str;
            i = i + 1;
        end
    end
    
    %save current work in .mat file
    save('jpeginfo', 'results', 'i', 'subset_images');
end
