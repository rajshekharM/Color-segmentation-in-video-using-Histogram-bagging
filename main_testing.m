%% TESTING
function imtest_skin=main_testing(imtest,hist_avg)

 
  %  imtest = imread('testing images\25.jpg');
    imtest_skin = segmentskin(imtest, hist_avg);
   % imwrite(imtest_skin,'segmented images\output0.jpg');
    %figure();
    %imshow(imtest_skin);

end