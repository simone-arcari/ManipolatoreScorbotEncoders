function [num, status, switches, values] = rcvctrl(data)
    num = double(bitshift(data(1), -5) + 1);

    if (length(data) ~= num+3)
        error("Wrong data size. Expected " + string(num+3) + " bytes.");
    end

    status = double(bitand(data(1), 0b00011111));
    
    switches = false(num, 1);
    values = zeros(num, 1);
    for k = 1:num
        switches(k) = double(bitand(data(2), bitshift(uint8(1),k-1)) > 0);
        values(k) = double(data(3+k)) * (1 - 2* (bitand(data(3), bitshift(uint8(1),k-1)) > 0));
    end
end