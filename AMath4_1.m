clear all; close all; clc
A = [];
loc = strcat('music_test2/');
m = 1;
list = dir(loc);
genres = extractfield(list, 'name');
genres = genres(3:end);
keep = [ones(64*m, 1); 2*ones(64*m, 1); 3*ones(64*m, 1)];
for o = 1:length(genres)
    subloc = strcat(loc, genres{o}, '/');
    list = dir(subloc);
    songs = extractfield(list, 'name');
    songs = songs(3:end);
    for i = 1:length(songs)
        [Y, FS] = audioread(strcat(subloc, songs{i}), 'double');
        time = 1;
        for j = 10:5:45
            x = Y(j*FS:(j+5)*FS, :);
            x = (x(:, 1) + x(:, 2))./2;
            x = resample(x, 20000, FS);

            x = abs(spectrogram(x));
            x = reshape(x, [16385*8, 1]);
            A = [A x];
        end
    end
end
%%
[u, s, v] = svd(A-mean(A(:)), 'econ');
plot(diag(s)./sum(diag(s)), 'o')

%%
p = v';
plot(p(1, 1:45), p(2, 1:45), 'rx', 'LineWidth', 3); hold on
plot(p(1, 65:109), p(2, 65:109), 'bx', 'LineWidth', 3); hold on
plot(p(1, 129:173), p(2, 129:173), 'kx', 'LineWidth', 3);
legend('Folk', 'Indie', 'Pop')
xlabel('Mode 1'); ylabel('Mode 2')

%%
p = v';
d = [1 2 3];
plot3(p(d(1), 1:45), p(d(2), 1:45), p(d(3), 1:45), 'rx', 'LineWidth', 3); hold on
plot3(p(d(1), 65:109), p(d(2), 65:109), p(d(3), 65:109), 'bx', 'LineWidth', 3);
plot3(p(d(1), 129:173), p(d(2), 129:173), p(d(3), 129:173), 'kx', 'LineWidth', 3);
legend('Folk', 'Indie', 'Pop')
xlabel('Mode 1'); ylabel('Mode 2'); zlabel('Mode 3')

%%
percentage = zeros(100, 3);
for o = 1:100
    di = 3;
    p1 = randperm(64*m); p2 = randperm(64*m)+64*m; p3 = randperm(64*m)+128*m;
    train_range = [p1(1:45*m) p2(1:45*m) p3(1:45*m)];
    train = p(1:di, train_range)';
    test_range = [p1(45*m+1:64*m) p2(45*m+1:64*m) p3(45*m:64*m)];
    test = p(1:di, test_range)';
    point = 3;
    label = knnsearch(train, test, 'K', point, 'IncludeTies', true);

    test_label = zeros(length(test(1, :)), 1);
    for i = 1:length(label)
        count = [0 0 0];
        x = label{i};
        for j = 1:point
            if keep(x(j)) == 1
                count(1)  = count(1) + 1;
            end
            if keep(x(j)) == 2
                count(2)  = count(2) + 1;
            end
            if keep(x(j)) == 3
                count(3)  = count(3) + 1;
            end
        end
        [M, I] = max(count);
        test_label(i) = I;
    end
    percentage(o, 1) = sum(test_label == keep(test_range))/length(test_range);

%     subplot(3, 1, 1)
%     bar(test_label);
%     xlabel('Expected label'); ylabel('Actual label');

    %
    train_label = keep(train_range);
    model = fitcnb(train, train_label);
    test_label = model.predict(test);
%     subplot(3, 1, 2)
%     bar(test_label);
%     xlabel('Expected label'); ylabel('Actual label');
    percentage(o, 2) = sum(test_label == keep(test_range))/length(test_range);

    %
    test_label = classify(test, train, train_label);
%     subplot(3, 1, 3)
%     bar(test_label);
%     xlabel('Expected label'); ylabel('Actual label');
    percentage(o, 3) = sum(test_label == keep(test_range))/length(test_range);
end
figure
boxplot(percentage, 'Labels', {'KNN','Naive Bayes', 'LDA'}, 'Colors', 'k', 'Width', 0.1);
set(findobj(gca,'type','line'),'linew',1)
ylabel('Accuracy')