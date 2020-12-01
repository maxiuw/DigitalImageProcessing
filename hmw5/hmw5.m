clear;
close all;
img = imread('einstein-low-contrast.tif');
% img = rgb2gray(img);
% img size needed for padding 
size_img = size(img);
P = size_img(1)*2;
Q = size_img(2)*2;
% creating padding for the image
pad = zeros(P,Q);
% fusing padding with image 
padded = double(rgb2gray(imfuse(img,pad)));
% centering transform
for i = 1:P
    for j = 1:Q
        padded(i,j) = padded(i,j) *((-1)^(i+1+j+1));       
    end
end


% apply Fourier transformation
final = fft2(padded);
magnitude = 20*log10(abs(final));
figure 
subplot(121)
imshow(uint8(magnitude))
title('mag dB');
subplot(122)
phase = angle(final)/pi*180;
imshow(uint8(phase))
title('phase');
sizef = size(final);


% building filter 
D0 = 45;
ord = 30;
c0 = 1;
filter_1 = zeros(sizef);
filter_2 = zeros(sizef);
filter_3 = zeros(sizef);
filter_4 = zeros(sizef);
filter_5 = zeros(sizef);


for i = 1:sizef(1)
    for j = 1:sizef(2)
       
        radius = sqrt((i - (sizef(1)/2)-1)^2 + (j - (sizef(2)/2)-1)^2);
        
        %%% ideal filter 
        
        if radius < D0
            filter_1(i,j) = 1;          
        end
        
        %%% gaussian hpass
        
        filter_2(i,j) = exp(-1*(radius^2)/(2*D0^2));
        
        %%% butterworth hpass
        filter_3(i,j) = 1/(1+(radius/D0)^(2*ord));
        
        %%% gaussian lowpass
        
        filter_4(i,j) = 1-filter_2(i,j);
        
        %%% butterworth lowpass
        filter_5(i,j) = 1/(1+(D0/radius)^(2*ord));
        
        
        
    end
end

% performing inverse ifft after filtering to retrive the image

output1 = final.*filter_1;
output2 = final.*filter_2;
output3 = final.*filter_3;
output4 = final.*filter_4;
output5 = final.*filter_5;


% ifft
D1 = real(ifft2(output1));
D2 = real(ifft2(output2));
D3 = real(ifft2(output3));
D4 = real(ifft2(output4));
D5 = real(ifft2(output5));


% multiply by (-1) ^(x+y) 

for i = 1:sizef(1)
    for j = 1:sizef(2)
        D1(i,j) = D1(i,j) * (-1) ^ (i-1 + j - 1);
        D2(i,j) = D2(i,j) * (-1) ^ (i-1 + j - 1);
        D3(i,j) = D3(i,j) * (-1) ^ (i-1 + j - 1);
        D4(i,j) = D4(i,j) * (-1) ^ (i-1 + j - 1);  
        D5(i,j) = D5(i,j) * (-1) ^ (i-1 + j - 1);     
        
    end
end

% removing padding 
D1 = D1(1:size_img(1),1:size_img(2));
D2 = D2(1:size_img(1),1:size_img(2));
D3 = D3(1:size_img(1),1:size_img(2));
D4 = D4(1:size_img(1),1:size_img(2));
D5 = D5(1:size_img(1),1:size_img(2));


% USM 
k = 1;
filtered_ideal = double(img) +k*(double(img)-D1);
filtered_gaussian_h = double(img)  + k*(double(img)+D2);
filtered_bt_h = double(img) + k*(double(img)+D3);
filtered_gaussian_l = double(img) +k*(double(img)-D4);
filtered_bt_l = double(img) +k*(double(img)-D5);

figure 
subplot(331)
imshow(uint8(filtered_ideal))

title('Ideal filter')
subplot(332)
imshow(uint8(filtered_gaussian_h))
title('gaussian filter high')
subplot(333)
imshow(uint8(filtered_bt_h))
title('butterworth filter high')
subplot(334)
imshow(uint8(filtered_gaussian_l))
title('gaussian filter low')
subplot(335)
imshow(uint8(filtered_bt_l))
title('butterworth filter low')
subplot(336)
imshow(uint8(img))
title('org')
subplot(337)
imshow((filter_2))
title('gausian h')
subplot(338)
imshow((filter_3))
title('bt h')
subplot(339)
imshow((filter_5))
title('bt l')

% writing img to a file 

imwrite(uint8(filtered_ideal),'Ideal_filter_output.png');
imwrite(uint8(filtered_gaussian_h),'gaussian_high_output.png');
imwrite(uint8(filtered_bt_h),'butterworth_high_output.png');
imwrite(uint8(filtered_gaussian_l),'gaussian_low_output.png');
imwrite(uint8(filtered_bt_l),'butterworth_low_output.png');
imwrite(filter_2,'gaussian_high_filter.png');
imwrite(filter_3,'butterworth_high_filter.png');
imwrite(filter_4,'gaussian_l_filter.png');
imwrite(filter_5,'butterworth_l_filter.png');
imwrite(uint8(magnitude),'magnitude (dB).png');
imwrite(uint8(phase),'phase (dB).png');

























