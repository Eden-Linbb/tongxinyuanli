clc;clear;close all
n = 3; k = 2;               % A (3,2) 循环码
N=10000;                    %消息比特的行数
%cyclgen
msg = randi([0,1],N,k);         %消息比特共N*k行
pol=cyclpoly(n,k);          %循环码的生成多项式
[h,g]=cyclgen(n,pol);       %生成循环码
code1 = mod(msg*g,2);
noisy=randerr(N,n,[0 1;0.7 0.3]);           %噪声
noisycode1 = mod(code1 + noisy,2);      %加入噪声
newmsg1 = decode(noisycode1,n,k,'cyclic'); % 译码.
 [number,ratio1] = biterr(newmsg1,msg); %误比特率
disp(['The bit error rate1 is ',num2str(ratio1)])

%encode         
msg1 = randi([0,1],N,k,'like',msg);         %消息比特共N*k行
code2 = encode(msg1,n,k,'cyclic');
noisy1=randerr(N,n,[0 1;0.7 0.3]);           %噪声
noisycode2 = mod(code2 + noisy1,2);      %加入噪声
newmsg2 = decode(noisycode2,n,k,'cyclic'); % 译码.
 [number,ratio2] = biterr(newmsg2,msg1); %误比特率
disp(['The bit error rate2 is ',num2str(ratio2)])