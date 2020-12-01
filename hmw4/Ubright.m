function f = Ubright( z )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
if (z > 150) && (z < 225)
    % y = 1/75x - 1.33
    f = (1/75)*z -150/75;
    
elseif (z< 150)
    f = 0;
    
else 
    f = 1;
end

end

