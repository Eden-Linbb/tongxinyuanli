%　　　　　　信源端信息设计　　　　　    %
%       消息信号:x(t)=cos(2*pi*t)+exp(-2*t)*sin(6*pi*t)   %
%       载波信息:m(t)=Acos(2*pi*fc*t)     A=1   fc=1k   %
clc;clear;close all
ts=0.00001;     %信号抽样时间间隔
t=0:ts:10-ts;      %时间向量
fs=1/ts;            %采样频率
msg=cos(2*pi*t)+exp(-2*t).*sin(6*pi*t);      %消息信号
A=1;                                        %载波振幅
fc=1000;                                    %载波频率
MSG=abs(fft(msg,256));                      %对消息信号进行FFT
figure(1);
subplot(2,1,1);
plot(t,msg);                                %画出消息信号的时域谱
title('消息信号时域谱');
subplot(2,1,2);
plot(fftshift(MSG));                        %画出消息信号的频谱
title('消息信号频谱');
carry=A*cos(2*pi*fc*t);                     %载波信号
CARRY=abs(fft(carry,256));                  %对载波信号求FFT
figure(2);
subplot(2,1,1);
plot(carry);                                %画出载波的时域谱
axis([0 500 -1 1]);
title('载波时域谱');
subplot(2,1,2);                             
plot(fftshift(CARRY));                                %画出载波频谱
title('载波频谱');

%------------------调制部分--------------------%
y1=ammod(msg,fc,fs);                         %用ammod语句对msg进行am调制，已调信号为y1
Y1=abs(fft(y1,256));
figure(3);
subplot(2,1,1);
plot(t,y1);                                   %画出已调信号时域谱
title('已调信号时域谱');
subplot(2,1,2);
plot(fftshift(Y1));                                   %画出已调信号频谱
title('已调信号频谱');

%------------------信道部分--------------------%
y2=awgn(y1,25,'measured');                 %调制信号通过信噪比为25db的信道
Y2=abs(fft(y2,256));

y4=awgn(y1,20,'measured');                  %调制信号通过信噪比为20db的信道
Y4=abs(fft(y4,256));

figure(4);
subplot(2,1,1);
plot(t,y2);                                   %已调信号通过信道之后的时域谱
title('25db信道后已调信号时域谱');
subplot(2,1,2);
plot(fftshift(Y2));                       %已调信号通过信道之后的频域谱
title('25db信道后已调信号频谱');

figure(6);
subplot(2,1,1);
plot(t,y4);                                   %已调信号通过信道之后的时域谱
title('20db信道后已调信号时域谱');
subplot(2,1,2);
plot(fftshift(Y4));                       %已调信号通过信道之后的频域谱
title('20db信道后已调信号频谱');

%-----------------解调部分---------------------%
y3=amdemod(y2,fc,fs);                           %25db解调
Y3=abs(fft(y3,256));                      %解调信号FFT
[br,pe1]=symerr(y1,y3);
xxx=pe1;
y5=amdemod(y4,fc,fs);                           %20db解调
Y5=abs(fft(y4,256));                      %解调信号FFT

figure(5);
subplot(2,1,1);
plot(t,y3);                               %解调信号时域谱
title('25db解调信号时域谱'); 
subplot(2,1,2);
plot(fftshift(Y3));                         %解调信号频谱.
title('25db解调信号频谱');

figure(7);
subplot(2,1,1);
plot(t,y5);                               %解调信号时域谱
title('20db解调信号时域谱'); 
axis([0 10 -2 2]);
subplot(2,1,2);
plot(fftshift(Y5));                         %解调信号频谱.
title('20db解调信号频谱');

SNR=-10:100;
for i=1:length(SNR) 
    Ynt1=awgn(y1,SNR(i),'measured');            %加入高斯小噪声，信噪比从-10dB到10dB
Z1=amdemod(Ynt1,fc,fs);                 %调用amdemod对加噪声信号进行解调
[br, pe1(i)]=symerr(y1,Z1);             %对解调后加大噪声信号误码分析，br为符号误差数，pe(i)为符号误差率
end
figure(8);
semilogy(SNR,pe1);               % 调用semilogy函数绘制信噪比与误码率的关系曲线
xlabel('信噪比 SNR(r/dB)');
ylabel('误码率 pe');
title('信噪比与误码率的关系');
grid on