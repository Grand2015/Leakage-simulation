%% 单管漏损检测
%3号节点扩散器系数0.5，漏损量5LPS
%管段的粗糙系数为100
%采样间隔0.004s，采样时间为2min
%阀门的关闭时间0.17~0.25s之间（取0.2s）
%阀门流量同时间的函数：q=-50t+50
clc;
clear all;
close all;
%% 定义初始变量
EN_NODECOUNT=0;CLOSED=0;
EN_TANKCOUNT=1;EN_SAVEDATA=1;EN_LENGTH=1;OPEN=1;
EN_LINKCOUNT=2;EN_TIMER=2;
EN_INITSETTING=5;
EN_FCV=6;
EN_FLOW=8;
EN_PRESSURE=11;EN_STATUS=11;
EN_SETTING=12;
pressure=0;flow=0;flowChange=0;
divisor=12;%用于取余数的被除数
controlTime=60;%控制动作的时间（单位：s）
% position=[ ];
nodeNum=0;%节点数目
tankNum=0;%水箱数目
linkNum=0;%管段数目
% length=0;
time=0;%初始化工况时间（单位：s）
% processTime=0;
valveCloseTime= 0.02;%阀门关闭时间
tStep=1;
% tStep=0.004;%初始化水力分析的步数，可以是任意非零值（单位：s）
sampleNum=time/tStep;%采样次数
sampleNumConst=sampleNum;
% from=0;to=0;%管段的起始位置
% linkNameStr='';
% linkIndex=0;
status=0;
linkID='';
linkType=0;%管段类型
valveID='';%阀门ID
valveIndex=0;%阀门索引
inputFile='leakageSimulation.inp';%EPANET输入文件
outputFile='leakageSimulation.rpt';%输出文件
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
[errCode,linkNum]=calllib('epanetnext','ENgetcount',EN_LINKCOUNT,linkNum);%获取管段数量
%% 测试代码：通过索引获得ID，通过ID获得索引
% name='5';
% [errCode,name,linkIndex]=calllib('epanetnext','ENgetlinkindex',name,linkIndex);
% [errCode,linkID]=calllib('epanetnext','ENgetnodeid',3,linkID);
%测试代码结束
%% 
for i=1:linkNum
   [errcode,linkType]=calllib('epanetnext','ENgetlinktype',i,linkType);%检查管段类型，锁定阀门
   if linkType==EN_FCV
       valveIndex=i;%获取阀门索引
       [errCode,valveID]=calllib('epanetnext','ENgetlinkid',i,valveID);%获取阀门ID
%        [errCode,from,to]=calllib('epanetnext','ENgetlinknodes',i,from,to);%获取管的起始位置，确定具体管段
   end
   errCode=calllib('epanetnext','ENsetlinkvalue',i,EN_INITSETTING,OPEN);%设置初始时所有管段都为开
end

errCode= calllib('epanetnext','ENopenH');%打开水力分析系统
errCode=calllib('epanetnext','ENinitH',0);%初始化，1是保存水力结果到水力文件

%% 测试代码
%测试控制阀门开关
% errCode=calllib('epanetnext','ENsetlinkvalue',valveIndex,EN_STATUS,CLOSED);%关闭阀门
% [errCode,status]=calllib('epanetnext','ENgetlinkvalue',valveIndex,EN_STATUS,status);%获取管的开闭状态
% errCode=calllib('epanetnext','ENsetlinkvalue',valveIndex,EN_STATUS,OPEN);%打开阀门
%测试控制管段流量

%测试代码结束
%% 
j=1;
while(tStep && ~errCode)
   [errCode,time]=calllib('epanetnext','ENrunH',time);%执行time时刻的水力模拟
   
%     errCode=calllib('epanetnext','ENsetcontrol',1,EN_TIMER,valveIndex,100,0,controlTime);%设置阀门的初始状态流量设为100LPS
   for i=1:junctionNum
      [errCode,pressure]=calllib('epanetnext','ENgetnodevalue',i,EN_PRESSURE,pressure); 
      pressureValue(i,j)=pressure;
   end
   j=j+1;
%    if j==14
%        errCode=calllib('epanetnext','ENsetcontrol',rem(j,divisor),EN_TIMER,valveIndex,60,0,controlTime);
%    elseif j==15
%        errCode=calllib('epanetnext','ENsetcontrol',rem(j,divisor),EN_TIMER,valveIndex,40,0,controlTime);
%    elseif j==16
%        errCode=calllib('epanetnext','ENsetcontrol',rem(j,divisor),EN_TIMER,valveIndex,20,0,controlTime);
%    elseif j==17
%        errCode=calllib('epanetnext','ENsetcontrol',rem(j,divisor),EN_TIMER,valveIndex,0,0,controlTime);
%    end
     [errCode,tStep]=calllib('epanetnext','ENnextH',tStep);
end
errCode=calllib('epanetnext','ENcloseH');%关闭水力分析系统
errCode=calllib('epanetnext','ENclose');%关闭toolkit系统
unloadlibrary('epanetnext');

% plot(pressureValue(1,:),'g');
% hold on;
% plot(pressureValue(2,:),'b');
% hold on;
% plot(pressureValue(3,:));
% hold on;
% plot(pressureValue(4,:),'r');

