function [kmat,kresults] = phenokmeanscompression(indir,outdir,...
        windowsize,sttime,endtime,threshold,numclusters,numpics,sampledata)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%% I don't know what the difference is between this and
%%%%%%% kmeanscompression2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%This code creates a kmeans clustering matrix for which there are a 
%predefined number of regions of interest to splic the code into.  The 
%inputs are the archive of images.  The function also needs date2jd, 
%isleapyear to be in the search path.  The easiest way is to make sure the 
%source files are in the same directory as this function.
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
%% check the arguments
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
%set base number of pictures to grab and clusters to make
if numpics == 0;
    numpics = 10;
end
if numclusters == 0;
    numclusters = 6;
end
disp(numpics);
%% Get the subset of images specified

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


% calculate doy from year / month / ...
subset_doy = date2jd(subset_year,subset_month,subset_day,subset_hour,subset_min);
max_doy = max(unique(subset_doy));
min_doy = min(unique(subset_doy));

%% Grab Kmeans pictures

% make a matrix to contain the year and date information
results = zeros(size_subset_images,2);

%make 1st image as mask file.
mask = imread(subset_images(1,:));

% fill year column
results(:,1) = subset_year;

% waitbar settings
h = waitbar(0,'Please wait...','Name','Processing Images...',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');     

for i=1:size_subset_images;
        
    % Report current estimate in the waitbar's message field
    waitbar(i/size_subset_images);
    
    % calculate DOY 
    results(i,2) = date2jd(subset_year, subset_month(i), subset_day(i),...
        subset_hour(i), subset_min(i));   
end

% delete wait           disp('we get here;');bar handle when done
delete(h);

% create filter for smoothing
windowsize = floor(windowsize/2);

% smooth the data using the moving quantile method
start = round(min_doy + windowsize);


% set threshold (dark images)
threshold = 255*(threshold/100);

% create the matrix to hold image data for kmeans
%disp(size(mask,1)*size(mask,2)*3*(l - start)/1024/1024);
kmat = zeros(size(mask,1)*size(mask,2)/4,numpics*size(mask,3));
kindex = 1;

% create vector of days-of-year 
DOY = round(results(:,2));

% now, run window filtering for all days 
picsadded = 1;
figure('Position', [0 0 1920 1080])
skip = 1;
if(windowsize ~= 0)
    skip = 2*windowsize;
end

for n=start:skip:max_doy;
    if kindex <= (numpics-1)*size(mask,3) + 1;
        % if windowsize = 0, just compute for data on that same day
        if windowsize == 0;
            correctindexes = DOY;
            correctindexes(correctindexes == n) = -1;
            correctindexes(correctindexes ~= n & correctindexes ~= -1) = -2;
            
        % if windowsize <= 1, then impose window
        else
            correctindexes = DOY;
            correctindexes(correctindexes >= n -windowsize & correctindexes <= n +windowsize) = -1;
            correctindexes(correctindexes > n +windowsize | correctindexes <...
                n -windowsize & correctindexes ~= -1) = -2;
        end
        subset = subset_images(correctindexes == -1, :);
        gccmat = zeros(size(subset,1),3);
        
        %enforce threshold and compute gcc
        for i = 1:size(subset);
            img = imread(subset(i,:));
            red = mean(mean(img(:,:,1)));
            green = mean(mean(img(:,:,2)));
            blue = mean(mean(img(:,:,3)));
            gccmat(i,1) = green / (green + red + blue);
            gccmat(i,2) = i;
            gccmat(i,3) =  (red > threshold) & (green > threshold) & (blue > threshold);
        end
        
        %grab images that pass threshold
        gccmatn = gccmat(gccmat(:,3) == 1,:);
        if size(gccmatn,1) > 0;
            gccmatn = sortrows(gccmatn, 1);
            tempimg = imread(subset(gccmatn(ceil(size(gccmatn,1)*.9),2),:));
            s1 = size(tempimg,1);
            s2 = size(tempimg,2);
            subplot(3, 4, picsadded); imagesc(tempimg); title(subset(gccmatn(ceil(size(gccmatn,1)*.9),2),:))
            
            % make sure images have same dimesnsions
            if s1 ~= size(mask,1) || s2 ~= size(mask,2)  
                error(cat(2,'original and input image are not the same dimensions: ',...
                    subset_images(i,:)));
            end
            for i = 1:s1/2;
                for j = 1:s2/2;
                    kmat((i-1)*(s2/2) + j,kindex) = (tempimg(2*i,2*j,1) + ...
                        tempimg(2*i,2*j-1,1) + tempimg(2*i-1,2*j,1) + ...
                        tempimg(2*i-1,2*j-1,1))/4;
                    kmat((i-1)*(s2/2) + j,kindex + 1) = (tempimg(2*i,2*j,2) + ...
                        tempimg(2*i,2*j-1,2) + tempimg(2*i-1,2*j,2) + ...
                        tempimg(2*i-1,2*j-1,2))/4;
                    kmat((i-1)*(s2/2) + j,kindex + 2) = (tempimg(2*i,2*j,3) + ...
                        tempimg(2*i,2*j-1,3) + tempimg(2*i-1,2*j,3) + ...
                        tempimg(2*i-1,2*j-1,3))/4;
                end
            end
            kindex = kindex + 3;
            picsadded = picsadded + 1;
        end
    end
end

%% Conduct kmeans and store results

%this is currently under construction.  Any one of the following
%implementations work, but I am trying to improve the results.

rowsize = ceil(numclusters/2);

figure('Name', 'City distances')
subplot(2, rowsize, 1); imagesc(mask); title('Source')
for val = 2:numclusters;
    disp(strcat('Kmeans cluster size: ', int2str(val)));
    if nargin < 9;
        kresults = kmeans(kmat, val, 'EmptyAction', 'singleton', 'distance', 'city', 'replicates', 5);
    else
        kresults = kmeans(kmat, val, 'EmptyAction', 'singleton', 'distance', 'city', 'start', sampledata);
    end
    kresults = reshape(kresults,size(img,2)/2,size(img,1)/2);
    kresults = fliplr(kresults);
    kresults = rot90(kresults);
    subplot(2, rowsize, val); imagesc(kresults); colormap(gray); title(int2str(numclusters)); colormap('hot'); colorbar;
    %dlmwrite([int2str(val) 'clusters.txt'], kresults);
end
%{
figure('Name', 'Euclidian','Position', [0 0 1920 1080])
subplot(2, rowsize, 1); imagesc(mask); title('Source')
for val = 2:numclusters;
    disp(strcat('Kmeans cluster size: ', int2str(val)));
    kresults = kmeans(kmat,val, 'EmptyAction', 'singleton', 'distance', 'sqEuclidean', 'replicates', 5);
    kresults = reshape(kresults,size(img,2)/2,size(img,1)/2);
    kresults = fliplr(kresults);
    kresults = rot90(kresults);
    subplot(2, rowsize, val); imagesc(kresults); colormap(gray); title(int2str(val))
    %dlmwrite([int2str(val) 'clusters.txt'], kresults);
end


figure('Name', 'Uniform Euclidean','Position', [0 0 1920 1080])
subplot(2, rowsize, 1); imagesc(mask); title('Source')
for val = 2:numclusters;
    disp(strcat('Kmeans cluster size: ', int2str(val)));
    kresults = kmeans(kmat,val, 'EmptyAction', 'singleton', 'distance', 'sqEuclidean', 'start', 'uniform');
    kresults = reshape(kresults,size(img,2)/2,size(img,1)/2);
    kresults = fliplr(kresults);
    kresults = rot90(kresults);
    subplot(2, rowsize, val); imagesc(kresults); colormap(gray); title(int2str(val))
    %dlmwrite([int2str(val) 'clusters.txt'], kresults);
end

tic
figure('Name', 'kmeans2','Position', [0 0 1920 1080])
subplot(2, rowsize, 1); imagesc(mask); title('Source')
for val = 2:numclusters;
    disp(strcat('Kmeans cluster size: ', int2str(val)));
    [kresults,m,md,qu,q] = kmeans2(kmat,val);
    kresults = reshape(m,size(img,2)/2,size(img,1)/2);
    kresults = fliplr(kresults);
    kresults = rot90(kresults);
    subplot(2, rowsize, val); imagesc(kresults); colormap(gray); title(int2str(val))
    %dlmwrite([int2str(val) 'clusters.txt'], kresults);
end
toc
tic
figure('Name', 'litekmeans','Position', [0 0 1920 1080])
subplot(2, rowsize, 1); imagesc(mask); title('Source')
for val = 2:numclusters;
    disp(strcat('Kmeans cluster size: ', int2str(val)));
    tempmat = rot90(kmat);
    kresults = litekmeans(tempmat,val);
    kresults = reshape(kresults,size(img,2)/2,size(img,1)/2);
    kresults = fliplr(kresults);
    kresults = rot90(kresults);
    subplot(2, rowsize, val); imagesc(kresults); colormap(gray); title(int2str(val))
    %dlmwrite([int2str(val) 'clusters.txt'], kresults);
end
toc
tic
figure('Name', 'kmeans','Position', [0 0 1920 1080])
subplot(2, rowsize, 1); imagesc(mask); title('Source')
for val = 2:numclusters;
    disp(strcat('Kmeans cluster size: ', int2str(val)));
    kresults = kmeans(kmat,val, 'EmptyAction', 'singleton', 'distance', 'sqEuclidean', 'start', 'uniform');
    kresults = reshape(kresults,size(img,2)/2,size(img,1)/2);
    kresults = fliplr(kresults);
    kresults = rot90(kresults);
    subplot(2, rowsize, val); imagesc(kresults); colormap(gray); title(int2str(val))
    %dlmwrite([int2str(val) 'clusters.txt'], kresults);
end
toc


figure('Name', 'Uniform City','Position', [0 0 1920 1080])
subplot(2, rowsize, 1); imagesc(mask); title('Source')
for val = 2:numclusters;
    disp(strcat('Kmeans cluster size: ', int2str(val)));
    kresults = kmeans(kmat,val, 'EmptyAction', 'singleton', 'distance', 'city', 'start', 'uniform');
    kresults = reshape(kresults,size(img,2)/2,size(img,1)/2);
    kresults = fliplr(kresults);
    kresults = rot90(kresults);
    subplot(2, rowsize, val); imagesc(kresults); colormap(gray); title(int2str(val))
    %dlmwrite([int2str(val) 'clusters.txt'], kresults);
end


%% more testing
kres = zeros(size(kmat,1),numpics);
for i = 1: numpics
    kres(:,i) = rot90(kmeans(kmat(:,(i - 1)*3 + 1:(i*3)),6, 'EmptyAction', 'singleton', 'distance', 'city'));
end
kres = rot90(kmeans(kres,6, 'EmptyAction', 'singleton', 'distance', 'city'));
kres = rot90(kres,3);
kres = reshape(kres,size(img,2)/2,size(img,1)/2);
kres = fliplr(kres);
kres = rot90(kres);
figure
imagesc(kres); colormap(gray); colorbar; 
%}
