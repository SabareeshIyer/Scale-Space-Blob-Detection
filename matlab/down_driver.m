tic
clear all
img = imread('F:\\UB CSE\\CSE 573 CVIP\\HWs\\hw2\\data\\beatles.jpg');
img = (im2double(rgb2gray(img)));
r2 = sqrt(2);

sigma = 3.95;
threshold_val = 2.01;
space_size = 5;
scale = 2;

k = ceil(2*(3*sigma + 1));
[h, w] = size(img);     index = 1;
cx = [];    cy = [];    rad = [];   max_array = [];

scale_space = zeros(h,w,space_size);    suppressed_img = zeros(h,w,space_size);
up_img = zeros(h,w,space_size);

filter = fspecial ('log',k, sigma);    
filter = filter * sigma * sigma;    

%creating scale space
for i = 1:space_size
   down_img = imresize(img, 1/scale);
   filtered_img = imfilter(down_img, filter, 'replicate');
   A = imresize(filtered_img, [h w]);
   A = A  * sigma * sigma;
   %A = A.^2;
   up_img(:,:,i) = A;
   
   scale_space(:,:,i) = up_img(:,:,i);
   scale = scale*2;
end


%performing non-maxima suppression and applying threshold)
for i = 1:space_size
    
    %{
    suppressed_img(:,:,i) = ordfilt2(scale_space(:,:,i),9, ones(3,3));    
    suppressed_img(:,:,i) = suppressed_img(:,:,i).*(suppressed_img(:,:,i) == scale_space(:,:,i) );
    threshold_img(:,:,i) = suppressed_img(:,:,i).*(suppressed_img(:,:,i) > threshold_val);
    %}
    
    threshold_img(:,:,i) = scale_space(:,:,i).*(scale_space(:,:,i) > threshold_val);
    suppressed_img(:,:,i) = ordfilt2(threshold_img(:,:,i),9, ones(3,3)); 
    suppressed_img(:,:,i) = suppressed_img(:,:,i).*(suppressed_img(:,:,i) == threshold_img(:,:,i) );
    threshold_img(:,:,i) = suppressed_img(:,:,i);
    
    
    %figure, imshow(suppressed_img(:,:,i));     
    %figure, imshow(threshold_img(:,:,i))
end


%cleaning up threshold matrix

for p =1:space_size
    for i = 1:h-1
        for j = 1:w-1
            if(threshold_img(i,j,p) ~= 0)
                if(threshold_img(i,j,p) > 0 && threshold_img(i+1,j,p) > 0)
                    threshold_img(i,j,p) = 0;
                end
                if(threshold_img(i,j,p) ~= 0)
                    if(threshold_img(i,j,p) > 0 && threshold_img(i,j+1,p) > 0)
                        threshold_img(i,j,p) = 0;
                    end
                end            
            end
        end
    end
end



%removing circles close to each other in each subsize by subsize grid

subsize = 20;
for p=1:space_size
    A = threshold_img(:,:,p);
    i = 1; j = 1;
    while i < h-subsize
        while j < w-subsize
            x = max(max(A(i:i+subsize-1, j:j+subsize-1)));
            A(i:i+subsize-1, j:j+subsize-1) = zeros(subsize, subsize);
            A((i+(subsize/2)), (j+(subsize/2))) = x;
            j = j + subsize;
        end
        i = i + subsize;
    end
    threshold_img(:,:,p) = A;
    %figure, imshow(threshold_img(:,:,p))
end


%maximum across scale space for each value in thresholds
for p=1:space_size
    for i = 1:h
        for j = 1:w
            max_num = 0;
            for y = 1:space_size
                max_array(y) = threshold_img(i,j,y);
                if(max_array(y) > max_num)
                    max_num = max_array(y);
                    max_idx = y;
                end
            end            
            if(max_num  ~= 0)
                cx(index) = i;
                cy(index) = j;
                rad(index) = (sigma * 2^max_idx) * 2;
                index = index + 1;
            end            
        end
    end
end

cx = cx';
cy = cy';
rad = rad';
size(cx)
%show_all_circles(img, cy, cx, rad );

toc