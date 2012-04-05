function phenokmeans(indir,outdir,windowsize,sttime,endtime,...
                        nroi,threshold,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This code creates a kmeans clustering matrix for which there are a 
%predefined number of regions of interest to splic the code into.  The 
%inputs are the archive of images.  The function also needs date2jd, 
%isleapyear to be in the search path.  The easiest way is to make sure the 
%source files are in the same directory as this function.
%
% SYNTAX:
%     phenokmeans(indir,outdir,windowsize)
%         indir = input directory with images (JPEG only)
%         outdir = output directory where kmeans results will be written
%         windowsize = window size for smoothing, in days, use 0 if no smoothing
%
%     phenokmeans(indir,outdir,windowsize,sttime,endtime)
%         indir = input directory with images (JPEG only) and mask
%         outdir = output directory where ASCII results will be written
%         windowsize = window size for smoothing, in days, use 0 if no smoothing
%         sttime, endtime = starting and ending hour for processing images,
%                           default is 7h00 and 17h00
%
%     phenotimeseries(indir,outdir,windowsize,sttime,endtime,threshold)
%         indir = input directory with images (JPEG only) and mask
%         outdir = output directory where ASCII results will be written
%         windowsize = window size for smoothing, in days, use 0 if no smoothing
%         sttime, endtime = starting and ending hour for processing images,
%                           default is 7h00 and 17h00
%         threshold = darkness threshold, in image DNs
%
% EXAMPLE:
%     phenokmeans('C:\data\harvard\2009','C:\data\harvard',
%     3, 8, 16, 1, 15, 1)
%       This use of the function finds images in
%       'C:\data\harvard\2009', outputs to 'C:\data\harvard\', uses the
%       kmeans function on this information; the window size for smoothing is 3
%       days, the hours of valid data are 8:00 to 16:00,
%
% Original code written by Koen Hufkens, khufkens@bu.edu, Sept. 2011,
% published under a GPLv2 license and is free to redistribute.
%
% Matlab function file written by Dmitri Ilushin, dilushin@college.harvard.edu,
% February 14, 2012
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 3 % check input arguments
    error('Not enough input arguments. Please see help file for phenotimeseries')
elseif nargin == 3
    if ischar(indir) == 0
       error('Input directory must be string')
    end
    if ischar(outdir) == 0
       error('Output directory must be string')
    end
    if isnumeric(windowsize) == 0
      error('windowsize must be a number')
    end
elseif nargin == 4
    error('4 inputs not enough')
elseif nargin == 5
    if ischar(indir) == 0
       error('Input directory must be string')
    end
    if ischar(outdir) == 0
       error('Output directory must be string')
    end
    if isnumeric(windowsize) == 0
      error('windowsize must be a number')
    end
    if isnumeric(sttime) == 0
      error('sttime must be a number')
    end
    if isnumeric(endtime) == 0
      error('endtime must be a number')
    end
elseif nargin == 6
    if ischar(indir) == 0
       error('Input directory must be string')
    end
    if ischar(outdir) == 0
       error('Output directory must be string')
    end
    if isnumeric(windowsize) == 0
      error('windowsize must be a number')
    end
    if isnumeric(sttime) == 0
      error('sttime must be a number')
    end
    if isnumeric(endtime) == 0
      error('endtime must be a number')
    end
    if isnumeric(threshold) == 0
      error('threshold must be a number')
    end
end

% set current directory and add to search path
cd(indir) 
addpath(indir)

% list all jpeg files in valid directory
% and get the number of jpegs in the directory
jpeg_files = getAllFilesjpg(indir);
nrjpegs = size(jpeg_files,1);
%disp(nrjpegs);
if isempty(jpeg_files)
    error('Contains no valid images, please select another directory')
else

    % define containing matrices for year/month/day/hour/min variables
    year = zeros(nrjpegs,1);
    month = zeros(nrjpegs,1);
    day = zeros(nrjpegs,1);
    hour = zeros(nrjpegs,1);
    minutes = zeros(nrjpegs,1);

    % extract date/time values from filename using string manipulation
    for i=1:nrjpegs
       % split strings by the underscore
       parts = regexp(jpeg_files(i),'_','split');
       numexps = size(parts{1},2);
       year(i) =  str2double(parts{1}(numexps-3));
       month(i) =  str2double(parts{1}(numexps-2));
       day(i) =  str2double(parts{1}(numexps-1));
       time = char(parts{1}(numexps));
       hour(i) = str2double(time(1:2));
       minutes(i) = str2double(time(3:4));            
    end

    % calculate the range of hours of the images (min / max)
    min_hour = min(hour);
    max_hour = max(hour);
    mean_hour = round((min_hour + max_hour) / 2);

    AM = min_hour : (mean_hour-1);
    PM = mean_hour : max_hour;
    
end

% make a subsetted list of jpegs to be processed within the valid
% processing window, defined by "sttime" and "endtime"
subset_images = char(jpeg_files);
subset_images = subset_images(hour >= sttime & hour <= endtime,:);

% get the length of this list
size_subset_images = size(subset_images,1);

% subset year / month / day / hour / min
subset_year = year(hour >= sttime & hour <= endtime,:);
subset_month = month(hour >= sttime & hour <= endtime,:);
subset_day = day(hour >= sttime & hour <= endtime,:);
subset_hour = hour(hour >= sttime & hour <= endtime,:);
subset_min = minutes(hour >= sttime & hour <= endtime,:);

% convert year / month / day / hour / min ... sec to matlab date
subset_year = unique(subset_year');
subset_month = subset_month';
subset_day = subset_day';
subset_hour = subset_hour';
subset_min = subset_min';

disp(size(subset_year));
disp(size(subset_hour));
disp(size(subset_day));
disp(size(subset_month));
disp(size(subset_min));
disp(size_subset_images);

% calculate doy from year / month / ...
subset_doy = date2jd(subset_year,subset_month,subset_day,subset_hour,subset_min);
max_doy = max(unique(subset_doy));
min_doy = min(unique(subset_doy));

% make a matrix to contain the results (length list, indices - 5)
results = zeros(size_subset_images,7,nroi);

%make 1st image as mask file.
mask = imread(subset_images(1,:));
mask = mask(:,:,1);

% fill year column
results(:,1,:) = subset_year;

% waitbar settings
h = waitbar(0,'Please wait...','Name','Processing Images...',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');     

for i=1:size_subset_images;
    
    % calculate gcc ./ mask and for every layer grab the mean
        
    % Report current estimate in the waitbar's message field
    waitbar(i/size_subset_images);
    
    % calculate DOY 
    results(i,2,:) = date2jd(subset_year, subset_month(i), subset_day(i),...
        subset_hour(i), subset_min(i));  
    
    % read in image
    img = imread(subset_images(i,:));
    % make sure they are the same dimensions
    if size(img,1) ~= size(mask,1) || size(img,2) ~= size(mask,2)  
        error(cat(2,'Mask and input image are not the same dimensions: ',...
            subset_images(i,:)))
    end
    
    % split image into its components
    red = img(:,:,1);
    green = img(:,:,2);
    blue = img(:,:,3);
    
    % calculate green chromatic coordinates    
    for j=1:nroi
        msk = mask(:,:,j);
        results(i,3,j) = mean(mean(red(msk == 1)));
        results(i,4,j) = mean(mean(green(msk == 1)));
        results(i,5,j) = mean(mean(blue(msk == 1)));
        
         % calculate green chromatic coordinates
        gcc = results(i,4,j) ./ (results(i,3,j) + results(i,4,j) + results(i,5,j));
        
        % put gcc values in results
        results(i,6,j) =  gcc;
    end    
end

% delete waitbar handle when done
delete(h);

% create filter for smoothing
windowsize = floor(windowsize/2);

% smooth the data using the moving quantile method
l = round(max_doy - windowsize);
start = round(min_doy + windowsize);

% make matrix to dump smoothed results in
gccsmooth = zeros(round(max_doy),1,nroi);

% set threshold (dark images)
threshold = 255*(threshold/100);

% create the matrix to hold image data for kmeans
%disp(size(mask,1)*size(mask,2)*3*(l - start)/1024/1024);
kmat = zeros(size(mask,1)*size(mask,2),3*(l-start + 1));
kindex = 1;

% create vector of days-of-year 
DOY = round(results(:,2,1));

%disp(subset_images);

% now, run window filtering for all days 
n = 0;
for n=start:windowsize + 1:l;
    %disp(results(:,2));
    disp(n);
    % if windowsize = 0, just compute for data on that same day and
    % enforce threshold
    if windowsize == 0;
        correctindexes = results(:,2);
        correctindexes(abs(correctindexes - n )<= 1) = 1;
        correctindexes(abs(correctindexes - n )> 1 & correctindexes ~= 1) = 0;
    %subset = subset_images(results(DOY == n));
    % if windowsize <= 1, then impose window and enforce threshold 
    else
        correctindexes = results(:,2);
        correctindexes(correctindexes >= n -windowsize & correctindexes <= n +windowsize) = 1;
        correctindexes(correctindexes > n +windowsize | correctindexes <...
            n -windowsize & correctindexes ~= 1) = 0;
    %subset = subset_images(results(DOY >= n-windowsize & DOY <= n+windowsize));
    end
    %disp(correctindexes);
    subset = subset_images(correctindexes == 1, :);
    %disp(subset);
    gccmat = zeros(size(subset,1),2);
    for i = 1:size(subset);
        %disp(subset(i,:));
        img = imread(subset(i,:));
        red = mean(mean(img(:,:,1)));
        green = mean(mean(img(:,:,2)));
        blue = mean(mean(img(:,:,3)));
        gccmat(i,1) = green / (green + red + blue);
        gccmat(i,2) = i;
    end
    gccmat = sortrows(gccmat, 1);
    if size(subset) > 0;
        tempimg = imread(subset(gccmat(ceil(size(gccmat,1)*.9),2),:));
        s1 = size(tempimg,1);
        s2 = size(tempimg,2);
        for i = 1:s1;
            for j = 1:s2;
                kmat((i-1)*s2 + j,kindex) = tempimg(i,j,1);
                kmat((i-1)*s2 + j,kindex + 1) = tempimg(i,j,2);
                kmat((i-1)*s2 + j,kindex + 2) = tempimg(i,j,3);
            end
        end
        kindex = kindex + 3;
    end
    
end
disp(n);

kresults = kmeans(kmat,6);
%}
%{
    % impose GCC smoothing technique
    % 90th percentile
    if smoothtechnique == 1
        gccsmooth(n,2,i)=myquantile(subset,0.9);
        smoothstr = '90th-';
    % mean
    elseif smoothtechnique == 2
        gccsmooth(n,2,i)=nanmean(subset);        
        smoothstr = 'mean-';
    % median
    elseif smoothtechnique == 3
        gccsmooth(n,2,i)=nanmedian(subset);
        smoothstr = 'median-';
    end

end


% save results in output folder
cd(outdir)
% determine the year that was processed
year = unique(year);

for i=1:nroi
    % save raw results
    filenameraw = char(strcat('raw-',num2str(i),'-',parts(1),'_',num2str(year),'.txt'));
    rawdata = results(:,:,i);
    dlmwrite(filenameraw,rawdata);

    % save smoothed results
    filenamesmooth = char(strcat('smooth-',smoothstr,num2str(i),'-',parts(1),'_',num2str(year),'.txt'));
    smoothdata = gccsmooth(:,:,i);
    % add year to smoothed data
    l = size(smoothdata,1);
    years = zeros(l,1);
    years(:,1) = year;
    smoothdata = [years, smoothdata];
    dlmwrite(filenamesmooth,smoothdata);
end

disp(cat(2,'Done with year ',num2str(year)))
%}