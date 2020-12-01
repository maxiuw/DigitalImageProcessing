clear;
close all;
img = imread('HW7_Problem2.jpg');
A = double(img);
threshold = 40;
max_M = 13;
B = zeros(size(img,1),size(img,2));

for i=1:size(img,1)
    
    for j=1:size(img,2)
        stage_A = 1;
        stage_B = 0;
        M = 1;
        while stage_A ==1
            
            test_image = A(max(i-M,1):min(i+M,size(img,1)),max(j-M,1):min(j+M,size(img,2)));
            A1 = median(test_image(:)) - min(test_image(:));
            A2 = median(test_image(:)) - max(test_image(:));
            
            if (A1>threshold) && (A2<(-threshold))
                stage_A = 0;
                stage_B = 1;
                
                
            elseif M <= max_M
                M=M+1;
            
            else 
                B(i,j) = median(test_image(:));
                stage_A = 0;
            end
            
            
        end
        
        if stage_B ==1
           test_image = A(max(i-M,1):min(i+M,size(img,1)),max(j-M,1):min(j+M,size(img,2)));

           B1 = A(i,j)-max(test_image(:));
           B2 = A(i,j)-min(test_image(:));
           if (B1>0) && (B2<0)
               B(i,j) = A(i,j);
              
           else
               B(i,j) = median(test_image(:));
           end
           
            
        end 
        
        
        
        
        
    end
end



med3 = medfilt2(img,[3,3]);
med13 = medfilt2(img,[13,13]);

figure()
imshow(uint8(B))
title('adaptive median filter ');
imwrite(uint8(B),'adaptive median filter .png');
figure()
imshow(uint8(med3))
title(' median filter 3x3');
imwrite(uint8(med3),'median filter 3x3 .png');

figure()
imshow(uint8(med13))
title('median filter 13x13');
imwrite(uint8(med13),'median filter 13x13 .png');

