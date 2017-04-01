function fitness=epanet_next(position,searchlink,abnormalID,starttime,StartSimMin,para)
%% function epanet_next(starttime,StartSimMin,para)
EN_DURATION=0;EN_ELEVATION=0;EN_BASEDEMAND=1;EN_PATTERN=2;EN_PATTERNSTEP=3;EN_PATTERNSTART=4;EN_TANKLEVEL=8;EN_FLOW=8;EN_DEMAND=9;EN_HEAD=10;EN_PRESSURE=11;
EN_FLOW=8;EN_STATUS=11;

EN_HYDSTEP=1;
CLOSE=0;
OPEN=1;
%% �������
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
%% �����趨
errcode=calllib('epanetnext','ENinitH',0);                      %Ĭ�ϲ�����ʼ�����ָ�������ʼ״̬      %��ʼ����ˮ��ˮλ���ܵ�״̬�������Լ�ģ��ʱ�䣬0��ʾ���洢������ˮ�����                 
col=length(position);
for i=1:col
   if position(i)==1 %positionλ��Ϊ1
      errcode=calllib('epanetnext','ENsetlinkvalue',searchlink(i,3),EN_STATUS,CLOSE); %���÷��Źر�
%    else
%       errcode=calllib('epanetnext','ENsetlinkvalue',searchlink(i,3),EN_STATUS,OPEN); %��ȡ������������ 
   end
end
%% 
%time=starttime+StartSimMin-1464883200;%��2016-6-3ʱ��㣨ʱ���룩ע��2016-6-3=1464883200
time=starttime+StartSimMin-1465056000;
temp=para.SupplyHead{1};
[supplyheadnum,~]=size(temp); 
simnum=supplyheadnum;%��ʼ��ˮ�������Ĳ������Ƿ���������ˮ��ˮͷֵ�ø�����ȥ��ʼ���������,1�����ܺ�һ���ӿ�ʼ������Ҳ����Ǵӱ��ܺ�һ���ӿ�ʼ��

%���ڷ�����x����Ӧ�ڵ㶼��ԭ��ģʽ����Ҫ����ģʽ(�µ�ģʽģʽ����ȫΪ1)�����ڷ��������ָ�ģʽ����֤��һ�η�����֮ǰ��֮ǰ�Ľڵ�����������µ�ģʽ

num=1;
tstep=0;
pressure={0};
flow={0};
Value_Cell=cell(simnum,1);
while(num<=simnum)
 %�趨����
  SetFeedBack(time,num,para); 
  %Ĭ�ϲ�����ʼ��
  errcode=calllib('epanetnext','ENinitH',0);                         %��ʼ����ˮ��ˮλ���ܵ�״̬�������Լ�ģ��ʱ�䣬0��ʾ���洢������ˮ�����
  %���з���
  [errcode,time]=calllib('epanetnext','ENrunH',time);      %ִ����timeʱ�̵�ˮ������
  [errcode,tempvalue]=calllib('epanetnext','ENgetlinkvalue',Index,EN_FLOW,tempvalue); %��ȡ������������ 
  f1=floor(abs(tempvalue));          %sim data
  [errcode,tstep]=calllib('epanetnext','ENnextH',tstep);
  num=num+1;
% pause(0.01);%ע�⣬������ͣһ��ʱ�䣨0.1ms�����Է�ֹepanet�ں����б���
end
    %Validotor_Value{k,1}=Value_Cell;
f2=sum(position);
fitness=[f1
         f2];