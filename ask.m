clc;clear; close all
Fc=36;
Fs=360;
Fd=20;
t=1/360:1/360:20;
x=ceil(rand(1,100000)-0.5);
FFT1=abs(fft(x,128));
figure(1)
subplot(211);
plot(x);
title("基带信号时域谱")
axis([0 50 0 2])
subplot(212)
plot(fftshift(abs(FFT1)))
title("基带信号频域谱")
carry=cos(2*pi*Fc*t);
FFT2=abs(fft(carry,256));
figure(2)
subplot(211)
plot(carry)
title("载波信号时域谱")
axis([0 50 -2 2])
subplot(212)
plot(fftshift(abs(FFT2)))
title("载波信号频域谱")
y=dmod(x,Fc,Fd,Fs,'ask',2);%调用数字带通调制函数dmod进行2ASK调制
for i=1:20
    if x(i)==0
        yy(30*(i-1)+1:30*i)=0;
    else
        yy(30*(i-1)+1:30*i)=y(30*(i-1)+1:30*i);
    end 
end
FFT3=abs(fft(yy,256));
figure(3)
subplot(211);
plot(yy);
title('调制信号时域谱');
subplot(212)
plot(fftshift(abs(FFT3)));
title('调制信号频域谱');
z=ddemod(y,Fc,Fd,Fs,'ask',2);
FFT4=fft(z,64);
figure(4)
subplot(211);
plot(z);
title('解调信号时域谱');
axis([0 50 0 2])
subplot(212)
plot(fftshift(abs(FFT4)));
title('解调信号频域谱');
Ynt1=awgn(y,6);
YNT1=abs(fft(Ynt1,256));
Ynt2=awgn(y,-2);
YNT2=abs(fft(Ynt2,256));
figure(5)
subplot(211)
plot(Ynt1);
title('SNR为6的高斯白噪声调制信号时域谱');
axis([0 50 0 2])
subplot(212)
plot(fftshift(YNT1));
title('SNR为6的高斯白噪声调制信号频域谱');
figure(6)
subplot(211)
plot(Ynt2);
title('SNR为-2的高斯白噪声调制信号时域谱');
axis([0 50 0 2])
subplot(212)
plot(fftshift(YNT2));
title('SNR为-2的高斯白噪声调制信号频域谱');