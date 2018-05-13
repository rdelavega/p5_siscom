function p5_siscom( void )

  t = 0:0.5/10000:0.5;
  fa = 10*pi;

  v = sin(fa*t);
  plotFunction(1, 111, t, v, "Senal original", 0);

  fs = 10*(fa);
  d = [0.5 0.4 0.3 0.2 0.1 0.05];
  fc = 20/10000;
  [b,a] = butter(6,fc);

  for i = 1:1:6
     vs = pam(v, fs, d(i)*100, t);
     plotFunction(2, (230+i), t, vs, ['PAM d = ', num2str(d(i))], 0);
     vs = pam(v, fs, d(i)*100, t);
     [ w, ywf ] = magneticSpectrum(vs, fs);
     plotFunction(3, (230+i), w, ywf, ['Espectro d = ', num2str(d(i))], 0);
     vcf = filter(b, a, vs);
     plotFunction(4, (230+i), t, vcf, ['Senal de Filtro d = ', num2str(d(i))], 0);
  end

  pcm();
  
end


function plotFunction( fig, sp, x, y, tit, typ )

  figure(fig);
  subplot(sp);
  if (typ == 0)
    plot(x,y,'blue');
  elseif (typ == 1)
    stairs(x,y,'blue');
  end
  title(tit);
  axis auto;
  grid;

end

function [vs] = pam( v, fs, d, t )

  fsqr = (0.5*(square(fs*t,d)+1));
  vs = v.*fsqr;

end

function [ w, ywf ] = magneticSpectrum( vs, fs )

  yw = fft(vs);
  ywf = abs(fftshift(yw));
  w=(-fs/2):(fs/(length(yw)-1)):(fs/2);
  xlabel('Hz');
  ylabel('Magnitud');

end

function pcm( void )

  [v,Fs] = audioread('audio.wav');

  dt = 0.1;
  lv = length(v);
  t = linspace(0, (lv/Fs), lv);
  inc = ((lv-1) * dt);

  for k = 1:inc
      data(1,k) = v(k);
  end

  newVector = 0:dt:((length(data)-1)*dt);
  tSpace = (((lv-1)*dt)*dt)/(lv/Fs);

  plotFunction(5, 311, newVector, data, '', 1);
  axis([0,tSpace,-0.5,0.5]);
  plotFunction(5, 312, t, v, '', 0);
  axis([0,0.1,-0.5,0.5]);

  quantization = getQuantization(v, data, inc);
  fprintf('Audio');
  sound(quantization);
  plotFunction(5, 313, newVector, quantization, '', 1);
  axis([0,tSpace,-0.5,0.5]);

end

function quantization = getQuantization( v, data, inc )

  inputMax = max(v);
  bit = 8;
  level = 2^bit;
  dist = (2 * inputMax) / level;

  for i = 1:inc
      quantization(i) = round(data(i)/dist)*dist;
  end

end
