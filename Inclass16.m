% Akash Mitra
% am132

% Inclass16

%The 
% Sbalzarini IF, Koumoutsakos P (2005) Feature point tracking and trajectory analysis 
% for video imaging in cell biology. J Struct Biol 151:182?195.
%folder in this repository contains code implementing a Tracking
%algorithm to match cells (or anything else) between successive frames. 
% It is an implemenation of the algorithm described in this paper: 
%
%The main function for the code is called MatchFrames.m and it takes three
%arguments: 
% 1. A cell array of data called peaks. Each entry of peaks is data for a
% different time point. Each row in this data should be a different object
% (i.e. a cell) and the columns should be x-coordinate, y-coordinate,
% object area, tracking index, fluorescence intensities (could be multiple
% columns). The tracking index can be initialized to -1 in every row. It will
% be filled in by MatchFrames so that its value gives the row where the
% data on the same cell can be found in the next frame. 
%2. a frame number (frame). The function will fill in the 4th column of the
% array in peaks{frame-1} with the row number of the corresponding cell in
% peaks{frame} as described above.
%3. A single parameter for the matching (L). In the current implementation of the algorithm, 
% the meaning of this parameter is that objects further than L pixels apart will never be matched. 

% Continue working with the nfkb movie you worked with in hw4. 

% Part 1. Use the first 2 frames of the movie. Segment them any way you
% like and fill the peaks cell array as described above so that each of the two cells 
% has 6 column matrix with x,y,area,-1,chan1 intensity, chan 2 intensity

reader1 = bfGetReader('nfkb_movie1.tif');

z1=1;
c2=1;
t3=1;

iplane = reader1.getIndex(z-1, c-1, t-1)+1;
img1 = bfGetPlane(reader1, iplane);
imwrite(img1, 'First.tif');



iplane2 = reader1.getIndex(z-1, c-1, t)+1;
img2 = bfGetPlane(reader1, iplane2);
imwrite(img2, 'First.tif','WriteMode','append');

figure;
subplot(1,2,1); imshow(img1,[]);
subplot(1,2,2); imshow(img2,[]);

im_masks = h5read('/Users/amitra2/Documents/CompbioRice17/inclass16_new.h5', '/exported_data');
im_masks = squeeze(im_masks);
mask_t1 = im_masks(:,:,1);
mask_t2 = im_masks(:,:,2);

figure;
subplot(1,2,1); imshow(mask_t1);
subplot(1,2,2); imshow(mask_t2);

stats1 = regionprops(mask_t1, 'Area','MeanIntensity');
area1 = stats1.Area;
m1 = stats1.MeanIntensity(1);
m2 = stats1.MeanIntensity(2);
stats2 = regionprops(mask_t2, 'Area','MeanIntensity');
area2 = stats2.Area;
m3 = stats1.MeanIntensity(1);
m4 = stats1.MeanIntensity(2);

reader2 = bfGetReader('First.tif');

x1=reader2.getSizeX;
c1=reader2.getSizeC;
y1=reader2.getSizeY;

z2=reader2.getSizeZ;
c2=reader2.getSizeC;
t2=reader2.getSizeT;

iplane2 = reader1.getIndex(z2, c2, t2)+1;
img2 = bfGetPlane(reader1, iplane2);

im_info = {x1,y1,area1,-1,m1,m2;
    x2,y2,area2,-1,m3,m4);




% Part 2. Run match frames on this peaks array. ensure that it has filled
% the entries in peaks as described above. 

peaks_matched = MatchFrames(im_info, 2, 100);
peaks_matched{1};

% Part 3. Display the image from the second frame. For each cell that was
% matched, plot its position in frame 2 with a blue square, its position in
% frame 1 with a red star, and connect these two with a green line. 

figure;
imshow(img1,[]);
hold on;
for i = 1:size(im_info{1}),
    text(im_info{1}(i,1), im_info{1}(i,2),int2str(i), 'Color','b','FontSize','18');
    nextind = peaks_matched{1},(i,4);
    if nextind > 0;
    text(im_info{2}(nextind,1),im_info{2}(nextind,2),int2str(i), 'Color','r*', 'FontSize','18');
    end
end

% Inclass16

%The folder in this repository contains code implementing a Tracking
%algorithm to match cells (or anything else) between successive frames. 
% It is an implemenation of the algorithm described in this paper: 
%
% Sbalzarini IF, Koumoutsakos P (2005) Feature point tracking and trajectory analysis 
% for video imaging in cell biology. J Struct Biol 151:182?195.
%
%The main function for the code is called MatchFrames.m and it takes three
%arguments: 
% 1. A cell array of data called peaks. Each entry of peaks is data for a
% different time point. Each row in this data should be a different object
% (i.e. a cell) and the columns should be x-coordinate, y-coordinate,
% object area, tracking index, fluorescence intensities (could be multiple
% columns). The tracking index can be initialized to -1 in every row. It will
% be filled in by MatchFrames so that its value gives the row where the
% data on the same cell can be found in the next frame. 
%2. a frame number (frame). The function will fill in the 4th column of the
% array in peaks{frame-1} with the row number of the corresponding cell in
% peaks{frame} as described above.
%3. A single parameter for the matching (L). In the current implementation of the algorithm, 
% the meaning of this parameter is that objects further than L pixels apart will never be matched. 

% Continue working with the nfkb movie you worked with in hw4. 

% Part 1. Use the first 2 frames of the movie. Segment them any way you
% like and fill the peaks cell array as described above so that each of the two cells 
% has 6 column matrix with x,y,area,-1,chan1 intensity, chan 2 intensity

% Part 2. Run match frames on this peaks array. ensure that it has filled
% the entries in peaks as described above. 

% Part 3. Display the image from the second frame. For each cell that was
% matched, plot its position in frame 2 with a blue square, its position in
% frame 1 with a red star, and connect these two with a green line. 

