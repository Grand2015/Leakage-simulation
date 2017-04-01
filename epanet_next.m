function fitness=epanet_next(position,searchlink,abnormalID,starttime,StartSimMin,para)
%% function epanet_next(starttime,StartSimMin,para)
EN_DURATION=0;EN_ELEVATION=0;EN_BASEDEMAND=1;EN_PATTERN=2;EN_PATTERNSTEP=3;EN_PATTERNSTART=4;EN_TANKLEVEL=8;EN_FLOW=8;EN_DEMAND=9;EN_HEAD=10;EN_PRESSURE=11;
EN_FLOW=8;EN_STATUS=11;

EN_HYDSTEP=1;
CLOSE=0;
OPEN=1;
%% 定义变量
number=0;
tstep=1;
tempvalue=0;
x=0;
errcode=0;
Index=0;
f1=0;
f2=0;
name=num2str(abnormalID);
[errcode,name,Index]=calllib('epanetnext','ENgetlinkindex',name,Index); 
%% 阀门设定
errcode=calllib('epanetnext','ENinitH',0);                      %默认参数初始化，恢复管网初始状态      %初始化贮水池水位，管道状态和设置以及模拟时间，0表示不存储二进制水力结果                 
col=length(position);
for i=1:col
   if position(i)==1 %position位置为1
      errcode=calllib('epanetnext','ENsetlinkvalue',searchlink(i,3),EN_STATUS,CLOSE); %设置阀门关闭
%    else
%       errcode=calllib('epanetnext','ENsetlinkvalue',searchlink(i,3),EN_STATUS,OPEN); %获取仿真流量向量 
   end
end
%% 
%time=starttime+StartSimMin-1464883200;%求2016-6-3时间点（时分秒）注：2016-6-3=1464883200
time=starttime+StartSimMin-1465056000;
temp=para.SupplyHead{1};
[supplyheadnum,~]=size(temp); 
simnum=supplyheadnum;%初始化水力分析的步数，是反馈参数中水库水头值得个数减去起始仿真分钟数,1代表爆管后一分钟开始，数据也最多是从爆管后一分钟开始的

%对于反馈量x，对应节点都有原先模式，需要重设模式(新的模式模式乘子全为1)，并在仿真结束后恢复模式，保证下一次仿真来之前，之前的节点是正常情况下的模式

num=1;
tstep=0;
pressure={0};
flow={0};
Value_Cell=cell(simnum,1);
while(num<=simnum)
 %设定参数
  SetFeedBack(time,num,para); 
  %默认参数初始化
  errcode=calllib('epanetnext','ENinitH',0);                         %初始化贮水池水位，管道状态和设置以及模拟时间，0表示不存储二进制水力结果
  %运行仿真
  [errcode,time]=calllib('epanetnext','ENrunH',time);      %执行在time时刻的水力分析
  [errcode,tempvalue]=calllib('epanetnext','ENgetlinkvalue',Index,EN_FLOW,tempvalue); %获取仿真流量向量 
  f1=floor(abs(tempvalue));          %sim data
  [errcode,tstep]=calllib('epanetnext','ENnextH',tstep);
  num=num+1;
% pause(0.01);%注意，这里暂停一段时间（0.1ms）可以防止epanet内核运行崩溃
end
    %Validotor_Value{k,1}=Value_Cell;
f2=sum(position);
fitness=[f1
         f2];