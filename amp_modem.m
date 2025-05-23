clear
hold off
format long e

% time samples
N = 2^16; %No. of FFT samples
sampling_rate = 40e4; %unit Hz
tstep = 1/sampling_rate;
tmax = N*tstep/2;
tmin = -tmax;
tt = tmin:tstep:tmax-tstep;

%freq samples
fmax = sampling_rate/2; 
fmin = -fmax;
fstep = (fmax-fmin)/N;
freq = fmin:fstep:fmax-fstep;

%% Modulation

%carrier
fc=20e3;
Ac = 1;
ct=Ac*cos(2*pi*fc*tt);

%message signal 
Am=-2;
fm = 2e3;
%mt = Am*sin(2*pi*fm*tt);
Tm = 5e-4;
%already modified sinc function interaction
mt = Am*sinc(2*pi*tt / Tm);


%max of absolute of m(t)
maxmt = Am;
%For 40% modulation
%ka=0.4/maxmt;
%ka = 0.5 / maxmt;
ka = 2 / maxmt;
%AM signal
st = (1+ka*mt).*ct;

% Carrier Signal, Time Domain
figure(1)
Hp1 = plot(tt,ct);
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Time (sec) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('Carrier c(t)  (Volt)');
set(Hx,'FontWeight','bold','Fontsize',16)
title('Carrier : Time domain');
axis([-1e-3 1e-3 -1.1 1.1])
pause(1)

% Message Signal Time domain
figure(2)
Hp1 = plot(tt,mt);
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Time (sec) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('message  m(t)  (Volt)');
set(Hx,'FontWeight','bold','Fontsize',16)
title('message signal : Time domain');
axis([-2e-3 2e-3 min(mt) max(mt)])
pause(1)

% Modulated Signal, Time domain
figure(3)
Hp1 = plot(tt,st);
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Time (sec) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('s(t)  (Volt)');
set(Hx,'FontWeight','bold','Fontsize',16)
title('modulated wave : Time domain');
axis([-2e-3 2e-3 min(st) max(st)])
pause(1)

% Spectrum of Message signal
Mf1 = fft(fftshift(mt));
Mf = fftshift(Mf1);
figure(4)
Hp1=plot(freq,abs(Mf));
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Frequency (Hz) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('|M(f)|');
set(Hx,'FontWeight','bold','Fontsize',16)
title('Spectrum of the message signal');
axis ([-5e3 5e3 0 max(abs(Mf))])
%pause(5)

% Spectrum of Modulated signal
Sf1 = fft(fftshift(st));
Sf = fftshift(Sf1);
figure(5)
Hp1=plot(freq,abs(Sf));
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Frequency (Hz) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('|S(f)|');
set(Hx,'FontWeight','bold','Fontsize',16)
title('Spectrum of the modulated wave');
axis ([-25e3 25e3 0 max(abs(Sf))])
%pause(5)

%% Demodulation

%time constant RC
%This should be optimized to avoid envelope distortion 
%RC = 0.5*(1/fc + 1/fm);
%RC = 1/fc;
%RC = 10*Tm;
%RC = best optimzation;
RC = 0.5.*(Tm + 1/fc);
%Envelope detector
yt = st;
n=1;
for t=tt
    if(n > 1)
        if(yt(n-1) > st(n))
            yt0 = yt(n-1);
            %time when C starts discharging
            tc = tt(n-1);
            yt(n) = yt0*exp(-(t-tc)/RC);
        end
    end
    n=n+1;
end
yt(1)=yt(2);


figure(6)
Hp1 = plot(tt,yt);
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Time (sec) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('y(t)  (Volt)');
set(Hx,'FontWeight','bold','Fontsize',16)
title('After the envelope detector');
axis([-2e-3 2e-3 0 max(yt)])
pause(1)
figure(7)

%DC removal and division by ka
yt1 = (yt - 1)/ka;
Hp1 = plot(tt,yt1,'r',tt,mt,'k');
legend('after DC removal','message signal')
set(Hp1,'LineWidth',2)
Ha = gca;
set(Ha,'Fontsize',16)
Hx=xlabel('Time (sec) ');
set(Hx,'FontWeight','bold','Fontsize',16)
Hx=ylabel('y1(t)  (Volt)');
set(Hx,'FontWeight','bold','Fontsize',16)
title('After the DC removal');
axis([-2e-3 2e-3 min(mt) max(mt)])
%pause

%Low pass filter to remove the ripple
%choose the cutoff frequency of the filter to be slightly higher than
%the highest freq of the message signal
% f0 = 1.1*fm;
% mt1 = rect_filt(yt1,freq,f0);
% figure(8)
% Hp1 = plot(tt,mt1);
% set(Hp1,'LineWidth',2)
% Ha = gca;
% set(Ha,'Fontsize',16)
% Hx=xlabel('Time (sec) ');
% set(Hx,'FontWeight','bold','Fontsize',16)
% Hx=ylabel('m1(t)  (Volt)');
% set(Hx,'FontWeight','bold','Fontsize',16)
% title('After the low pass filter');
% axis([-2e-3 2e-3 min(mt1) max(mt1)])








     
