function [] = vegetation_entropy()

% get all image filenames and attribute data
files = dir('*.jpg');

% calculate how many files there are
m = size(files,1);

% initiate a waitbar
h = waitbar(0,'Please wait...');    

% for every file in the list of files do    
for i=1:m

	% read file on location i in files struct()
	img = imread(files(i).name);
	
	% convert to greyscale
	%img = rgb2gray(img);
    
    % adjust range to be the same for every image
    %img = imadjust(img);
    
	
	% apply entropy filter with a kernel size of 3x3
	% true(3) generates a 3x3 matrix containing 1's
	Eimg = entropyfilt(img,true(5));
	
	% convert the matrix to an image object
	Eimg = mat2gray(Eimg);
	
	% write the image object to file (sadly jpg since R doesn't handle that many formats)
	imwrite(Eimg,sprintf('../entropy/entropy_%s',files(i).name),'Quality',100);
	
	% increment waitbar handle
	waitbar(i / m);

end

% close waitbar
close(h);
end