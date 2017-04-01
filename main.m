%% 
clear all;
clc;
ErrCode = 0;
NodeNum = 0;   %nodenum是总节点数目，可以赋予任意值，可以赋予任意值
LinkNum = 0;
EN_NODECOUNT = 0;%节点
EN_LINKCOUNT = 2;%管段
EN_BASEDEMAND = 1;
BaseDemand = 0;
Index = 0;
fromnode = 0;
tonode = 0;
%采样频率为250Hz，采样间隔4ms

file = 'frequencyTest.inp';                                       %指定管网输入文件  
%% 打开水力引擎
%获取并建立未监测节点的连续索引（作为自变量），水库，入水口负需水量节点，出水口节点，大表节点，中间校验管道索引
%首先将epanetnext.dll epanetnext.h放到当前工作目录，并同时放入管网输入文件
ErrCode = loadlibrary('epanetnext.dll','epanetnext.h');                     %  用loadlibrary函数， 根据epanetnext.h中的函数定义，加载epanetnext.dll
libfunctions epanetnext -full                                          %  查看epanetnext.dll支持的函数接口
ErrCode = calllib('epanetnext','ENopen',file,'','');                         %  用calllib函数调用EPANET函数库中的ENopen函数
while (ErrCode > 0)
        ErrCode = calllib('epanetnext','ENopen',file,'','');                         %  用calllib函数调用EPANET函数库中的ENopen函数打开需要校核的管网模型
        if(ErrCode)  
            calllib('epanetnext','ENclose');                                       %  如果打开失败，则关闭
            ErrCode = loadlibrary('epanetnext.dll','epanetnext.h');                     % 用loadlibrary函数， 根据epanetnext.h中的函数定义，加载epanetnext.dll
        end
end
%获取节点数目
[ErrCode,NodeNum] = calllib('epanetnext','ENgetcount',EN_NODECOUNT,NodeNum);        %  获取总节点数目，注意获取数值的方式，两边要有相同的参数nodenum，也可以不同
[ErrCode,LinkNum] = calllib('epanetnext','ENgetcount',EN_LINKCOUNT,LinkNum);
[errcode,fromnode,tonode]=calllib('epanetnext','ENgetlinknodes',5,fromnode,tonode);  %获得管道两端节点



for i = 1:LinkNum
 name = num2str(i);
 Index = 1;
[ErrCode,name,Index] = calllib('epanetnext','ENgetnodeindex',name,Index);  %获取节点索引
NodeIndex(i,1) = Index;

linkID='';
[errcode,linkID]=calllib('epanetnext','ENgetlinkid',i,linkID);  %获得管道id
LinkID(i,1)=str2num(linkID);

end

ErrCode = calllib('epanetnext','ENopenH');
%ErrCode = calllib('epanetnext','ENsolveH');
ErrCode = calllib('epanetnext','ENinitH',0);

[ErrCode,result] = calllib('epanetnext','ENrunH',1);
ErrCode = calllib('epanetnext','ENnextH',0);

% for i = 1:NodeNum
% [ErrCode,BaseDemand] = calllib('epanetnext','ENgetnodevalue',EN_BASEDEMAND,i,BaseDemand);
% end

% errcode=calllib('epanetnext','ENsettimeparam',EN_DURATION,0);%单步仿真
% errcode=calllib('epanetnext','ENsettimeparam',EN_HYDSTEP,3600);%步长

 %% 
ErrCode = calllib('epanetnext','ENcloseH');                          %关闭水力引擎，释放内存
ErrCode = calllib('epanetnext','ENclose');                          %关闭文件，释放内存(这里进行关闭，是因为调用下面函数需要重新打开)




































