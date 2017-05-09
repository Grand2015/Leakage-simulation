%%  傅立叶变换、自相关函数法、最大熵估计三种方法，将时域的数据转换到频域上进行分析
clc;
clear;
close all;

n=0:0.001:1;
% data=[ ];
A1=4;A2=4;f1=25;f2=50;pi=3.14;
X=A1*sin(f1*2*pi*n)+A2*sin(f2*2*pi*n);
data=X+10*rand(size(X));

Fs=1000;
subplot(3,1,1);
t=0:1/Fs:1;
plot(1000*t(1:50),data(1:50));
xlabel('time(mm)');
title('一元时间序列直观图');

Y=fft(data,512);
Pyy2=Y.*conj(Y)/512;
f2=1000*(0:256)/512;
subplot(3,1,2);
plot(f2,Pyy2(1:257));
title('离散数据的傅立叶频谱图');
xlabel('频率（Hz）');

 

Fs=1000;
NFFT=1024;
Cx=xcorr(data,'unbiased');
Cxk=fft(Cx,NFFT);
Pxx=abs(Cxk);
t=0:round(NFFT/2-1);
k=t*Fs/NFFT;
P=10*log10(Pxx(t+1));
subplot(3,1,3);
plot(k,P);
title('谱估计的自相关函数法')
xlabel('频率（Hz）')


Fs=500;
NFFT=1024;
pyulear(data,20,NFFT,Fs);
