clear;
clc;


%% Serial port utility
ports = serialportlist("available");
disp(ports);


%% Parameters
N = 6;
port = ports(1);
baudrate = 500000;
T = 0:0.01:60;
pwms = [255 * sin(2*pi.*T./10); 255 * cos(2*pi.*T./10); 2 * T; 255 * sin(2*pi.*T./10); 255 * cos(2*pi.*T./10); 2 * T];

num = zeros(1, length(T));
status = zeros(1, length(T));
switches = zeros(N, length(T));
delta = zeros(N, length(T));
encoders = zeros(N, length(T));


%% Initialization
clear robot
robot = Robot(N, port, baudrate);


%% Test 1
for k = 1:length(T)
    fprintf("cycle:    %d\n", k);
    [num(k), status(k), switches(:,k), delta(:,k), encoders(:,k)] = robot.control(Command.DAQ, pwms(:, k));
    fprintf("num:      %d\n", num(k));
    fprintf("status:   %d\n", status(k));
    fprintf("switches: %d %d %d %d %d %d\n", switches(1,k), switches(2,k), switches(3,k), switches(4,k), switches(5,k), switches(6,k));
    fprintf("delta:    %d %d %d %d %d %d\n", delta(1,k), delta(2,k), delta(3,k), delta(4,k), delta(5,k), delta(6,k));
    fprintf("encoders: %d %d %d %d %d %d\n", encoders(1,k), encoders(2,k), encoders(3,k), encoders(4,k), encoders(5,k), encoders(6,k));
    fprintf("\n");
end

robot.stop_motors();


%% Test 2
for k = 1:length(T)
    [num(k), status(k), switches(:,k), delta(:,k), encoders(:,k)] = robot.set_pwm(pwms(:,k));
end

robot.stop_motors();


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

