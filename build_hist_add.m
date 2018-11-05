function [ hist_norm ] = build_hist_add( im )
%Return normalized 2D histogram of input image im
%For new frame image - give it to retrain the hist_bag
%% LOAD NEW IMAGE, EXTRACT IT'S COLORSPACES FOR NEW FRAME

im_roi = im;
[nrows ncols] = size(im_roi(:,:,1));

% extract R, G from cropped training image:
im_roi_r = im_roi(:,:,1);
im_roi_g = im_roi(:,:,2);

% extract H, S from cropped training image:
im_roi_hsv = rgb2hsv(im_roi);
imtest_seg_hs = im_roi_hsv;  %to extract hsv channels [from segmentskin.m]
im_roi_h = im_roi_hsv(:,:,1);
im_roi_s = im_roi_hsv(:,:,2);

% extract N-R, N-G from cropped training image:
im_roi_b = im_roi(:,:,3);
im_roi_nr = im_roi_r./(im_roi_r+im_roi_g+im_roi_b);
im_roi_ng = im_roi_g./(im_roi_r+im_roi_g+im_roi_b);

%% CREATE 2D NORMALIZED HISTOGRAM (currently in H-S space)

% R-G histogram:
% Hrg = zeros(256,256);
% for i = 1:nrows
%     for j = 1:ncols
%         r = im_roi_r(i,j);
%         g = im_roi_g(i,j);
%        
%         Hrg(r,g) = Hrg(r,g)+1;
%     end
% end
% Hrg_norm = Hrg./sum(Hrg(:));

% H-S histogram:

Hhs = zeros(1000,1000);
for i = 1:nrows
    for j = 1:ncols
        h = im_roi_h(i,j);
        s = im_roi_s(i,j);
        if imtest_seg_hs(i,j,:) > 0   % from segmentskin.m - filter all zero'ed pixels
            if (((round(h*1000)+1)<1001) && ((round(s*1000)+1)<1001))
                %save in Hhs(x,y) positioned bin belonging to x,y value of h,s of
                %pixel. If h->x ,s->y then +1 in histogram bin
                %hence the +1 at end (and the +1 in elements is to prevent writing on 0,0 address of Hhs matrix)
                Hhs(round(h*1000)+1, round(s*1000)+1) = Hhs(round(h*1000)+1, round(s*1000)+1)+1;
            else
                Hhs(1000, 1000) = Hhs(1000,1000)+1;
            end
        end    
     end
end
Hhs_norm = Hhs./sum(Hhs(:));

% NR-NG histogram:
% Hnrng = zeros(1000,1000);
% for i = 1:nrows
%     for j = 1:ncols
%         nr = round(im_roi_nr(i,j)*1000);
%         ng = round(im_roi_ng(i,j)*1000);
%             
%         Hnrng(round(nr*1000)+1, round(ng*1000)+1) = Hnrng(round(nr*1000)+1, round(ng*1000)+1)+1;
%     end
% end
% Hnrng_norm = Hnrng./sum(Hnrng(:));

%% RETURN OUTPUT
hist_norm = Hhs_norm;
end



