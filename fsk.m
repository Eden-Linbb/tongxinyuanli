clc;clear; close all
%初始条件
Fc=36;
Fs=360;
Fd=20;
t=1/360:1/360:20;

%产生数字基带信号并绘制时域谱和频域谱
x=ceil(rand(1,100000)-0.5);
FFT1=abs(fft(x,128));
figure(1)
subplot(211);
plot(x);
title("基带信号时域谱")
axis([0 50 -1 2])
subplot(212)
plot(fftshift(abs(FFT1)))
title("基带信号频域谱")

%设置载波频率并绘制其时域谱和频域谱
carry=cos(2*pi*Fc*t);
FFT2=abs(fft(carry,256));
figure(2)
subplot(211)
plot(carry)
title("载波信号时域谱")
axis([0 300 -2 2])
subplot(212)
plot(fftshift(abs(FFT2)))
title("载波信号频域谱")

%对信号进行数字调制并绘制时域谱和频域谱
y=dmod(x,Fc,Fd,Fs,'fsk',4);%调用数字带通调制函数dmod进行2FSK调制
for i=1:20
    yy(30*(i-1)+1:30*i)=y(30*(i-1)+1:30*i); 
end
FFT3=abs(fft(yy,256));
figure(3)
subplot(211);
plot(yy);
title('调制信号时域谱');
axis([0 300 -2 2])
subplot(212)
plot(fftshift(abs(FFT3)));
title('调制信号频域谱');

%对已调信号进行解调并绘制时域谱和频域谱
z=ddemod(y,Fc,Fd,Fs,'fsk',4);
FFT4=abs(fft(z,64));
figure(4)
subplot(211);
plot(z);
title('解调信号时域谱');
axis([0 50 0 2])
subplot(212)
plot(fftshift(abs(FFT4)));
title('解调信号频域谱');

%对已调信号加入SNR为6和-2高斯白噪声，绘制时域谱和频域谱
Ynt1=awgn(y,6);
YNT1=abs(fft(Ynt1,256));
figure(5)
subplot(211)
plot(Ynt1);
title('SNR为6的高斯白噪声调制信号时域谱');
axis([0 50 0 2])
subplot(212)
plot(fftshift(YNT1));
title('SNR为6的高斯白噪声调制信号频域谱');

z1=ddemod(Ynt1,Fc,Fd,Fs,'fsk',4);
Z1=abs(fft(z1,256));
figure(6)
subplot(211)
plot(z1);
title('加入SNR为6的高斯白噪声解调信号时域谱');
axis([0 50 0 2])
subplot(212)
plot(fftshift(Z1))
title('加入SNR为6的高斯白噪声解调信号频域谱');

Ynt2=awgn(y,-2);
YNT2=abs(fft(Ynt2,256));
figure(7)
subplot(211)
plot(Ynt2);
title('SNR为-2的高斯白噪声调制信号时域谱');
axis([0 50 -4 4])
subplot(212)
plot(fftshift(YNT2));
title('SNR为-2的高斯白噪声调制信号频域谱');

z2=ddemod(Ynt2,Fc,Fd,Fs,'fsk',2);
Z2=abs(fft(z2,256));
figure(8)
subplot(211)
plot(z2);
title('加入SNR为-2的高斯白噪声解调信号时域谱');
axis([0 50 0 2])
subplot(212)
plot(fftshift(Z2))
title('加入SNR为-2的高斯白噪声解调信号频域谱');

SNR=-10:2;
for i=1:length(SNR) 
    Ynt3=awgn(y,SNR(i));	%加入高斯小噪声，信噪比从-10dB到10dB
Z=ddemod(Ynt3,Fc,Fd,Fs,'fsk',4); %调用数字带通解调函数ddemod对加噪声信号进行解调
[br, Pe(i)]=symerr(x,Z);%对解调后加大噪声信号误码分析，br为符号误差数，Pe(i)为符号误差率
end
figure(9)
semilogy(SNR,Pe);			% 调用semilogy函数绘制信噪比与误码率的关系曲线
xlabel('信噪比 SNR(r/dB)');
ylabel('误码率 Pe');
title('信噪比与误码率的关系');
axis([-10 2 0 1])
grid on