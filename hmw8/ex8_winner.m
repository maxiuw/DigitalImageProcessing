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

% we do not know the ratio of noise to power so we hae to guess it 
% guessing all the parameters necessary for the filters a,b are between 0
% and 0.3, k is the ratio of noise and power signal, eta is the threshold,
% p is a laplacian kernel, we use it but in order to keep it in the same
% shape as the image we have to transform it with the proper size 
T = 1;
% a1 = 0.01:0.01:0.1;
% b1 = 0.01:0.01:0.1;
gamma = 0.004;
k = 0.004;
eta = 0.1;

% loop
    H = zeros(N,M);
    filter_part= zeros(N,M);


    p = [0 -1 0; -1 4 -1; 0 -1 0];
    ft =fftshift(fft2(p,N,M));


% looping over different settings 
% after performing for loop it seem that a = 0.08 and b=0.04 work the best 
% for a = 1:length(a1)
%     for b = 1:length(b1)
a = 0.08;
b= 0.04;
        for k1=1:N
        for k2=1:M
            % calculating distortion 
            arg=pi*((k1-center(1)-1)*a+(k2-center(2)-1)*b)+eps;
            H(k1,k2)=(T/(arg))*sin(arg)*exp(-1j*arg);

            % partial inverse 
            if abs(H(k1,2)) < eta
                filter_part(k1,k2) = 0;
            else
                filter_part(k1,k2)=1/H(k1,k2);
            end

        end

        end
        % % wiener 
        filter_win = (conj(H))./ ((abs(H).^2)+k);
        % % inverse
        filter_inv = conj(H)./(abs(H).^2);
        % % geometric mean
        filter_geomean = (filter_inv.^(1/2)) .* (filter_win.^(1/2));
        % % Constrained Least Squares Filtering
        filter_lsf = (conj(H))./((H.^2)+(gamma).*ft.^2);
        % 
        % 
        % % filtering

        output_win = fftshift(fourier.*filter_win);
        output_win = real(ifft2(fftshift(output_win)));

        output_inv = fftshift(fourier.*filter_inv);
        output_inv = real(ifft2(fftshift(output_inv)));

        output_geomean = fftshift(fourier.*filter_geomean);
        output_geomean = real(ifft2(fftshift(output_geomean)));

        output_lsf = fftshift(fourier.*filter_lsf);
        output_lsf = real(ifft2(fftshift(output_lsf)));

        output_part= fftshift(fourier.*filter_part);
        output_part = real(ifft2(fftshift(output_part)));


        % plotting
%         titl = sprintf('a: %d  b:%d   ', a1(a),b1(b));

        figure
        subplot(231)
        imshow(uint8((output_win)))
        title('output win');
        subplot(232)
        imshow(uint8((output_inv)))
        title('output inv');
        subplot(233)

        imshow(uint8((output_geomean)))
        title('output geomean');
        subplot(234)

        imshow(uint8((output_lsf)))
        title('output lsf');
        subplot(235)

        imshow(uint8((output_part)))
        title('output part');
%         suptitle(titl)
%     end
% end

imwrite(uint8((output_win)),'wiener.png');
imwrite(uint8((output_inv)),'invert.png');
imwrite(uint8((output_geomean)),'geomean.png');
imwrite(uint8((output_lsf)),'lsf.png');
imwrite(uint8((output_part)),'part_inv.png');



