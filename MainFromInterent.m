%% 单管漏损检测
%扩散器系数0.5，漏损量5LPS
%管段的粗糙系数为100
%采样间隔0.004s，采样时间为2min
%阀门的关闭时间0.17~0.25s之间（取0.2s）
%阀门流量同时间的函数：q=-50t+50
clc;
clear all;
close all;
%% 定义初始变量
EN_NODECOUNT=0;EN_TANKCOUNT=1;EN_SAVEDATA=1;EN_PRESSURE=11;EN_FLOW=8;
EN_INITSETTING=5;EN_SETTING=12;EN_LINKCOUNT=2;EN_LENGTH=1;EN_STATUS=11;
OPEN=1;CLOSED=0;
pressure=0;flow=0;position=[ ];flowChange=0;
nodeNum=0;%节点数目
tankNum=0;%水箱数目
linkNum=0;%管段数目
length=0;
time=120;%初始化工况时间（单位：s）
processTime=0;
valveCloseTime= 0.02;%阀门关闭时间
tStep=0.004;%初始化水力分析的步数，可以是任意非零值（单位：s）
sampleNum=time/tStep;%采样次数
sampleNumConst=sampleNum;
from=0;to=0;%管段的起始位置
linkNameStr='';
linkIndex=0;
status=0;
valveID='4';%阀门ID
%% 执行水力分析
errCode=loadlibrary('epanetnext.dll','epanetnext.h');%加载epanet文件
errCode=calllib('epanetnext','ENopen','frequencyTest.inp','frequencyTest.rpt','');%打开inp文件，创建rpt报告文件

[errCode,nodeNum]=calllib('epanetnext','ENgetcount',EN_NODECOUNT,nodeNum);%获取节点数量
[errCode,tankNum]=calllib('epanetnext','ENgetcount',EN_TANKCOUNT,tankNum);%获取水箱数量
junctionNum=nodeNum-tankNum;%连接点数目等于总节点数目减去水箱数目
[errCode,linkNum]=calllib('epanetnext','ENgetcount',EN_LINKCOUNT,linkNum);%获取管段数量
% [errCode,linkNum]=calllib('epanetnext','ENgetcount',EN_NODECOUNT,linkNum);%获取管段数量

errCode= calllib('epanetnext','ENopenH');%打开水力分析系统
errCode=calllib('epanetnext','ENinitH',EN_SAVEDATA);%初始化，1是保存水力结果到水力文件
for i=1:linkNum
   linkNameStr=num2str(i);
   errCode=calllib('epanetnext','ENsetlinkvalue',i,EN_INITSETTING,OPEN);%设置初始时所有管段都为开
   [errcode,linkNameStr,linkIndex]=calllib('epanetnext','ENgetlinkindex',linkNameStr,linkIndex);  %获得管道索引
   [errCode,from,to]=calllib('epanetnext','ENgetlinknodes',linkIndex,from,to);%获取管的起始位置，确定具体管段
   [errCode,length]=calllib('epanetnext','ENgetlinkvalue',i,EN_LENGTH,length);%获取管的长度
   [errCode,status]=calllib('epanetnext','ENgetlinkvalue',i,EN_STATUS,status);%获取管的开闭状态
   position(1,i)=i;
   position(2,i)=from;
   position(3,i)=to;
   position(4,i)=length;
   position(5,i)=status;
end
%% 测试代码
%测试控制阀门开关
errCode=calllib('epanetnext','ENsetlinkvalue',str2num(valveID),EN_STATUS,CLOSED);%关闭阀门
[errCode,status]=calllib('epanetnext','ENgetlinkvalue',str2num(valveID),EN_STATUS,status);%获取管的开闭状态
errCode=calllib('epanetnext','ENsetlinkvalue',str2num(valveID),EN_STATUS,OPEN);%打开阀门
%测试控制管段流量

%测试代码结束
%% 
while(sampleNum && ~errCode)
   errCode=calllib('epanetnext','ENrunH',processTime);%执行processTime时刻的水力模拟
   for i=1:junctionNum
      [errCode,pressure]=calllib('epanetnext','ENgetnodevalue',i,EN_PRESSURE,pressure); 
      pressureValue(i,(sampleNumConst+1-sampleNum))=pressure;
   end
    [errCode,flow]=calllib('epanetnext','ENgetlinkvalue',str2num(valveID),EN_FLOW,flow);%检测管段中的流量
 %% 测试代码
%测试控制管段流量
    errCode=calllib('epanetnext','ENsetlinkvalue',str2num(valveID),EN_SETTING,flow/2);%设置阀门流量为30
    [errCode,flowChange]=calllib('epanetnext','ENgetlinkvalue',str2num(valveID),EN_FLOW,flowChange);%检测管段中的流量
%测试代码结束
%%
    if(sampleNum<(time/(2*tStep)) && sampleNum>=(time/(2*tStep)-5))
        %errCode=calllib('epanetnext','EN',4,EN_FLOW,flow);%设置阀门流量随函数变化
    elseif(sampleNum<(time/(2*tStep)-5))
        %errCode=calllib('epanetnext','ENsetlinkvalue',str2num(valveID),EN_STATUS,0);%设置阀门流量为0
        errCode=calllib('epanetnext','ENsetlinkvalue',str2num(valveID),EN_STATUS,CLOSED);%设置阀门状态为关
    end
    errCode=calllib('epanetnext','ENnextH',tStep);
    processTime=processTime+tStep;
    sampleNum=sampleNum-1;
end
errCode=calllib('epanetnext','ENcloseH');%关闭水力分析系统
errCode=calllib('epanetnext','ENclose');%关闭toolkit系统
unloadlibrary('epanetnext');

plot(pressureValue(1,:),'g');
% hold on;
% plot(pressureValue(2,:),'b');
% hold on;
% plot(pressureValue(3,:));
% hold on;
% plot(pressureValue(4,:),'r');

