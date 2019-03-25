close all; clc
time = length(vidFrames1_2(1, 1, 1, :));
a_1 = zeros(1, time); b_1 = zeros(1, time);
filter = 0.95;

for i = 1:time
    x = double(rgb2gray(vidFrames1_2(:, :, :, i)));
    x(1:200, :) = zeros(200, 640);
    x(:, 1:300) = zeros(480, 300);
    x(:, 401:640) = zeros(480, 240);
    
    M = max(x(:));
    [maxa, maxb] = find(x >= M*filter);
    a_1(i) = mean(maxa);
    b_1(i) = mean(maxb);
    [a, b] = ind2sub([480, 640], I);
end
a_2 = zeros(1, time); b_2 = zeros(1, time);
for i = 1:time
    x = double(rgb2gray(vidFrames2_2(:, :, :, i+25)));
    x(1:50, :) = 0;
    x(:, 1:150) = 0;
    x(:, 401:640) = 0;
    
    M = max(x(:));
    [maxa, maxb] = find(x >= M*filter);
    a_2(i) = mean(maxa);
    b_2(i) = mean(maxb);
end
a_3 = zeros(1, time); b_3 = zeros(1, time);
for i = 1:time
    x = double(rgb2gray(vidFrames3_2(:, :, :, i)));
    x(1:200, :) = 0;
    x(321:480, :) = 0;
    x(:, 1:280) = 0;
    x(:, 501:640) = 0;
    
    M = max(x(:));
    [maxa, maxb] = find(x >= M*filter);
    a_3(i) = mean(maxa);
    b_3(i) = mean(maxb);
end

%PCA
A = [a_1; b_1; a_2; b_2; a_3; b_3];

[m, n] = size(A);
mn = mean(A, 2);
A = A - repmat(mn, 1, n);

[u, s, v] = svd(A, 'econ');
figure(2)
subplot(2, 1, 1)
plot(diag(s)/sum(diag(s)), '*', 'LineWidth', 3)
xlabel('Principal Component'); ylabel('Energy level')
subplot(2, 1, 2)
plot(v*s)
xlabel('Time'); ylabel('Location')
legend('Comp1', 'Comp2', 'Comp3', 'Comp4', 'Comp5', 'Comp6')

%%
B = u(:, 1) * s(1, 1) * v(:, 1)';
C = A - B;