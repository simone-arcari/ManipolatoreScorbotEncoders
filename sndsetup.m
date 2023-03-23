function [data] = sndsetup(num, values)
    if(num < 0 || num > 7)
        error("num must be between 0 and 7");
    end

    if(length(values) ~= 6)
        error("Wrong values size. Expected 6 values.");
    end
    
    values = single(values);

    data = zeros(25, 1, 'uint8');
    data(1) = bitor(bitshift(num, 5), Command.Setup);
    for k = 1:6
        bin = dec2bin(typecast(values(k), 'uint32'), 32);
        for r = 1:4
            data(1 + 4*(k-1) + r) = uint8(bin2dec(bin(end-8*r+1:end-8*(r-1))));
        end
    end
end