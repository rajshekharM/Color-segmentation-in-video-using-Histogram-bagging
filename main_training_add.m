function [hist_bag, hist_avg]= main_training_add(img,hist_bag)
%% TRAINING
% matchingColors = bsxfun(@times, rgbImage, cast(binaryImage, class(rgbImage)));
%im_new = bsxfun(@times,img,cast(mask,class(img)));
hist_new = build_hist_add(img);
hist_bag = cat(3, hist_bag, hist_new);

% Average of all normalized histograms:
hist_avg = mean(hist_bag, 3);

end
