function classifyImages(indir,sitename,stmonth,endmonth,stday,endday,year)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This code takes a subset of directory of images based on starting and 
%ending dates and allows the client to write a description of the image, 
%which is stored in a .mat file when completed.  There are 3 built in 
%commands when describing images: back, forward, and save.  back and
%forward switch from the current image to the image x ago/forward. save
%simply saves your current progress.
%
% SYNTAX:
%     back 5
%         moves back 5
%     forward 8
%         moves forward 8
%
% SYNTAX:
%     classifyImages(indir,stmonth,endmonth,stday,endday)
%         indir = input directory with images
%         sitename = string containing sitename
%         stmonth = month to start image processing from
%         endmonth = month to end image processing
%         stday = day to start image processing from
%         endday = day to end image processing
%
%    classifyImages(indir,stmonth,endmonth,stday,endday,year)
%         indir = input directory with images
%         sitename = string containing sitename
%         stmonth = month to start image processing from
%         endmonth = month to end image processing
%         stday = day to start image processing from
%         endday = day to end image processing
%         year = year to do image processing on
%
%
% EXAMPLE:
%      classifyImages('/home/dmitri/Documents/Groundhog_sample_imgs',
%       groundhog, 1, 12, 1, 5)
%       This use of the function finds images in
%       '/home/dmitri/Documents/Groundhog_sample_imgs', sets the timeframe
%       to be from
%       January 1st to December 5th.
%
% Matlab function file written by Dmitri Ilushin, dilushin@college.harvard.edu,
% February 14, 2012
%
% modified by Stephen Klosterman, steve.klosterman@gmail.com, Feb 26, 2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% check input arguments
if nargin < 6
    error('Not enough input arguments. Please see help file for classifyImages')
elseif nargin == 6
    if ischar(indir) == 0
       error('Input directory must be string')
    end
    if ischar(sitename) == 0
       error('sitename must be string')
    end
elseif nargin == 7
    if ischar(indir) == 0
       error('Input directory must be string')
    end
    if ischar(sitename) == 0
       error('sitename must be string')
    end
    if isnumeric(year) == 0
       error('year must be string')
    end
elseif nargin > 7
    error('too many inputs')
end

%% get input directory info

% list all jpeg files in valid directory
% and get the number of jpegs in the directory
if(nargin == 7)
    jpeg_files = getAllFilesjpg([indir filesep sitename filesep num2str(year)]);
else
    jpeg_files = getAllFilesjpg([indir filesep sitename]);
end
nrjpegs = size(jpeg_files,1);

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
     & (dates(:,2) >=stday | dates(:,1) > stmonth) & (dates(:,2) <= endday...
     | (dates(:,1) < endmonth)));
 
%makes sure files are found
%this error check should be here
if size(subset_images,1) == 0
    error('Contains no valid images, please select another directory');
    return;
end

%% get ready to save results
%These things should be done after subsetting images.
%create file name to save results, specific to the dates
if(nargin == 7)
    saveName = ['classify_' sitename '_' num2str(year) '_' ...
        num2str(stmonth) '_' ...
        num2str(stday) '_to_'...
        num2str(endmonth) '_' ...
        num2str(endday) '.mat'];
else 
    saveName = ['classify_' sitename '_'...
        num2str(stmonth) '_' ...
        num2str(stday) '_to_'...
        num2str(endmonth) '_' ...
        num2str(endday) '.mat'];
end
% we only want an array as large as the number of results we're going to
% generate
%number of results to generate
nResults = length(subset_images);

%create matrix to hold data information
dates = zeros(nResults, 2);

%create matrix to store results
results = cell(nResults,2);

%% not necessary to change directories.
%sets directory to specified outdir
% cd(outdir)
%got rid of outdir.  I think it makes more sense to save results in the
%same directory as this function
disp([subset_images{nResults,:}]);

%% classify images
%starting point in images to run on.  will change if wanted to.
start = 1;

%checks to see if there has already been work.  use the == 2 test instead
%of treating as one or zero for clarity
if exist(saveName, 'file') == 2
    answer = input(...
        'Would you like to continue from where you left off? (y/n)  ','s');
    %checks to see if you would like to continue from the previous point
    if strcmpi(answer,'y')
        struct = open(saveName);
        %set starting point to be the point left off from last time
        start = struct.i;
        %sets the results to the previous results of the values.
        results = struct.results;
        %sets the image set to work on to previous dataset
        subset_images = struct.subset_images;
    end
end

i = start;
while i < size(subset_images,1);
    %grabs image, shows it in a figure, prompts for description of
    %picture, and saves current values in jpegingo.mat file
       
    %grab image
    img = imread([subset_images{i,:}]);
        
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
    elseif strcmpi(str, 'save') == 1
        %breaks from checking more images
        break;
            
    %continues otherwise
    else 
        results{i,2} = str;
        i = i + 1;
    end
end

%% save results
save(saveName, 'results', 'i', 'subset_images', 'stmonth', 'endmonth',...
    'stday', 'endday');