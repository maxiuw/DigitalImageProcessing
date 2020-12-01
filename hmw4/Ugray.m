function f = Ugray(z)
% y1 = 1/35x - 50/35
%y2 = -1/40x +125/40

if z <= 75 || z>=225
    f = 0;
elseif (z>75) && (z<150)
    f = (1/75)*z - 75/75;
elseif z==150
    f =1;
elseif (z>150) && (z<225)
    f = -(1/75)*z + (150/75);
end

end

