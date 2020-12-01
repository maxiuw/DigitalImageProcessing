close all;
clear;
img = double(imread('noised_image2.jpg'));
size_org = size(img);

% display spectrum 

D0 = 45;
ord = 3;

for i=1:size_org(1)
    for j=1:size_org(2)
        H = 1;
        radius = sqrt((i - (size_org(1)/2)-1)^2 + (j - (size_org(2)/2)-1)^2);
        for k =1:3 % calculating different centers 
            Dk = sqrt(( (i-size_org(1))/(2-k))^2 + ((j-size_org(2)/(2-k))^2));
            
            
            
        end
             
        
        
    end
end

