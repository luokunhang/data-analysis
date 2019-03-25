close all; clc
time = length(vidFrames1_4(1, 1, 1, :));
filter = 0.92;

a_1 = zeros(1, time); b_1 = zeros(1, time);
for i = 1:time
    x = double(rgb2gray(vidFrames1_4(:, :, :, i)));
    x(1:200, :) = 0;
    x(:, 1:300) = 0;
    x(:, 501:end) = 0;
    
    M = max(x(:));
    [maxa, maxb] = find(x >= M*filter);
    a_1(i) = mean(maxa);
    b_1(i) = mean(maxb);
end
a_2 = zeros(1, time); b_2 = zeros(1, time);
for i = 1:time
    x = double(rgb2gray(vidFrames2_4(:, :, :, i+6)));
    x(1:50, :) = 0;
    x(401:end, :) = 0;
    x(:, 1:220) = 0;
    x(:, 411:end) = 0;
    
    M = max(x(:));
    [maxa, maxb] = find(x >= M*filter);
    a_2(i) = mean(maxa);
    b_2(i) = mean(maxb);
end
a_3 = zeros(1, time); b_3 = zeros(1, time);
for i = 1:time
    x = double(rgb2gray(vidFrames3_4(:, :, :, i)));
    x(1:150, :) = 0;
    x(281:end, :) = 0;
    x(:, 1:300) = 0;
    x(:, 511:end) = 0;
    
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
B = u(:, 1) * s(1, 1) * v(:, 1)' + u(:, 2) * s(2, 2) * v(:, 2)' + u(:, 3) * s(3, 3) * v(:, 3)';
C = A - B;