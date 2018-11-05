clc;
clear all;
outputVideo = VideoWriter('Op-29Oct-Histogram\v_o_test_2.avi');
v = VideoReader('tes_video_4Oct.mp4');

%% 
%Step - Call main training function to return hist avg [Only once]
       hist_bag = [];
       f1 = read(v,1);  % give 1st frame of video to train hist_bag
       [hist_bag, hist_avg] = main_training(hist_bag,f1);
       
       hist_avg

%% 


fps=30;
numFrames = v.NumberOfFrames;
disp(numFrames)

display(['Total frames: ' num2str(numFrames)]);
Resize='on';

y = zeros(1, numFrames);


% sum only those pixel values which have non-zero intensity values 

for i=1:numFrames,
 frame = read(v, i);
      
        %%BEGIN IMAGE READING - fullImageFileName
        % Read in image into an array.
        i                                                      %display i 
        rgbImage = frame; 
       
        imageHsv = rgb2hsv(rgbImage);
        % Extract out the color bands from the original image
        % into 3 separate 2D arrays, one for each color component.
        %LChannel = lab_Image(:, :, 1); 
        %aChannel = lab_Image(:, :, 2); 
        %bChannel = lab_Image(:, :, 3); 
        
        HChannel = imageHsv(:, :, 1);
        SChannel = imageHsv(:, :, 2);
        VChannel = imageHsv(:, :, 3);
        
    if i==1 
        % Display the HSV images.
        figure;
        subplot(2, 4, 1);
        imshow(rgbImage);
        subplot(2, 4, 2);
        imshow(HChannel, []);
        title('H Channel');
        subplot(2, 4, 3);
        imshow(SChannel, []);
        title('S Channel');
        subplot(2, 4, 4);
        imshow(VChannel, []);
        title('V Channel');
    end
 %Step -  Get threshold from user maybe
        
 %Step -  Call main testing part on video frame to return seg image
        imtest_skin=main_testing(rgbImage,hist_avg);
        
        if i==1
            subplot(2, 4, 5);
            imshow(imtest_skin, []);
            title('Segmented Img');
        end
        
        %dilate image to form mask
        SE = strel('disk', 15); %create disk type struct element
        imclose_skin=imclose(imtest_skin,SE);
        
        if i==1
            subplot(2, 4, 7);
            imshow(imclose_skin, []);
            title('Segmented & Closed Img');
        end    
%         
         if(mod(i,fps/2)==0)   %every 0.5 seconds, update histogram to adapt        
             [hist_bag, hist_avg]= main_training_add(imtest_skin,hist_bag);
         end
%       
        imclose_skin_rgb = hsv2rgb(im2double(imclose_skin));
        imclose_skin_gray = rgb2gray(imclose_skin_rgb);    
        mask=imbinarize(imclose_skin_gray,'adaptive');
        output_frame = bsxfun(@times, rgbImage, cast(mask, class(rgbImage)));
        
        if i==1
            subplot(2, 4, 8);
            imshow(mask, []);
            title('Mask Obtained');
            subplot(2, 4, 6);
            imshow(output_frame, []);
            title('Output Img');
        end 
        %Write each Image to video for output video of matching color
        %regions
        open(outputVideo);
 %      seg_img = imclose_skin;
        seg_img = imtest_skin;   %take this , pure pixels
        writeVideo(outputVideo,output_frame);

        % Consider various channels for mean img value for final y
        seg_img=im2double(seg_img);
        rgb_seg_img=hsv2rgb(seg_img);
           
       
       hueImage = seg_img(:,:, 1);        %Extract only Hue channel
       meanHueImg = mean2(hueImage);
       
       %should consider only non-zero pixels
       ch=2;  
       meanGreenImg = mean_value(seg_img,ch);    %img shud be hsv, ch=2 for Green channel
       
       satImage = seg_img(:,:, 2);        %Extract only Sat channel
       meanSatImg = mean2(satImage);
       
       greenImage = rgb_seg_img(:,:,2);     %Extract only Green channel
   %   meanGreenImg = mean2(greenImage);
       
       if i==1                              %Plot the channel image
            subplot(2, 4, 6);
            imshow(greenImage, []);
            title('Segmented Green channel Img');
       end
       
       
       
%y(i)=meanGreenImg;
 y(i)=meanHueImg;
 y_s(i)=meanSatImg;
 y_g(i)=meanGreenImg;
 
end

%% Show Output

 close(outputVideo);
 figure();
 plot(y);
 y;
 

%% FFT
L=numFrames;
Fs=fps;

Y = fft(y); %i/p signal
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1); %double sided
figure;
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of S(t)')
xlabel('f (Hz)')

% ---------- End of main function ---------------------------------

