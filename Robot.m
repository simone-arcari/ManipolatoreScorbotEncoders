classdef Robot < handle
    properties (Access = private)
        N;
        Serial;
        Encoders;
    end
    
    
    methods
        function obj = Robot(n, port, baudrate)
            if(n <= 0)
                error("Number of motors must be at least 1.");
            end
            
            if(n > 8)
                error("The protocol support up to 8 motors.");
            end
            
            obj.N = uint8(n);
            obj.Serial = serialport(port, baudrate);
            obj.Serial.flush();
            
            obj.Encoders = zeros(obj.N, 1);
        end
    end
    
    
    
    methods (Access = public)
        function [num, status, switches, delta, encoders] = control(obj, command, values)
            obj.snd_ctrl(command, values);
            [num, status, switches, delta] = obj.rcv_ctrl();
            obj.Encoders = obj.Encoders + delta;
            encoders = obj.get_encoders();
        end
        
        function result = setup(obj, num, values)
            obj.snd_setup(num, values);
            result = obj.rcv_setup();
        end
        
        
        function result = get_size(obj)
            result = obj.N;
        end


        function serial = get_serial(obj)
            serial = obj.Serial;
        end


        function reset_encoders(obj, values)
            if(~isequal(size(values), [obj.N,1]))
                error("Values must be a column vector with size equal to " + string(obj.N));
            end
            obj.Encoders = int64(values);
        end
        
        
        function [values] = get_encoders(obj)
            values = double(obj.Encoders);
        end
        
        
        function [num, status, switches, delta, encoders] = stop_motors(obj)
            [num, status, switches, delta, encoders] = obj.control(Command.Idle, zeros(obj.N, 1));
        end
        
        
        function [num, status, switches, delta, encoders] = set_pwm(obj, values)
            [num, status, switches, delta, encoders] = obj.control(Command.DAQ, values);
        end
        
        
        function [num, status, switches, delta, encoders] = set_delta_enc(obj, values)
            [num, status, switches, delta, encoders] = obj.control(Command.PID, values);
        end
        
        function [num, status, switches, delta, encoders] = set_encoders(obj, values)
            
            [num, status, switches, delta, encoders] = obj.control(Command.PID, min(max(values-obj.get_encoders(), -255), 255));
        end
    end
    
    
    
    methods (Access = public)
        function snd_ctrl(obj, command, values)            
            bw = obj.Serial.NumBytesWritten;
            data = sndctrl(obj.N, command, values);
            %disp(dec2bin(data));
            obj.Serial.write(data, 'uint8');
            while((obj.Serial.NumBytesWritten - bw) < (2+obj.N))
            end
        end
        
        function [num, status, switches, values] = rcv_ctrl(obj)
            while(obj.Serial.NumBytesAvailable < (3+obj.N))
            end
            data = obj.Serial.read(3+obj.N, 'uint8');
            %disp(dec2bin(data));
            [num, status, switches, values] = rcvctrl(data);
            obj.Encoders = obj.Encoders + values;
        end
        
        function snd_setup(obj, num, values)
            bw = obj.Serial.NumBytesWritten;
            data = sndsetup(num, values);
            %disp(dec2bin(data));
            obj.Serial.write(data, 'uint8');
            while((obj.Serial.NumBytesWritten - bw) < 25)
            end
        end
        
        function result = rcv_setup(obj)
            while(obj.Serial.NumBytesAvailable < 1)
            end
            data = obj.Serial.read(1, 'uint8');
            %disp(dec2bin(data));
            result = rcvsetup(data);
        end
    end
end
