%getting H(u,v)
% guess a and b T=1, 0<a<0.2, and 0<b<0.2.


close all;
clear;

B = double(imread('HW8.jpg'));
fourier = fftshift(fft2(B));
[N,M]=size(B);

center=[N,M]/2;


mag=fftshift(abs(fft2(double(B))));
S=size(mag);
    
figure
image(uint8(20*log10(mag)));
colormap(gray(256));
title('Spectrum of Corrupted Image');


T = 1;
a = 0.01;
b = 0.01;

H = zeros(N,M);
output = zeros(N,M);
noise_var = 500;

for k1=1:N
for k2=1:M
    arg=pi*((k1-center(1)-1)*a+(k2-center(2)-1)*b)+eps;
    H(k1,k2)=(T/(arg))*sin(arg)*exp(-1j*arg);
    output(k1,k2) = fourier(k1,k2)+ 1/H(k1,k2);
end

end
output = real(ifft2(output));

filter_2 = fftshift(fourier.*H);
filter_2 = real(ifft2(filter_2));

figure
imshow(uint8(output ))















