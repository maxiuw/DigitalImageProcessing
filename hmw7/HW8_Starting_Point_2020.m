clear;
close all
%% Reading Image
A = imread('noised_image2.jpg');
figure
imshow(A);
title('Corrupted Image');
mag=fftshift(abs(fft2(double(A))));
S=size(mag);
    
figure
image(uint8(20*log10(mag)));
colormap(gray(256));
title('Spectrum of Corrupted Image');

%% By try and error,we can identify the center point of interference and design the notch filter
%% You will be much better off to write a subroutine for notch filter

notch_filter=ones(size(mag));    
D=36;
for k1=1:S(1)
    for k2=1:S(2)
        notch_filter_1(k1,k2)=1/(1+D/((k1-47)^2+(k2-231)^2))*1/(1+D/((k1-137)^2+(k2-202)^2))*1/(1+D/((k1-147)^2+(k2-222)^2))*1/(1+D/((k1-200)^2+(k2-152)^2));
        notch_filter_2(k1,k2)=1/(1+D/((k1-S(1)+47)^2+(k2-S(2)+231)^2))*1/(1+D/((k1-S(1)+137)^2+(k2-S(2)+202)^2))*1/(1+D/((k1-S(1)+147)^2+(k2-S(2)+222)^2))*1/(1+D/((k1-S(1)+200)^2+(k2-S(2)+152)^2));
        notch_filter(k1,k2)=notch_filter_1(k1,k2)*notch_filter_2(k1,k2);
    end
end

figure
image(uint8(20*log10(mag.*notch_filter)));
colormap(gray(256));
title('Spectrum of Filtered Image');
comp_A=real(ifft2(fft2(double(A)).*fftshift(notch_filter)));
figure
imshow(uint8(comp_A))
title('Notch Filter Output');

%% Based on notch filter, we can design notch pass filter
notch_pass=1-notch_filter;
interference_A=real(ifft2(fft2(double(A)).*fftshift(notch_pass)));
figure
imshow(uint8(interference_A))
title('Interference');
M=11;
d_A=double(A);
w=ones(size(A));
for k1=1:floor(S(1)/M)
    for k2=1:floor(S(2)/M)
        win_img=d_A((k1-1)*M+(1:M),(k2-1)*M+(1:M));
        win_int=interference_A((k1-1)*M+(1:M),(k2-1)*M+(1:M));
        temp=win_img.*win_int;
        ave_1=mean(temp(:));
        ave_2=mean(win_img(:))*mean(win_int(:));
        ave_3=mean(win_int(:).^2);
        ave_4=mean(win_int(:))^2;
        w((k1-1)*M+(1:M),(k2-1)*M+(1:M))=max(min(1,(ave_1-ave_2)/(ave_3-ave_4)),0);  
        % you might try to remove the minimum command to see what happens 
    end
end
comp_A2=d_A-w.*interference_A;        
figure
imshow(uint8(comp_A2))
title('Optimum Notch Filter');





