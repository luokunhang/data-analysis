clear all; close all; clc;
load Testdata.mat
L=15; % spatial domain
n=64; % Fourier modes
x2=linspace(-L,L,n+1); x=x2(1:n); y=x; z=x;
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; ks=fftshift(k);
[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);

Un_sum = zeros(n, n, n);

for i = 1:20
    Un_sum = Un_sum + fftn(reshape(Undata(i,:),n,n,n));
end

Un_ave = abs(fftshift(Un_sum))/20;
Un_ave_norm = Un_ave/max(Un_ave(:));
[M, I] = max(Un_ave_norm(:));
[a, b, c] = ind2sub([n, n, n], I);
frq = zeros(3, 1);
frq(1) = Kx(a, b, c);
frq(2) = Ky(a, b, c);
frq(3) = Kz(a, b, c);
isosurface(Kx, Ky, Kz, Un_ave_norm, 0.7); grid on
xlabel('x'); ylabel('y'); zlabel('z');
title("Frequency content in Fourier domain with isovalue 0.7")

%create a filter in frequency field
filter = fftshift(exp(-0.2*((Kx - Kx(28, 42, 33)).^2 + (Ky - Ky(28, 42, 33)).^2 + (Kz - Kz(28, 42, 33)).^2)));
Unt = zeros(n, n, n);
Untf = zeros(n, n, n);
Unf = zeros(n, n, n);
loc = zeros(3, 20);
for i = 1:20
    Unt(:, :, :) = fftn(reshape(Undata(i,:), n, n, n));
    Untf = filter.*Unt;
    Unf = ifftn(Untf);
    [M, I] = max(abs(Unf(:)));
    [p, q, r] = ind2sub([n, n, n], I);
    loc(:, i) = [X(p, q, r), Y(p, q, r), Z(p, q, r)];
end


plot3(loc(1, :), loc(2, :), loc(3, :), 'LineWidth', 2);
hold on; grid on;
axis([-12 12 -12 12 -12 12])
xlabel("x")
ylabel("y")
zlabel("z")
    
for i = 1:20
    plot3(loc(1, i), loc(2, i), loc(3, i), 'k*', 'LineWidth', 2);
end
plot3(loc(1, 20), loc(2, 20), loc(3, 20), 'r*', 'LineWidth', 6);