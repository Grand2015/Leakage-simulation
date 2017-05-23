%% 单管漏损检测（2017.5.23）
% 2号节点扩散器系数0.05
%管段的粗糙系数为100，管径DN600，管长100m

%【待定】
%%采样间隔0.004s，采样时间为2min
%%阀门的关闭时间0.17~0.25s之间（取0.2s）
%%阀门流量同时间的函数：q=-50t+50

clc;
clear;
close all;
%% 定义初始变量
EN_NODECOUNT=0;CLOSED=0;
EN_TANKCOUNT=1;EN_SAVEDATA=1;EN_LENGTH=1;OPEN=1;
EN_LINKCOUNT=2;EN_TIMER=2;
EN_EMITTER=3;
EN_INITSTATUS=4;
EN_INITSETTING=5;
EN_FCV=6;
EN_FLOW=8;
EN_PRESSURE=11;EN_STATUS=11;
EN_SETTING=12;



pressure=0;flow=0;flowChange=0;
nodeNum=0;tankNum=0;linkNum=0;
time=0;%初始化工况时间（单位：s）
tStep=1;
status=0;
linkID='';
linkType=0;
valveID='';
valveIndex=0;
valveInitFlow=792;
emitter_leakage=0;
emitter_demand=0;
% inputFile='leakageSimulation.inp';
% outputFile='leakageSimulation.rpt';
inputFile='PDA_min_DN600.inp';
outputFile='PDA_min_DN600.rpt';
%% 执行水力分析
errCode=loadlibrary('epanetnext.dll','epanetnext.h');%用loadlibrary函数， 根据epanetnext.h中的函数定义，加载epanetnext.dll
libfunctions epanetnext -full%查看epanetnext.dll支持的函数接口
errCode=calllib('epanetnext','ENopen',inputFile,outputFile,'');%用calllib函数调用EPANET函数库中的ENopen函数
while (errCode>0)
        errCode=calllib('epanetnext','ENopen',inputFile,outputFile,'');%用calllib函数调用EPANET函数库中的ENopen函数打开需要校核的管网模型
        if(errCode)  
            calllib('epanetnext','ENclose');%如果打开失败，则关闭
            errCode=loadlibrary('epanetnext.dll','epanetnext.h');%用loadlibrary函数， 根据epanetnext.h中的函数定义，加载epanetnext.dll
        end
end

%获取管段的部分信息
[errCode,nodeNum]=calllib('epanetnext','ENgetcount',EN_NODECOUNT,nodeNum);%获取节点数量
[errCode,tankNum]=calllib('epanetnext','ENgetcount',EN_TANKCOUNT,tankNum);%获取水箱数量
junctionNum=nodeNum-tankNum;%连接点数目等于总节点数目减去水箱数目
[errCode,linkNum]=calllib('epanetnext','ENgetcount',EN_LINKCOUNT,linkNum);%获取管段数量（包含阀门）
%% 锁定阀门
for i=1:linkNum
   errCode=calllib('epanetnext','ENsetlinkvalue',i,EN_INITSTATUS,OPEN);%设置初始时所有管段都为开
   [errCode,linkType]=calllib('epanetnext','ENgetlinktype',i,linkType);%检查管段类型，锁定阀门
   if linkType==EN_FCV
       valveIndex=i;%获取阀门索引
       [errCode,valveID]=calllib('epanetnext','ENgetlinkid',i,valveID);%获取阀门ID
       errCode=calllib('epanetnext','ENsetlinkvalue',i,EN_INITSETTING,valveInitFlow);%设置初始时所有管段都为开
   end
end

% [errCode,emitter_leakage]=calllib('epanetnext','ENgetnodevalue',2,EN_EMITTER,emitter_leakage);
% [errCode,emitter_demand]=calllib('epanetnext','ENgetnodevalue',7,EN_EMITTER,emitter_demand);

%% 执行水力模拟
errCode= calllib('epanetnext','ENopenH');%打开水力分析系统
errCode=calllib('epanetnext','ENinitH',1);%初始化，1是保存水力结果到水力文件
j=1;
while(tStep && ~errCode)
   [errCode,time]=calllib('epanetnext','ENrunH',time);%执行time时刻的水力模拟
   for i=1:junctionNum
      [errCode,pressure]=calllib('epanetnext','ENgetnodevalue',i,EN_PRESSURE,pressure); 
      pressureValueWithoutLeakage(i,j)=roundn(pressure,-4);
   end
   [errCode,flow]=calllib('epanetnext','ENgetlinkvalue',valveIndex,EN_FLOW,flow);%检测管段中的流量
   valveFlowWithoutLeakage(1,j)=roundn(flow,-2);
   j=j+1;
   [errCode,tStep]=calllib('epanetnext','ENnextH',tStep);
end
errCode=calllib('epanetnext','ENcloseH');%关闭水力分析系统
errCode=calllib('epanetnext','ENclose');%关闭toolkit系统
unloadlibrary('epanetnext');
%% 漏损情况下

pressure=0;flow=0;flowChange=0;
nodeNum=0;tankNum=0;linkNum=0;
time=0;%初始化工况时间（单位：s）
tStep=1;
status=0;
linkID='';
linkType=0;
valveID='';
valveIndex=0;
valveInitFlow=792;
emitter_leakage=0;
emitter_demand=0;
% inputFile='leakageSimulation.inp';
% outputFile='leakageSimulation.rpt';
inputFile='PDA_min_DN600.inp';
outputFile='PDA_min_DN600.rpt';
%% 执行水力分析
errCode=loadlibrary('epanetnext.dll','epanetnext.h');%用loadlibrary函数， 根据epanetnext.h中的函数定义，加载epanetnext.dll
libfunctions epanetnext -full%查看epanetnext.dll支持的函数接口
errCode=calllib('epanetnext','ENopen',inputFile,outputFile,'');%用calllib函数调用EPANET函数库中的ENopen函数
while (errCode>0)
        errCode=calllib('epanetnext','ENopen',inputFile,outputFile,'');%用calllib函数调用EPANET函数库中的ENopen函数打开需要校核的管网模型
        if(errCode)  
            calllib('epanetnext','ENclose');%如果打开失败，则关闭
            errCode=loadlibrary('epanetnext.dll','epanetnext.h');%用loadlibrary函数， 根据epanetnext.h中的函数定义，加载epanetnext.dll
        end
end

%获取管段的部分信息
[errCode,nodeNum]=calllib('epanetnext','ENgetcount',EN_NODECOUNT,nodeNum);%获取节点数量
[errCode,tankNum]=calllib('epanetnext','ENgetcount',EN_TANKCOUNT,tankNum);%获取水箱数量
junctionNum=nodeNum-tankNum;%连接点数目等于总节点数目减去水箱数目
[errCode,linkNum]=calllib('epanetnext','ENgetcount',EN_LINKCOUNT,linkNum);%获取管段数量（包含阀门）
%% 锁定阀门
for i=1:linkNum
   errCode=calllib('epanetnext','ENsetlinkvalue',i,EN_INITSTATUS,OPEN);%设置初始时所有管段都为开
   [errCode,linkType]=calllib('epanetnext','ENgetlinktype',i,linkType);%检查管段类型，锁定阀门
   if linkType==EN_FCV
       valveIndex=i;%获取阀门索引
       [errCode,valveID]=calllib('epanetnext','ENgetlinkid',i,valveID);%获取阀门ID
       errCode=calllib('epanetnext','ENsetlinkvalue',i,EN_INITSETTING,valveInitFlow);%设置初始时所有管段都为开
   end
end

[errCode,emitter_leakage]=calllib('epanetnext','ENgetnodevalue',2,EN_EMITTER,emitter_leakage);
errCode=calllib('epanetnext','ENsetnodevalue',2,EN_EMITTER,0.05);

[errCode,emitter_leakage]=calllib('epanetnext','ENgetnodevalue',2,EN_EMITTER,emitter_leakage);

% [errCode,emitter_demand]=calllib('epanetnext','ENgetnodevalue',7,EN_EMITTER,emitter_demand);

%% 执行水力模拟
errCode= calllib('epanetnext','ENopenH');%打开水力分析系统
errCode=calllib('epanetnext','ENinitH',1);%初始化，1是保存水力结果到水力文件
j=1;
while(tStep && ~errCode)
   [errCode,time]=calllib('epanetnext','ENrunH',time);%执行time时刻的水力模拟
   for i=1:junctionNum
      [errCode,pressure]=calllib('epanetnext','ENgetnodevalue',i,EN_PRESSURE,pressure); 
      pressureValueWithLeakage(i,j)=roundn(pressure,-4);
   end
   [errCode,flow]=calllib('epanetnext','ENgetlinkvalue',valveIndex,EN_FLOW,flow);%检测管段中的流量
   valveFlowWithLeakage(1,j)=roundn(flow,-2);
   j=j+1;
   [errCode,tStep]=calllib('epanetnext','ENnextH',tStep);
end
errCode=calllib('epanetnext','ENcloseH');%关闭水力分析系统
errCode=calllib('epanetnext','ENclose');%关闭toolkit系统
unloadlibrary('epanetnext');


for i=1:32
    data(1,i)=pressureValueWithoutLeakage(1,i);
    dataLeakage(1,i)=pressureValueWithLeakage(1,i);
end


Fs=1000;
subplot(3,1,1);
t=0:1/Fs:1;
plot(1000*t(1:32),data(1:32),'g');
hold on;
plot(1000*t(1:32),dataLeakage(1:32),'r');
xlabel('time(mm)');
title('一元时间序列直观图');

Y=fft(data,512);
Pyy=Y.*conj(Y)/512;
f=1000*(0:256)/512;

YLeakage=fft(dataLeakage,512);
PyyLeakage=YLeakage.*conj(YLeakage)/512;
fLeakage=1000*(0:256)/512;

subplot(3,1,2);
plot(f,Pyy(1:257),'g');
hold on;
plot(fLeakage,PyyLeakage(1:257),'r');
title('离散数据的傅立叶频谱图');
xlabel('频率（Hz）');

Fs=1000;
NFFT=1024;
Cx=xcorr(data,'unbiased');
Cxk=fft(Cx,NFFT);
Pxx=abs(Cxk);

CxLeakage=xcorr(dataLeakage,'unbiased');
CxkLeakage=fft(CxLeakage,NFFT);
PxxLeakage=abs(CxkLeakage);

t=0:round(NFFT/2-1);
k=t*Fs/NFFT;
P=10*log10(Pxx(t+1));
PLeakage=10*log10(PxxLeakage(t+1));
subplot(3,1,3);
plot(k,P,'g');
hold on;
plot(k,PLeakage,'r');
title('谱估计的自相关函数法');
xlabel('频率（Hz）');





% figure(1);
% Fs=1000;
% subplot(3,1,1);
% t=0:1/Fs:1;
% plot(1000*t(1:32),data(1:32));
% xlabel('time(mm)');
% title('一元时间序列直观图');
% 
% Y=fft(data,512);
% Pyy2=Y.*conj(Y)/512;
% f2=1000*(0:256)/512;
% subplot(3,1,2);
% plot(f2,Pyy2(1:257));
% title('离散数据的傅立叶频谱图');
% xlabel('频率（Hz）');
% 
% Fs=1000;
% NFFT=1024;
% Cx=xcorr(data,'unbiased');
% Cxk=fft(Cx,NFFT);
% Pxx=abs(Cxk);
% t=0:round(NFFT/2-1);
% k=t*Fs/NFFT;
% P=10*log10(Pxx(t+1));
% subplot(3,1,3);
% plot(k,P);
% title('谱估计的自相关函数法');
% xlabel('频率（Hz）');
% 
% figure(2);
% subplot(1,2,1);
% plot(pressureValue(1,:),'r');
% hold on;
% plot(pressureValue(2,:),'g');
% hold on;
% plot(pressureValue(3,:),'b');
% hold on;
% plot(pressureValue(4,:));
% legend('节点1','节点2','节点3','节点4');
% xlabel('模拟时间/min');
% ylabel('节点压力/m');
% title('未发生漏损事件时，节点1,2,3,4的时域压力值');
% subplot(1,2,2);
% plot(pressureValue(7,:));
% xlabel('模拟时间/min');
% ylabel('节点压力/m');
% title('未发生漏损事件时，节点7的时域压力值');

