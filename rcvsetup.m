function result = rcvsetup(data)
     status = double(bitand(data(1), 0b00011111));
     result = status == Status.Setup;
end