clear all; close all; clc

load handel
v = y'/2;
v = v(1:end - 1);
L = 9; n = length(v);
t2 = linspace(0, L, n+1); t = t2(1:n);
k = (2*pi/L)*[0:n/2-1 -n/2:-1]; ks = fftshift(k);

%Filters
%Gabor/Shannon: translation width; Ricker: sigma
strength = 100; sigma = 0.5; width = 0.025;
tslide = 0:0.05:t(end);
vgt_spec = zeros(length(tslide), 73112);
for i = 1:length(tslide)
    %Gaussian filter
    g = exp(-strength*((t - tslide(i)).^2));
    %Mexican hat wavelet
    %g = 2./(sqrt(3.*sigma).*(pi^(1/4))).*(1-((t-tslide(i))./sigma).^2).*exp(-(t-tslide(i)).^2./(2*sigma.^2));
    %Shannon filter
    %g = heaviside(t-tslide(i)+width).*(1-heaviside(t-tslide(i)-width));
    vt = fftshift(fft(v));
    vg = g.*v;
    vgt = fft(vg);
    vgt_spec(i, :) = abs(fftshift(vgt));
    
    subplot(3, 1, 1), plot(t, v, 'r', t, g, 'k'); axis([0 9 -1 1])
    xlabel('t'); ylabel('wave')
    subplot(3, 1, 2), plot(t, vg, 'k'); axis([0 9 -1 1])
    xlabel('t'); ylabel('wave')
    subplot(3, 1, 3), plot(t, abs(fftshift(vgt))/max(abs(vgt))); axis([0 9 0 1])
    xlabel('t'); ylabel('frequency')
    drawnow
end

figure(2)
pcolor(tslide, ks, vgt_spec.'./max(abs(vgt_spec.'))), shading interp
colormap(hot)