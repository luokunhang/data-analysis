clear all; close all; clc
load = VideoReader('Nadal.mp4');
video = [];
i = 1;
while hasFrame(load)
    frame = double(rgb2gray(readFrame(load)));
    frame = imresize(frame, 0.5);
    video = [video reshape(frame, [270*480 1])];
    i = i + 1;
end
X = video(:, 1:end-1);
X_prime = video(:, 2:end);

%%
[u, s, v] = svd(X, 'econ');
r = 1;
ur = u(:, 1:r);
sr = s(1:r, 1:r);
vr = v(:, 1:r);
Ar = ur' * X_prime * vr / sr;

[w, d] = eig(Ar);
fi = X_prime * vr / sr * w;
lambda = diag(d);
dt = 1/load.FrameRate;

omega = log(lambda)/dt;
[B, I] = sort(abs(omega));
Is = I(1:1);

x1 = video(:, 3);
b = fi \ x1;
frames = size(X, 2);
t = dt * 1:frames;
dynamics = zeros(r, length(t));

for i = 1:length(t)
    dynamics(:,i) = sum(b.*exp(omega(Is)*t(i))', 2);
end
Xd = fi*dynamics;
Xs = X - abs(Xd);

%%
neg = Xs;
neg(neg >= 0) = 0;
Xs = Xs - neg;

%%
% videoPlayer = vision.VideoPlayer;
for j = 1:frames
  videoFrame = reshape(Xd(:, j), [270 480]);
%   imshow(uint8(videoFrame));
  pcolor(flip(videoFrame)); shading interp; colormap(gray);
  pause(dt)
end

%%
subplot(2, 2, 1)
plot(diag(s)/sum(diag(s)), 'o', 'LineWidth', 1); 
xlabel('SVD modes'); ylabel('Energy percentage'); title('Energy of SVD modes')
subplot(2, 2, 2)
pcolor(flip(reshape(X(:, 80), [270 480]))); shading interp; colormap(gray);
title('Original frame')
subplot(2, 2, 3)
pcolor(flip(reshape(Xs(:, 80), [270 480]))); shading interp; colormap(gray);
title('Foreground')
subplot(2, 2, 4)
pcolor(flip(reshape(Xd(:, 80), [270 480]))); shading interp; colormap(gray);
title('Background')