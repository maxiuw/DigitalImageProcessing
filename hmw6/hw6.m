close all;
clear;
A = double(imread('HW6.jpg'));
figure
imshow(uint8(A))
% A = rgb2gray(A);
% taking log of A to be able to separate reflection and ilumination
s = size(A);
% log so we dont reach inf
B = log((A+1));

P = s(1)*2;
Q = s(2)*2;

% creating padding for the image by fftshit(img,dims)
% fourier transformation 
FFT = fftshift(fft2(B,2*s(1),2*s(2))); % e.g.  -3.3665e+05 + 7.3109e+04i
% fft withoug to 
FFT2 = fftshift(fft2(A,2*s(1),2*s(2)));
magnitude = 20*log10(abs(FFT));
figure 
imshow(uint8(magnitude))
s1 = size(FFT);
c = 1;
D0 = 40 ;
gammal = 1;
gammah = 4;
H = zeros(s(1),s(2));
n = 2;
for i = 1:s1(1)
    for j = 1:s1(2)
        radius = sqrt((i - (s1(1)/2)-1)^2 + (j - (s1(2)/2)-1)^2);
        
        H(i,j) = (gammah-gammal)*(1 - exp(-c*(radius^2/D0^2)))+gammal;
%         filter_2(i,j) = max(0.5,1/(1+(D0/radius)^(2*n)));
        
    end
end

% filtering
S = fftshift(FFT.*H);
% inv fourier
S = real(ifft2(S));
S = S(1:s(1),1:s(2));

% filtering without exp and without log (FFT2 instead of FFT
filter_2 = fftshift(FFT2.*H);
filter_2 = real(ifft2(filter_2));
filter_2 = filter_2(1:s(1),1:s(2));
% subtracting 1 which we added at the beginning to make sure our log is not
% goint to the inf 

g = exp(S-1);

% results 
k=1;

figure
subplot(121)
imshow(uint8(g))
subplot(122)
imshow(uint8(filter_2))

imwrite(uint8(g),'homomorphic_fiplter.png');

imwrite(uint8(filter_2),'no_exp_no_ln.png');

