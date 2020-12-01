function f = Udark(z)
if z < 75
    f = 1;
elseif z > 150
    f = 0;
elseif (z >= 75) && (z <= 150)
    f = -z/75 + 150/75;
end

end

