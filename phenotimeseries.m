function phenotimeseries(indir,outdir,maskfile,windowsize,sttime,endtime,...
                         nroi,threshold,smoothtechnique,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function to run a non-GUI version of the phenocamimageprocessor created
% by Koen Hufkens. In short, the code generates a simple spectral index,
% the green chromatic coordinate, for a large database (1+ years) of webcam
% imagery. The main inputs are the imagery archive and ROI, as created by
% Matlab function, ROICreation. If created otherwise, one must ensure that
% the input binary mask file has only one variable, named "mask", which
% serves as the binary ROI/mask. The function also needs the accompanying
% functions, date2jd, isleapyear, and myquantile to be in the search path.
% The easiest way to do this is make sure that those source files are in
% the same folder as this function, since the code corrects for this.
%
% SYNTAX:
%     phenotimeseries(indir,outdir,maskfile,windowsize)
%         indir = input directory with images (JPEG only) and mask
%         outdir = output directory where ASCII results will be written
%         maskfile = Matlab *mat format binary mask/ROI
%         windowsize = window size for smoothing, in days, use 0 if no smoothing
% 
%     phenotimeseries(indir,outdir,maskfile,windowsize,sttime,endtime)
%         indir = input directory with images (JPEG only) and mask
%         outdir = output directory where ASCII results will be written
%         maskfile = Matlab *mat format binary mask/ROI
%         windowsize = window size for smoothing, in days, use 0 if no smoothing
%         sttime, endtime = starting and ending hour for processing images, 
%                           default is 7h00 and 17h00
%
%     phenotimeseries(indir,outdir,maskfile,windowsize,sttime,endtime,nroi,threshold,smoothtechnique)
%         indir = input directory with images (JPEG only) and mask
%         outdir = output directory where ASCII results will be written
%         maskfile = Matlab *mat format binary mask/ROI
%         windowsize = window size for smoothing, in days, use 0 if no smoothing
%         sttime, endtime = starting and ending hour for processing images, 
%                           default is 7h00 and 17h00
%         nroi = number of binary mask files, default is 1
%         threshold = darkness threshold, in image DNs 
%         smoothtechnique = smoothing techique to get daily values, where 
%                        1 = 90th percentile, 2 = mean, 3 = median
%                        default value is 1 (90th percentile)
%
% EXAMPLE:
%     phenotimeseries('C:\data\harvard\2009','C:\data\harvard','harvardmask.mat',
%     3, 8, 16, 1, 15, 1)
%       This use of the function finds images and the binary mask in
%       'C:\data\harvard\2009', outputs to 'C:\data\harvard\', uses the
%       binary mask, 'harvardmask.mat'; the window size for smoothing is 3
%       days, the hours of valid data are 8:00 to 16:00, there is one ROI,
%       the darkness threshold is 15 and the smoothing technique is #1, or
%       90th percentile thresholding. 
%
% Original code written by Koen Hufkens, khufkens@bu.edu, Sept. 2011,
% published under a GPLv2 license and is free to redistribute.
%
% Matlab function file written by Michael Toomey, mtoomey@fas.harvard.edu,
% January 27, 2011
%
% Please reference the necessary publications when using the
% the 90th percentile method:
% Sonnentag et al. 2011 (Agricultural and Forest Management)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if nargin < 4 % check input arguments
    error('Not enough input arguments. Please see help file for phenotimeseries')
elseif nargin == 4
    if ischar(indir) == 0
        error('Input directory must be string')
    end
    if ischar(outdir) == 0
        error('Output directory must be string')
    end
    if ischar(maskfile) == 0
        error('Maskfile must be string')        
    end
    if isnumeric(windowsize) == 0
       error('windowsize must be a number')
    end
elseif nargin == 5
    error('Must include both sttime and endtime')
elseif nargin == 6
    if ischar(indir) == 0
        error('Input directory must be string')
    end
    if ischar(outdir) == 0
        error('Output directory must be string')
    end
    if ischar(maskfile) == 0
        error('Maskfile must be string')        
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
elseif nargin == 7
    error('Not enough input arguments. Please see help file for phenotimeseries')
elseif nargin == 8
    error('Not enough input arguments. Please see help file for phenotimeseries')
elseif nargin == 9
    if ischar(indir) == 0
        error('Input directory must be string')
    end
    if ischar(outdir) == 0
        error('Output directory must be string')
    end
    if ischar(maskfile) == 0
        error('maskfile directory must be string')        
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
    if isnumeric(nroi) == 0
       error('nroi must be a number')
    end
    if isnumeric(threshold) == 0
       error('threshold must be a number')
    end
    if isnumeric(smoothtechnique) == 0
       error('smoothtechnique must be a number')
    end
end

% set current directory and add to search path
cd(indir) 
addpath(indir)

% open binary ROI mask
load(maskfile);

% list all jpeg files in valid directory
% and get the number of jpegs in the directory
jpeg_files = dir('*.jpg');
nrjpegs = size(jpeg_files,1);

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
       parts = regexp(jpeg_files(i,1).name,'_','split');
       year(i) =  str2double(char(parts(2)));
       month(i) =  str2double(char(parts(3)));
       day(i) =  str2double(char(parts(4)));
       time = char(parts(5));
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
subset_images = char(jpeg_files.name);
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

% calculate doy from year / month / ...
subset_doy = date2jd(subset_year,subset_month,subset_day,subset_hour,subset_min);
max_doy = max(unique(subset_doy));
min_doy = min(unique(subset_doy));

% make a matrix to contain the results (length list, indices - 5)
results = zeros(size_subset_images,6,nroi);

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

% make matrix to dump smoothed results in
gccsmooth = zeros(round(max_doy),1,nroi);

% set threshold (dark images)
threshold = 255*(threshold/100);

% smooth time series and enforce darkness thresholds
for i=1:nroi;
    % create vector of days-of-year 
    DOY = round(results(:,2,i));
    % now, run window filtering for all days 
    for n=windowsize+1:l;
        
        gccsmooth(n,1,i) = n;
        % if windowsize = 0, just compute for data on that same day and
        % enforce threshold
        if windowsize == 0;
        subset = results(DOY == n & results(:,3,i) > threshold & results(:,4,i)...
            > threshold & results(:,5,i) > threshold,6,i);
        % if windowsize <= 1, then impose window and enforce threshold 
        else
        subset = results(DOY >= n-windowsize & DOY <= n+windowsize & results(:,3,i)...
            > threshold & results(:,4,i) > threshold & results(:,5,i) > threshold,6,i);
        end
        
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
