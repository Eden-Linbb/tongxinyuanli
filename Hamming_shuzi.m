%--------------------基本设置-----------------%
clear;close all; clc
t=1/360:1/360:20;                       %载波持续时间设置
Fc=36;                                  %载波信号频率
Fd=20;                                  %码速率
Fs=360;                                 %抽样频率
carry=cos(2*pi*Fc*t);                   %载波表达式
x1=ceil(rand(1,1000)-0.5);              %生成二进制消息
a=num2str(x1);                          %矩阵变成字符
b=strrep(a, ' ', '');                   %去掉字符中的空格
figure(1);
subplot(2,1,1);
plot(x1);
title('消息');
axis([0 50 0 1]);
subplot(2,1,2);
plot(t,carry);
title('载波信息');xlabel('时间/s');ylabel('幅度');
axis([0 0.2 -1 1]);

%-------------------信道编码部分---------------%

%---------------------汉明码-------------------%
n=7;                                    %Hamming码组长度n=2^m-1,4  (7,4)汉明码
m=3;                                    %监督位长度
[H,G]=hammgen(m);                       %产生(n,n-m)Hamming码的生成矩阵和校验矩阵
x=reshape(x1,[],4);                     %调整矩阵行列
y1=mod(x*G,2);                          %产生编码数据
%---------------------循环码-------------------%
n1=7;k=4;                               %(3,2)循环码
pol=cyclpoly(n1,k);                     %循环码的生成多项式
[h,g]=cyclgen(n1,pol);                  %生成循环码
y2 = mod(x*g,2);                        %产生编码数据
%---------------------画出编码之后的图形--------%
figure(2);
subplot(2,1,1);
plot(y1);
title('汉明码');
axis([0 50 0 2]);
subplot(2,1,2);
plot(y2);
title('循环码');
axis([0 50 0 2]);

%-----------------数字调制部分-----------------%
%------------------2ASK调制--------------------%
code1=dmod(y1,Fc,Fd,Fs,'ask',2);         %汉明码 2ASK调制
code3=dmod(y2,Fc,Fd,Fs,'ask',2);         %循环码 2ASK调制
for i=1:20                               %手动调节 2ASK部分 调节信号为 汉明码2ASK信号
    if y1(i)==0
        code11(30*(i-1)+1:30*i)=0;
    else
        code11(30*(i-1)+1:30*i)=code1(30*(i-1)+1:30*i);
    end
end
for i=1:20                               %手动调节 2ASK部分 调节信号为 循环码2ASK信号
    if y2(i)==0
        code33(30*(i-1)+1:30*i)=0;
    else
        code33(30*(i-1)+1:30*i)=code3(30*(i-1)+1:30*i);
    end
end
figure(3);
subplot(2,1,1);
plot(code11);
title('汉明码 2ASK调制');
subplot(2,1,2);
plot(code33);
title('循环码 2ASK调制');
%------------------2FSK调制--------------------%
code2=dmod(y2,Fc,Fd,Fs,'fsk',2);         %循环码 2FSK调制
code4=dmod(y1,Fc,Fd,Fs,'fsk',2);         %汉明码 2FSK调制
figure(4);
subplot(2,1,1);
plot(code4);
title('汉明码 2FSK调制');
axis([0 50 -2 2]);
subplot(2,1,2);
plot(code2);
title('循环码 2FSK调制');
axis([0 50 -2 2]);

%---------------------信道部分-----------------%
%               采用信噪比为20db的信道          %
s1=awgn(code1,20,'measured');            %汉明编码后经过2ASK调制信号通过20信噪比信道
s2=awgn(code2,20,'measured');            %循环编码后经过2FSK调制信号通过20信噪比信道
s3=awgn(code3,20,'measured');            %循环编码后经过2ASK调制信号通过20信噪比信道
s4=awgn(code4,20,'measured');            %汉明编码后经过2FSK调制信号通过20信噪比信道
figure(6)
subplot(4,1,1);
plot(s1);
title('汉明码2ASK信号 通过20db信道');
axis([0 50 -2 2]);
subplot(4,1,2);
plot(s2)
title('循环码 2FSK信号通过20db信道');
axis([0 50 -2 2]);
subplot(4,1,3);
plot(s3)
title('循环码 2ASK信号通过20db信道');
axis([0 50 -2 2]);
subplot(4,1,4);
plot(s4)
title('汉明码 2FSK信号通过20db信道');
axis([0 50 -2 2]);

%----------------数字解调部分-------------------%
znt1=ddemod(s1,Fc,Fd,Fs,'ask',2);        %对汉明编码后经过2ASK调制信号通过20信噪比信道 进行解调
znt2=ddemod(s2,Fc,Fd,Fs,'fsk',2);        %对循环编码后经过2fSK调制信号通过20信噪比信道 进行解调
znt3=ddemod(s3,Fc,Fd,Fs,'ask',2);        %对循环编码后经过2ASK调制信号通过20信噪比信道 进行解调
znt4=ddemod(s4,Fc,Fd,Fs,'fsk',2);        %对汉明编码后经过2fSK调制信号通过20信噪比信道 进行解调
figure(7)
subplot(4,1,1);
plot(znt1);
title('汉明码2ASK信号解调');
axis([0 50 0 1]);
subplot(4,1,2);
plot(znt2);
title('循环码2FSK信号解调');
axis([0 50 0 1]);
subplot(4,1,3);
plot(znt3);
title('循环码2ASK信号解调');
axis([0 50 0 1]);
subplot(4,1,4);
plot(znt4);
title('汉明码2FSK信号解调');
axis([0 50 0 1]);

%-------------------译码部分--------------------%
newmsg1 = decode(znt1,n,k);              % 对解调后的2ask信号进行汉明译码.
newmsg2 = decode(znt2,n1,k,'cyclic');    % 对解调后的2fsk信号进行循环译码.
newmsg3 = decode(znt3,n1,k,'cyclic');    % 对解调后的2ask信号进行循环译码.
newmsg4 = decode(znt4,n,k);              % 对解调后的2fsk信号进行汉明译码.
figure(8)
subplot(4,1,1);
plot(newmsg1);
title('汉明码2ASK解调译码信号');
axis([0 50 0 1]);
subplot(4,1,2);
plot(newmsg2);
title('循环码2FSK解调译码信号');
axis([0 50 0 1]);
subplot(4,1,3);
plot(newmsg3);
title('循环码2ASK解调译码信号');
axis([0 50 0 1]);
subplot(4,1,4);
plot(newmsg4);
title('汉明码2FSK解调译码信号');
axis([0 50 0 1]);

%----------------误码率分析部分-----------------%
SNR=-10:10;
for i=1:length(SNR) 
    Ynt1=awgn(code1,SNR(i));            %加入高斯小噪声，信噪比从-10dB到10dB
    Ynt2=awgn(code2,SNR(i));
    Ynt3=awgn(code3,SNR(i));
    Ynt4=awgn(code4,SNR(i));
Z1=ddemod(Ynt1,Fc,Fd,Fs,'ask',2);       %调用数字带通解调函数ddemod对加噪声信号进行解调
[br, pe1(i)]=symerr(y1,Z1);             %对解调后加大噪声信号误码分析（汉明码编码，2ask误码率分析），br为符号误差数，pe(i)为符号误差率
Z2=ddemod( Ynt2,Fc,Fd,Fs,'fsk',2);      %对解调后大噪声信号误码分析（循环码编码，2fsk误码率分析）
[br, pe2(i)]=symerr(y2,Z2);             
Z3=ddemod(Ynt3,Fc,Fd,Fs,'ask',2);       %对解调后大噪声信号误码分析（循环码编码，2ask误码率分析）
[br, pe3(i)]=symerr(y2,Z3); 
Z4=ddemod(Ynt4,Fc,Fd,Fs,'fsk',2);       %对解调后大噪声信号误码分析（汉明码编码，2fsk误码率分析）
[br, pe4(i)]=symerr(y1,Z4); 
end
%---------画出不同方式下信噪比与误码率关系------%
figure(5);
semilogy(SNR,pe1,'k--o');               % 调用semilogy函数绘制”汉明码编码2ask“信噪比与误码率的关系曲线
hold on
semilogy(SNR,pe2,'c--+');                 % 调用semilogy函数绘制“循环码编码2fsk”信噪比与误码率的关系曲线
semilogy(SNR,pe3,'--');               % 调用semilogy函数绘制”循环码编码2ask“信噪比与误码率的关系曲线
semilogy(SNR,pe4,'r--*');               % 调用semilogy函数绘制“汉明码编码2fsk”信噪比与误码率的关系曲线
hold off
legend('汉明码2ASK','循环码2FSK','循环码2ASK','汉明码2FSK');
xlabel('信噪比 SNR(r/dB)');
ylabel('误码率 pe');
title('信噪比与误码率的关系');
axis([-10 10 0 0.5])   
grid on