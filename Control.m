clear all;
clc;


% Serial port utility
ports = serialportlist("available");
disp(ports)
pause(0.5)


% Parameters
N = 6;
port = ports(5);
baudrate = 115200;                  % velocità di trasmissione dati
pwms = [255; -255; 255; 0; 0; 0];   % vettore riga per i pwm di ogni motore
num = zeros(1, 1000);               %
status = zeros(1, 1000);            %
switches = zeros(N, 1000);          %
delta = zeros(N, 1000);             % ogni colonna tiene traccia dell'incremeto letto dagli encoder
encoders = zeros(N, 1000);          % ogni colonna tiene traccia del valore corrente degli encoder

% Initialization
clear robot
robot = Robot(N, port, baudrate);
pause(1);



% test 0 GO HOME
robot.Encoders = zeros(N,1);

pwms = [255; -255; 255; 0; 0; 0];
findLimit(robot, pwms)


pwms = [-255; 255; 0; 0; 0; 0];
findLimit(robot, pwms)

robot.stop_motors();

robot.Encoders = zeros(N,1);

pwms = [255; -255; -255; 0; 0; 0];
Stop = eye(N,N);
home = [8800, -3200, -2000, 0, 0 ,0];
one = ones(N,1);
zero =zeros(N,1);

Stop(4,4)=0;
Stop(5,5)=0;
Stop(6,6)=0;

while ~isequal(Stop*one,zero)

    [num(1), status(1), switches, delta, encoders]  = robot.control(Command.DAQ, Stop*pwms);         
    
    for j = 1:1:3
        if( abs(home(j)-robot.Encoders(j)) < 300)
                Stop(j,j) = 0;
        end

    end
    robot.Encoders
end
robot.stop_motors();

pwms = [0; 0; 0; -255; 255; 0];
findLimit(robot, pwms)


pwms = [0; 0; 0; 255; -255; 0];
findLimit(robot, pwms)

robot.stop_motors();

