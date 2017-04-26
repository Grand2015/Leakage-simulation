%% 测试代码：通过索引获得ID，通过ID获得索引
% name='5';
% [errCode,name,linkIndex]=calllib('epanetnext','ENgetlinkindex',name,linkIndex);
% [errCode,linkID]=calllib('epanetnext','ENgetnodeid',3,linkID);
%测试代码结束

%% 测试代码
%测试控制阀门开关
% errCode=calllib('epanetnext','ENsetlinkvalue',valveIndex,EN_STATUS,CLOSED);%关闭阀门
% [errCode,status]=calllib('epanetnext','ENgetlinkvalue',valveIndex,EN_STATUS,status);%获取管的开闭状态
% errCode=calllib('epanetnext','ENsetlinkvalue',valveIndex,EN_STATUS,OPEN);%打开阀门
%测试控制管段流量
%测试代码结束