clear all; close all; clc
%load data
A = [];
list = dir('CroppedYale');
folders = extractfield(list, 'name');
folders = folders(3:end, :);
for i = 1:length(folders)
    sublist = dir(strcat('CroppedYale/', folders{i}));
    subfolders = extractfield(sublist, 'name');
    subfolders = subfolders(3:end);

    for j = 1:length(subfolders(:, 1))
        img = imread(strcat('CroppedYale/', folders{i}, '/', subfolders{j}));
        img = reshape(img, [192*168, 1]);
        A = [A img];
    end
end
%%
A = double(A);
[u, s, v] = svd(A - mean(A(:)), 'econ');
plot(diag(s)/sum(diag(s)), 'x', 'LineWidth', 2)
xlabel('Principal Component(Dominant Feature)');
ylabel('Energy Percentage');

%%
for i = 1:4
    re = flip(u(:, i));
    re = reshape(re, [192, 168]);
    subplot(1, 4, i)
    pbaspect([1 1 1])
    pcolor(re); shading interp; colormap(hot);
    title(strcat('Mode', num2str(i)))
end
%%
figure(2)
for i = 1:4
    re = flip(u1(:, i));
    re = reshape(re, [243, 320]);
    subplot(1, 4, i)
    pbaspect([1 1 1])
    pcolor(re); shading interp; colormap(hot);
    title(strcat('Mode', num2str(i)))
end
%%
B = [];
list = dir('yalefaces');
faces = char(extractfield(list, 'name'));
faces = faces(3:end, :);
for i = 1:length(faces)
    img = imread(strcat('yalefaces/', faces(i, :)));
    img = reshape(img, [243*320, 1]);
    B = [B img];
end
B = double(B);

[u1, s1, v1] = svd(B - mean(B(:)), 'econ');
plot(diag(s1)/sum(diag(s1)), 'x')

%%
subplot(2, 1, 1)
plot(diag(s)/sum(diag(s)), '*', 'LineWidth', 2)
xlabel('Modes');
ylabel('Energy Percentage');
title('Energy level of each modes (Cropped Images)');

subplot(2, 1, 2)
plot(diag(s1)/sum(diag(s1)), '*', 'LineWidth', 2)
xlabel('Modes');
ylabel('Energy Percentage');
title('Energy level of each modes (Uncropped Images)');
%%
subplot(1, 2, 1)
o = flip(reshape(A(:, 1), [192 168]));
pcolor(o); shading interp; colormap(gray)
title('Original Image')
k = 100;
r = u(:, 1:k)*s(1:k, 1:k)*v(:, 1:k)';
r = r(:, 1);
r = flip(reshape(r, [192 168]));
subplot(1, 2, 2)
pcolor(r); shading interp; colormap(gray)
title('Truncated Image')
%%
figure(2)
subplot(1, 2, 1)
o = flip(reshape(B(:, 1), [243 320]));
pcolor(o); shading interp; colormap(gray)
title('Original Image')
subplot(1, 2, 2)
k = 80;
r = u1(:, 1:k)*s1(1:k, 1:k)*v1(:, 1:k)';
r = r(:, 1);
r = flip(reshape(r, [243 320]));
pcolor(r); shading interp; colormap(gray)
title('Truncated Image')