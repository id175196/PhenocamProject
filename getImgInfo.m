function [vals] = getImgInfo(img, numplaces)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
vals = {};
img = imread(img);
figure;
clf;
h = imagesc(img);
for i = 1:numplaces;
    vals{i} = ginput;
end
close;
end
