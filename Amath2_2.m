clear all; close all; clc

tr_piano=14; % record time in seconds
y=audioread('music2.wav'); %y=audioread('music2.wav');
Fs=length(y)/tr_piano;

S = y(1:end)';
L = tr_piano; n = length(S);
t2 = linspace(0, L, n+1); t = t2(1:n);
k = (2*pi/L)*[0:n/2-1 -n/2:-1]; ks = fftshift(k);

%Gabor filter
strength = 50;
tslide = 0:0.2:t(end);
S_gt_max = zeros(length(tslide), 1);
for i = 1:length(tslide)
    %Gaussian filter
    g = exp(-strength*(t - tslide(i)).^2);
    S_g = g.*S;
    S_gt = fft(S_g);
    [M, I] = max(abs(S_gt));
    S_gt_max(i) = k(I);
    
    %subplot(3, 1, 1), plot(t, S, 'r', t, g, 'k');
    %subplot(3, 1, 2), plot(t, S_g, 'k');
    %subplot(3, 1, 3), plot(t, abs(fftshift(S_gt))/max(abs(S_gt)));
    %drawnow
end
figure(2)
plot(tslide, S_gt_max./(2*pi), 'LineWidth', 2)
xlabel('time'); ylabel('frequency')