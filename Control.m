clear all;
clc;


% Serial port utility
ports = serialportlist("available");
disp(ports)
pause(0.5)


% Parameters
N = 6;
port = ports(1);
baudrate = 115200;                  % velocità di trasmissione dati
pwms = [255; -255; 255; 0; 0; 0];    % vettore riga per i pwm di ogni motore
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
pwms = [255; -255; 255; 0; 0; 0];
findLimit(robot, pwms)

pwms = [-255; 255; 0; 0; 0; 0];
findLimit(robot, pwms)

robot.stop_motors();

robot.Encoders = zeros(N,1);

pwms = [0; 0; 0; 0; 0; 0];
[num(1), status(1), switches, delta, encoders] = robot.control(Command.DAQ, pwms(:,1));
fprintf("encoders: %d %d %d %d %d %d\n", encoders(1), encoders(2), encoders(3), encoders(4), encoders(5), encoders(6));


%%
tiledlayout(5,1);

ax1 = nexttile;
plot(T', num', 'k');
grid on;
title("Num");
legend("num");

ax2 = nexttile;
plot(T', status', 'k');
grid on;
title("Status");
legend("status");

ax3 = nexttile;
plot(T', switches');
grid on;
title("Status");
legend("switch " + string(1:N));

ax4 = nexttile;
plot(T', delta');
grid on;
title("Delta");
legend("delta " + string(1:N));

ax5 = nexttile;
plot(T', encoders');
grid on;
title("Encoders");
legend("encoders " + string(1:N));

linkaxes([ax1, ax2, ax3, ax4, ax5], 'x');

