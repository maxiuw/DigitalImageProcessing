% problems are divided into section so you can run each section which will
% correspond to each point of the hwm

clear;
close all

A = imread('einstein-low-contrast.tif');
figure()

imshow(A)
shapeA = size(A);
% calculating global values of mean and std
global_mean = sum(A(:))/(shapeA(1)*shapeA(2));
global_diff = (A -global_mean).^2;
global_std = sum(global_diff(:))/(shapeA(1)*shapeA(2));
% 1 - using histogram statistics 
B_hist = zeros(shapeA(1),shapeA(2));

% comparison coefficients 
k0 = 1; 
k1 = 2;
k2 = k0;
k3 = k1;
for i=1:shapeA(1)
    for j=1:shapeA(2)
       neighbor = [];
       for k = i-1:i+1
           for l = j-1:j+1
               % checking if neighbors coordinates are not out of bounds
               % i.e. taking cornerts and regions near the boundries under
               % account 
               if (k<=0) || (l<=0) || (k>shapeA(1)) || (l>shapeA(2))
                   continue;
               else
                   neighbor = [neighbor A(k,l)]; % this works as append 
               end
               
           end
       end
    shapeN = size(neighbor);   
    %loc mean value
    loc_mean = sum(neighbor)/shapeN(2);
    % creating array of mean values so we can find the difference between
    % px value and mean value
    mean_array = ones(shapeN(1),shapeN(2)) * loc_mean;
    % standard deviation
    loc_std = sum((double(neighbor) - mean_array).^2)/shapeN(2);
    C = 1.2;
    
    % comparing and deciding wheather to modify the val or not 
    if (k0* global_mean <= loc_mean) && (loc_mean <= k1*global_mean) && (k2*global_std <= loc_std) && (loc_std <= k3*global_std)
        new_value = C*A(i,j);
%         making sure the value is not out of bounds 
        if new_value > 255
            new_value = 255;
        end
        
        B_hist(i,j) = new_value;
    else
        B_hist(i,j) = A(i,j);
    end
     
    end

    
end
figure()
imshow(uint8(B_hist))

%%
% fuzzy logic enhancement
% functions are in seperate files for better organization, they are called
% Udark, Ugray and Ubright
clear all;
close all

A = imread('einstein-low-contrast.tif');
figure()

imshow(A)
shapeA = size(A);
B_fuzz = zeros(shapeA(1),shapeA(2));

dark = 0;
gray = 127;
bright = 255;


for i=1:shapeA(1)
    for j=1:shapeA(2)
        
        % very important! without it it gives really wrong results 
        a = double(A(i,j));
        
        % function for changing the value, in this case v is the final
        % valeu
        v = (Udark(a)*(dark) +Ugray(a)*gray + Ubright(a)*bright)/(Udark(a)+Ugray(a)+Ubright(a));
        
        B_fuzz(i,j) = v;
        
    end
end


figure()
imshow(uint8(B_fuzz))
%%
% fuzzy logic enhancement2
% functions are in seperate files for better organization, they are called
% Udark, Ugray and Ubright

%%
% fuzzy logic enhancement
% functions are in seperate files for better organization, they are called
% Udark, Ugray and Ubright
clear all;
close all

A = imread('einstein-low-contrast.tif');
figure()

imshow(A)
shapeA = size(A);
B_fuzz = zeros(shapeA(1),shapeA(2));

dark = -10;
gray = 0;
bright = 10;



for i=1:shapeA(1)
    for j=1:shapeA(2)
        
        a = double(A(i,j));
        
        v = (Udark(a)*dark +Ugray(a)*0 + Ubright(a)*bright)/(Udark(a)+Ugray(a)+Ubright(a));

        B_fuzz(i,j) = A(i,j) + v;

        
    end
end

figure()
imshow(uint8(B_fuzz))
