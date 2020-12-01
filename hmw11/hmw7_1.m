clear;
close all;
img = imread('HW7_Problem1.jpg');

img = double(img);

%Define size of the window
M = 5;
N = 5;
padded = padarray(img,[floor(M/2),floor(N/2)]);
% imshow(uint8(padded))

lvar = zeros([size(img,1) size(img,2)]);
lmean = zeros([size(img,1) size(img,2)]);
temp = zeros([size(img,1) size(img,2)]);

for i = 1:size(padded,1)-(M-1)
    for j = 1:size(padded,2)-(N-1)
        
        
        temp = padded(i:i+(M-1),j:j+(N-1));
        tmp =  temp(:);
        %Find the local mean and local variance for the local region        
        lmean(i,j) = mean(tmp);
        lvar(i,j) = mean(tmp.^2)-mean(tmp).^2;
        
    end
end

% noise variance = 2500 does not influence the image, value is too small
% using the equation below, I estimated noise variance to be around 3800
noise_var = sum(lvar(:))/(size(img,1)*size(img,2));

%If noise_variance > local_variance then local_variance=noise_variance

lvar = max(lvar,noise_var); 

%Final_Image = img - (noise variance/local variance)*(img-local_mean);
 NewImg = noise_var./lvar;
 NewImg = NewImg.*(img-lmean);
 NewImg = img-NewImg;

% average filter 
f = ones(7)/49;
avg_f = filter2(f,img);

%Convert the image to uint8 format.

figure()
imshow(uint8(NewImg));
title('Adaptive Local filter');
imwrite(uint8(NewImg),'Adaptive Local filter.png');
figure()
imshow(uint8(img));
figure()
imshow(uint8(avg_f));
title('avg filter ');
imwrite(uint8(avg_f),'avg filter.png');


















