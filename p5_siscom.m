function p5_siscom(  )

  t = 0:0.5/10000:0.5;
  fa = 10*pi;

  v = sin(fa*t);
  plotFunction(1, 211, t, v, "Senal original");

  fs = 10*(fa);
  d = [0.5 0.4 0.3 0.2 0.1 0.05];

  for i = 1:1:6
     vs = pam(v, fs, d(i)*100, t);
     plotFunction(2, (230+i), t, vs, ['PAM d = ', num2str(d(i))]);
  end

  for i = 1:1:6
     vs = pam(v, fs, d(i)*100, t);
     [ w, ywf ] = magneticSpectrum(vs, fs);
     plotFunction(3, (230+i), w, ywf, ['Espectro d = ', num2str(d(i))]);
  end

  fc = 20/10000;
  [b,a] = butter(6,fc);
  vcf = filter(b,a,vs);

  plotFunction(1, 212, t, vcf, "Senal de Filtro");

end

function plotFunction(fig, sp, x, y, tit)

  figure(fig);
  subplot(sp);
  plot(x,y,'red');
  title(tit);
  axis auto;
  grid;

end

function [vs] = pam(v, fs, d, t)

  fsqr = (0.5*(square(fs*t,d)+1));
  vs = v.*fsqr;

end

function [ w, ywf ] = magneticSpectrum(vs, fs)

  yw = fft(vs);
  ywf = abs(fftshift(yw));
  w=(-fs/2):(fs/(length(yw)-1)):(fs/2);

  xlabel('Hz');
  ylabel('Magnitud');

end
