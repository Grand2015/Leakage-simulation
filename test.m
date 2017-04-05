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
EN_LINKCOUNT=2;
EN_INITSETTING=5;
EN_FCV=6;
EN_FLOW=8;
EN_PRESSURE=11;EN_STATUS=11;
EN_SETTING=12;
pressure=0;flow=0;errCode=0;
nodeNum=0;%节点数目
tankNum=0;%水箱数目
linkNum=0;%管段数目
time=0;%初始化工况时间
tStep=1;
inputFile='leakageSimulation.inp';%EPANET输入文件
outputFile='leakageSimulation.rpt';%输出文件
%% 执行水力分析
errCode=loadlibrary('epanetnext.dll','epanetnext.h');%用loadlibrary函数， 根据epanetnext.h中的函数定义，加载epanetnext.dll
% libfunctions epanetnext -full%查看epanetnext.dll支持的函数接口
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

errCode=calllib('epanetnext','ENopenH');%打开水力分析系统
errCode=calllib('epanetnext','ENinitH',0);%初始化，1是保存水力结果到水力文件
j=1;
while(tStep && ~errCode)
   [errCode,time]=calllib('epanetnext','ENrunH',time);%执行time时刻的水力模拟
   for i=1:junctionNum
      [errCode,pressure]=calllib('epanetnext','ENgetnodevalue',i,EN_PRESSURE,pressure); 
      pressureValue(i,j)=pressure;
   end
   j=j+1;
   [errCode,tStep]=calllib('epanetnext','ENnextH',tStep);
end
errCode=calllib('epanetnext','ENcloseH');%关闭水力分析系统
errCode=calllib('epanetnext','ENclose');%关闭toolkit系统
unloadlibrary('epanetnext');



