function [data] = sndctrl(num, command, values)
    n = uint8(num);
    cmd = uint8(command);

    if(num < 1 || num > 8)
        error("num must be between 1 and 8");
    end
    if(n ~= num)
        error("num must be an integer");
    end
    
    if(command < 0 || command > 31)
        error("Command must be between 0 and 31");
    end
    if(command ~= cmd)
        error("Command must be an integer");
    end
    
    if(length(values) ~= n)
        error("Values must be a column vector with size equal to " + string(n));
    end
    
    data = zeros(2+n, 1, 'uint8');
    data(1) = bitor(bitshift(n-1, 5), cmd);
    for k = 1:num
        data(2) = bitor(bitshift(uint8(values(k) < 0), k-1), data(2));
        data(2+k) = uint8(min(round(abs(values(k))), 255));
    end
end