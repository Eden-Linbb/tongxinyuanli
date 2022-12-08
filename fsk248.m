clc;clear;close all
x=ceil(rand(1,10000)-0.5);	%产生二进制随机序列并取大于x 的最小整数
t=1/360:1/360:20; 		    %载波时间范围
Fc=36;                      %载波频率
carry=cos(2*pi*Fc*t);       %正弦载波信号
Fd=20;                      %Fd为码速率
Fs=360;                     %Fs为采样频率
%2FSK
y=dmod(x,Fc,Fd,Fs,'fsk',2); %调用数字带通调制函数dmod进行2ASK调制
for i=1:20
    yy(30*(i-1)+1:30*i)=y(30*(i-1)+1:30*i);
end
SNR=-10:2;
for i=1:length(SNR) 
    Ynt3=awgn(y,SNR(i));	%加入高斯小噪声，信噪比从-10dB到10dB
Z=ddemod(Ynt3,Fc,Fd,Fs,'fsk',2);%调用数字带通解调函数ddemod对加噪声信号进行解调
[br, Pe(i)]=symerr(x,Z);%对解调后加大噪声信号误码分析，br为符号误差数，Pe(i)为符号误差率
end
figure(1)
semilogy(SNR,Pe);			% 调用semilogy函数绘制信噪比与误码率的关系曲线
xlabel('信噪比 SNR(r/dB)');
ylabel('误码率 Pe');
title('信噪比与误码率的关系');
grid on
hold on

%4FSK
y=dmod(x,Fc,Fd,Fs,'fsk',4);
for i=1:20
    yy(30*(i-1)+1:30*i)=y(30*(i-1)+1:30*i);
end
SNR=-10:2;
for i=1:length(SNR) 
    Ynt3=awgn(y,SNR(i));	%加入高斯小噪声，信噪比从-10dB到10dB
Z=ddemod(Ynt3,Fc,Fd,Fs,'fsk',4);%调用数字带通解调函数ddemod对加噪声信号进行解调
[br, Pe(i)]=symerr(x,Z);%对解调后加大噪声信号误码分析，br为符号误差数，Pe(i)为符号误差率
end
semilogy(SNR,Pe);			% 调用semilogy函数绘制信噪比与误码率的关系曲线
xlabel('信噪比 SNR(r/dB)');
ylabel('误码率 Pe');
title('信噪比与误码率的关系');
grid on

%8FSK
y=dmod(x,Fc,Fd,Fs,'fsk',8);
for i=1:20
    yy(30*(i-1)+1:30*i)=y(30*(i-1)+1:30*i);
end
SNR=-10:2;
for i=1:length(SNR) 
    Ynt3=awgn(y,SNR(i));	%加入高斯小噪声，信噪比从-10dB到10dB
Z=ddemod(Ynt3,Fc,Fd,Fs,'fsk',8);%调用数字带通解调函数ddemod对加噪声信号进行解调
[br, Pe(i)]=symerr(x,Z);%对解调后加大噪声信号误码分析，br为符号误差数，Pe(i)为符号误差率
end
semilogy(SNR,Pe);			% 调用semilogy函数绘制信噪比与误码率的关系曲线
xlabel('信噪比 SNR(r/dB)');
ylabel('误码率 Pe');
title('信噪比与误码率的关系');
grid on
legend('2FSK','4FSK','8FSK')