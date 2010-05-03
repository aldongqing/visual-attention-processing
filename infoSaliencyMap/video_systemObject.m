%% Developing Phase Shifting Transform in System Object
% This simulation is done to show the effectiveness of PFT on lane-mark
% detection and extraction in a video sequence

%   Copyright 2010, The University of Nottingham

%% Initialization
% Use these next sections of code to initialize the required variables and
% System objects.
clc;
clear;

%% 
% Create a System object to read video from a video.
hbfr = video.MultimediaFileReader( ...
        'Filename','D:\PhD Research\UNMC_Autovision_DB\Lane\videoL_001.mpg' ... 
        ,'PlayCount',1 ...
        ,'VideoOutputPort',1 ...
        ,'ImageColorSpace','RGB' ...
        );
    
%% 
% Create a System object to save video to file
hmfw1 = video.MultimediaFileWriter( ...
        'Filename','D:\PhD Research\UNMC_Autovision_DB\Lane\video_sample.avi' ...
        ,'FileFormat','AVI' ...
        ,'AudioInputPort',false ...
        ,'VideoInputPort',true ...
        ,'VideoCompressor','MJPEG Compressor');
hmfw2 = video.MultimediaFileWriter( ...
    'Filename','D:\PhD Research\UNMC_Autovision_DB\Lane\video_tsm.avi' ...
    ,'FileFormat','AVI' ...
    ,'AudioInputPort',false ...
    ,'VideoInputPort',true ...
    ,'VideoCompressor','MJPEG Compressor');
hmfw3 = video.MultimediaFileWriter( ...
    'Filename','D:\PhD Research\UNMC_Autovision_DB\Lane\video_ssm.avi' ...
    ,'FileFormat','AVI' ...
    ,'AudioInputPort',false ...
    ,'VideoInputPort',true ...
    ,'VideoCompressor','MJPEG Compressor');
hmfw4 = video.MultimediaFileWriter( ...
    'Filename','D:\PhD Research\UNMC_Autovision_DB\Lane\video_ism.avi' ...
    ,'FileFormat','AVI' ...
    ,'AudioInputPort',false ...
    ,'VideoInputPort',true ...
    ,'VideoCompressor','MJPEG Compressor');
%%
% Create color space converter System objects to convert the image from
% YCbCr to RGB format and from RGB to intensity format.
hcsc1 = video.ColorSpaceConverter('Conversion', 'RGB to intensity');

%%
% Create a morphological erosion System object to thin out portions of the
% road and objects other than cars which are also produced as a result of
% segmentation.
herode = video.MorphologicalErode('Neighborhood', strel('square',3));

%%
% Create an alphablend system object to represent the output of lane-mark
% extraction
halphablend = video.AlphaBlender('Operation','Blend','Opacity',0.25);


% Initialize some variables used in plotting motion vectors.
M = 5;
hbfi = info(hbfr);
iFrame = 0;
frame_scale_ratio = 0.25;
frame_size = fliplr(hbfi.VideoSize)*frame_scale_ratio;

%% Put M-1 frames into FIFO sequences in the order from 2 to M
queue = zeros([frame_size M]);
% for iImg = 2:1:M            
% %     aFrame = step(hbfr);
% %     aFrame = step(hcsc1,aFrame);
% %     aFrame = imresize(aFrame,frame_scale_ratio,'bilinear');    
% %     queue(:,:,iImg) = aFrame;
%     ~isDone(hbfr);
%     queue(:,:,iImg) = imresize(step(hcsc1,step(hbfr)),frame_scale_ratio,'bilinear');
% end

%%
% Create System objects to display the original video, motion vector video,
% the thresholded video and the results.
hvideo1 = video.VideoPlayer('WindowCaption', 'Original Video');
hvideo1.WindowPosition(1) = round(0.5*hvideo1.WindowPosition(1)) ;
hvideo1.WindowPosition(2) = round(0.5*(hvideo1.WindowPosition(2))) ;
hvideo1.WindowPosition([4 3]) = frame_size;

hvideo2 = video.VideoPlayer('WindowCaption', 'Temporal Saliency Map');
hvideo2.WindowPosition(1) = hvideo1.WindowPosition(1) + 350;
hvideo2.WindowPosition(2) =round(1.5* hvideo2.WindowPosition(2));
hvideo2.WindowPosition([4 3]) = frame_size;

hvideo3 = video.VideoPlayer('WindowCaption', 'Spatial Saliency Map');
hvideo3.WindowPosition(1) = hvideo2.WindowPosition(1) + 350;
hvideo3.WindowPosition(2) = round(1.5*(hvideo3.WindowPosition(2))) ;
hvideo3.WindowPosition([4 3]) = frame_size;

hvideo4 = video.VideoPlayer('WindowCaption', 'Information Saliency Map');
hvideo4.WindowPosition(1) = hvideo1.WindowPosition(1);
hvideo4.WindowPosition(2) = round(0.3*(hvideo4.WindowPosition(2))) ;
hvideo4.WindowPosition([4 3]) = frame_size;


%% Stream processing loop
% Create the processing loop to track objects in the input video. This
% loop uses the System objects previously instantiated.
%
% The loop is stopped when you reach the end of the input file, which is
% detected by the BinaryFileReader System object.

%% Process stream of videos
while ~isDone(hbfr)    
    queue = circshift(queue,[0 0 -1]); % Rotate the queue to get new input value
    queue(:,:,M) = imresize(step(hcsc1,step(hbfr)),frame_scale_ratio,'bilinear');        % Convert color image to intensity and scale it 1/4
    iFrame = iFrame + 1;    
    if ( sum(sum(queue(:,:,1))) ~= 0 ) 
        % Detecting lane-mark by saliency method
        [tsm,ssm,ism] = infoSaliencyMap(queue);       

        %% Result Presentation in Grayscale or Color
    %     lmrgb = cat(3,lm,lm,lm) .* imrgb_org;
    %     lmgray = lm .* imgray_org;
    %     imb = step(halphablend,lmgray,imgray_org);
    %     step(hvideo1, imrgb_org);        % Display Original Video
    %     step(hvideo2, lmgray);       % Display Results Video in Grayscale
    %     step(hvideo3, lmrgb);
        step(hvideo1,queue(:,:,M));    
        step(hvideo2,tsm);    
        step(hvideo3,ssm);    
        step(hvideo4,ism);    
        step(hmfw1,queue(:,:,M));
        step(hmfw2,tsm);
        step(hmfw3,ssm);
        step(hmfw4,ism);
    end
    if (iFrame >= 90) 
        break; 
    end    
end

%% Close
% Here you call the close method on the System objects to close any open
% files and devices.
close(hbfr);
close(hmfw1);
close(hmfw2);
close(hmfw3);
close(hmfw4);
%% Summary
% The output video shows the cars which were tracked by drawing boxes
% around them. The video also displays the number of cars being tracked.


displayEndOfDemoMessage(mfilename)