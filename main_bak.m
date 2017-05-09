%% 单管漏损检测（2017.5.9）
% 2号节点扩散器系数0.05，漏损量0.5LPS
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
EN_INITSTATUS=4;
EN_INITSETTING=5;
EN_FCV=6;
EN_FLOW=8;
EN_PRESSURE=11;EN_STATUS=11;
EN_SETTING=12;
pressure=0;flow=0;flowChange=0;
% divisor=12;%用于取余数的被除数
% controlTime=60;%控制动作的时间（单位：s）
% position=[ ];
nodeNum=0;tankNum=0;linkNum=0;
% length=0;
time=0;%初始化工况时间（单位：s）
% processTime=0;
% valveCloseTime= 0.02;%阀门关闭时间
tStep=1;
% tStep=0.004;%初始化水力分析的步数，可以是任意非零值（单位：s）
% sampleNum=time/tStep;%采样次数
% sampleNumConst=sampleNum;
% from=0;to=0;%管段的起始位置
% linkNameStr='';
% linkIndex=0;
status=0;
linkID='';
linkType=0;
valveID='';
valveIndex=0;
valveInitFlow=792;
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
%        [errCode,from,to]=calllib('epanetnext','ENgetlinknodes',i,from,to);%获取管的起始位置，确定具体管段
   end
%    [errCode,linkID]=calllib('epanetnext','ENgetlinkid',i,linkID);  %获得管道id
%    linkNameStr=num2str(linkID);
%    [errcode,linkNameStr,linkIndex]=calllib('epanetnext','ENgetlinkindex',linkNameStr,linkIndex);  %获得管道索引
%    [errCode,from,to]=calllib('epanetnext','ENgetlinknodes',linkIndex,from,to);%获取管的起始位置，确定具体管段
%    [errCode,length]=calllib('epanetnext','ENgetlinkvalue',linkIndex,EN_LENGTH,length);%获取管的长度
%    [errCode,status]=calllib('epanetnext','ENgetlinkvalue',linkIndex,EN_STATUS,status);%获取管的开闭状态
%    position(1,i)=linkIndex;
%    position(2,i)=from;
%    position(3,i)=to;
%    position(4,i)=length;
%    position(5,i)=status;
end
%% 执行水力模拟
errCode= calllib('epanetnext','ENopenH');%打开水力分析系统
errCode=calllib('epanetnext','ENinitH',1);%初始化，1是保存水力结果到水力文件
j=1;
while(tStep && ~errCode)
   [errCode,time]=calllib('epanetnext','ENrunH',time);%执行time时刻的水力模拟
%    errCode=calllib('epanetnext','ENsetlinkvalue',valveIndex,EN_SETTING,100);%检测阀门的实际状态
   %    [errCode,flow]=calllib('epanetnext','ENgetlinkvalue',valveIndex,EN_FLOW,flow);%检测管段中的流量
 %%测试代码
%    linkType=0;]=calllib('epanetnext','ENgetlinktype',valveIndex,linkType);%获取管道类型，判断是否是阀门,6为FCV流量控制阀
%    [errCode,status]=
%    [errCode,linkTypecalllib('epanetnext','ENgetlinkvalue',valveIndex,EN_STATUS,status);%检测阀门的实际状态
%    status=0;
%    [errCode,status]=calllib('epanetnext','ENgetlinkvalue',valveIndex,EN_SETTING,status);%检测阀门的实际状态
%%测试代码结束
%     errCode=calllib('epanetnext','ENsetcontrol',1,EN_TIMER,valveIndex,100,0,controlTime);%设置阀门的初始状态流量设为100LPS
   for i=1:junctionNum
      [errCode,pressure]=calllib('epanetnext','ENgetnodevalue',i,EN_PRESSURE,pressure); 
      pressureValue(i,j)=roundn(pressure,-4);
   end
  
   [errCode,flow]=calllib('epanetnext','ENgetlinkvalue',valveIndex,EN_FLOW,flow);%检测管段中的流量
   valveFlow(1,j)=roundn(flow,-2);
   j=j+1;
%    %调用控制语句
%    if j==14
%        errCode=calllib('epanetnext','ENsetcontrol',rem(j,divisor),EN_TIMER,valveIndex,60,0,controlTime);
%    elseif j==15
%        errCode=calllib('epanetnext','ENsetcontrol',rem(j,divisor),EN_TIMER,valveIndex,40,0,controlTime);
%    elseif j==16
%        errCode=calllib('epanetnext','ENsetcontrol',rem(j,divisor),EN_TIMER,valveIndex,20,0,controlTime);
%    elseif j==17
%        errCode=calllib('epanetnext','ENsetcontrol',rem(j,divisor),EN_TIMER,valveIndex,0,0,controlTime);
%    end
   
   
%     [errCode,flow]=calllib('epanetnext','ENgetlinkvalue',valveIndex,EN_FLOW,flow);%检测管段中的流量
%  %% 测试代码
% %测试控制管段流量
%     errCode=calllib('epanetnext','ENsetlinkvalue',str2num(valveID),EN_SETTING,flow/2);%设置阀门流量为30
%     [errCode,flowChange]=calllib('epanetnext','ENgetlinkvalue',str2num(valveID),EN_FLOW,flowChange);%检测管段中的流量
% %测试代码结束
%%
%     if(sampleNum<(time/(2*tStep)) && sampleNum>=(time/(2*tStep)-5))
%         %errCode=calllib('epanetnext','EN',4,EN_FLOW,flow);%设置阀门流量随函数变化
%     elseif(sampleNum<(time/(2*tStep)-5))
%         errCode=calllib('epanetnext','ENsetlinkvalue',str2num(valveID),EN_STATUS,CLOSED);%设置阀门状态为关
%     end
%     errCode=calllib('epanetnext','ENnextH',tStep);
     [errCode,tStep]=calllib('epanetnext','ENnextH',tStep);

%     processTime=processTime+tStep;
%     sampleNum=sampleNum-1;
end
errCode=calllib('epanetnext','ENcloseH');%关闭水力分析系统
errCode=calllib('epanetnext','ENclose');%关闭toolkit系统
unloadlibrary('epanetnext');

subplot(1,2,1);
plot(pressureValue(1,:),'r');
hold on;
plot(pressureValue(2,:),'g');
hold on;
plot(pressureValue(3,:),'b');
hold on;
plot(pressureValue(4,:));
legend('节点1','节点2','节点3','节点4');
xlabel('模拟时间/min');
ylabel('节点压力/m');
title('未发生漏损事件时，节点1,2,3,4的时域压力值');
subplot(1,2,2);
plot(pressureValue(7,:));
xlabel('模拟时间/min');
ylabel('节点压力/m');
title('未发生漏损事件时，节点7的时域压力值');
% text(2.5,6,'可任意放');
