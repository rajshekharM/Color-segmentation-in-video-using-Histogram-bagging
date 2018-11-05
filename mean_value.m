function mean_v=mean_value(img,ch)
rgb_img=hsv2rgb(img);
count=0;
sum_v=0.0;
[nrows ncols] = size(rgb_img(:,:,ch));  
g_img=rgb_img(:,:,ch);                       %Extract only (Green) channel

    for i = 1:nrows
        for j = 1:ncols
            if g_img(i,j,:) > 0
                sum_v=sum_v+g_img(i,j);
                count=count+1;
            end
        end
    end

if count > 0
        mean_v=sum_v/count;   %avg of non zero green ch pixels
end
end