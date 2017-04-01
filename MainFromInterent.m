%% ����©����
%��ɢ��ϵ��0.5��©����5LPS
%�ܶεĴֲ�ϵ��Ϊ100
%�������0.004s������ʱ��Ϊ2min
%���ŵĹر�ʱ��0.17~0.25s֮�䣨ȡ0.2s��
%��������ͬʱ��ĺ�����q=-50t+50
clc;
clear all;
close all;
%% �����ʼ����
EN_NODECOUNT=0;EN_TANKCOUNT=1;EN_SAVEDATA=1;EN_PRESSURE=11;EN_FLOW=8;
EN_INITSETTING=5;EN_SETTING=12;EN_LINKCOUNT=2;EN_LENGTH=1;EN_STATUS=11;
OPEN=1;CLOSED=0;
pressure=0;flow=0;position=[ ];flowChange=0;
nodeNum=0;%�ڵ���Ŀ
tankNum=0;%ˮ����Ŀ
linkNum=0;%�ܶ���Ŀ
length=0;
time=120;%��ʼ������ʱ�䣨��λ��s��
processTime=0;
valveCloseTime= 0.02;%���Źر�ʱ��
tStep=0.004;%��ʼ��ˮ�������Ĳ������������������ֵ����λ��s��
sampleNum=time/tStep;%��������
sampleNumConst=sampleNum;
from=0;to=0;%�ܶε���ʼλ��
linkNameStr='';
linkIndex=0;
status=0;
valveID='4';%����ID
%% ִ��ˮ������
errCode=loadlibrary('epanetnext.dll','epanetnext.h');%����epanet�ļ�
errCode=calllib('epanetnext','ENopen','frequencyTest.inp','frequencyTest.rpt','');%��inp�ļ�������rpt�����ļ�

[errCode,nodeNum]=calllib('epanetnext','ENgetcount',EN_NODECOUNT,nodeNum);%��ȡ�ڵ�����
[errCode,tankNum]=calllib('epanetnext','ENgetcount',EN_TANKCOUNT,tankNum);%��ȡˮ������
junctionNum=nodeNum-tankNum;%���ӵ���Ŀ�����ܽڵ���Ŀ��ȥˮ����Ŀ
[errCode,linkNum]=calllib('epanetnext','ENgetcount',EN_LINKCOUNT,linkNum);%��ȡ�ܶ�����
% [errCode,linkNum]=calllib('epanetnext','ENgetcount',EN_NODECOUNT,linkNum);%��ȡ�ܶ�����

errCode= calllib('epanetnext','ENopenH');%��ˮ������ϵͳ
errCode=calllib('epanetnext','ENinitH',EN_SAVEDATA);%��ʼ����1�Ǳ���ˮ�������ˮ���ļ�
for i=1:linkNum
   linkNameStr=num2str(i);
   errCode=calllib('epanetnext','ENsetlinkvalue',i,EN_INITSETTING,OPEN);%���ó�ʼʱ���йܶζ�Ϊ��
   [errcode,linkNameStr,linkIndex]=calllib('epanetnext','ENgetlinkindex',linkNameStr,linkIndex);  %��ùܵ�����
   [errCode,from,to]=calllib('epanetnext','ENgetlinknodes',linkIndex,from,to);%��ȡ�ܵ���ʼλ�ã�ȷ������ܶ�
   [errCode,length]=calllib('epanetnext','ENgetlinkvalue',i,EN_LENGTH,length);%��ȡ�ܵĳ���
   [errCode,status]=calllib('epanetnext','ENgetlinkvalue',i,EN_STATUS,status);%��ȡ�ܵĿ���״̬
   position(1,i)=i;
   position(2,i)=from;
   position(3,i)=to;
   position(4,i)=length;
   position(5,i)=status;
end
%% ���Դ���
%���Կ��Ʒ��ſ���
errCode=calllib('epanetnext','ENsetlinkvalue',str2num(valveID),EN_STATUS,CLOSED);%�رշ���
[errCode,status]=calllib('epanetnext','ENgetlinkvalue',str2num(valveID),EN_STATUS,status);%��ȡ�ܵĿ���״̬
errCode=calllib('epanetnext','ENsetlinkvalue',str2num(valveID),EN_STATUS,OPEN);%�򿪷���
%���Կ��ƹܶ�����

%���Դ������
%% 
while(sampleNum && ~errCode)
   errCode=calllib('epanetnext','ENrunH',processTime);%ִ��processTimeʱ�̵�ˮ��ģ��
   for i=1:junctionNum
      [errCode,pressure]=calllib('epanetnext','ENgetnodevalue',i,EN_PRESSURE,pressure); 
      pressureValue(i,(sampleNumConst+1-sampleNum))=pressure;
   end
    [errCode,flow]=calllib('epanetnext','ENgetlinkvalue',str2num(valveID),EN_FLOW,flow);%���ܶ��е�����
 %% ���Դ���
%���Կ��ƹܶ�����
    errCode=calllib('epanetnext','ENsetlinkvalue',str2num(valveID),EN_SETTING,flow/2);%���÷�������Ϊ30
    [errCode,flowChange]=calllib('epanetnext','ENgetlinkvalue',str2num(valveID),EN_FLOW,flowChange);%���ܶ��е�����
%���Դ������
%%
    if(sampleNum<(time/(2*tStep)) && sampleNum>=(time/(2*tStep)-5))
        %errCode=calllib('epanetnext','EN',4,EN_FLOW,flow);%���÷��������溯���仯
    elseif(sampleNum<(time/(2*tStep)-5))
        %errCode=calllib('epanetnext','ENsetlinkvalue',str2num(valveID),EN_STATUS,0);%���÷�������Ϊ0
        errCode=calllib('epanetnext','ENsetlinkvalue',str2num(valveID),EN_STATUS,CLOSED);%���÷���״̬Ϊ��
    end
    errCode=calllib('epanetnext','ENnextH',tStep);
    processTime=processTime+tStep;
    sampleNum=sampleNum-1;
end
errCode=calllib('epanetnext','ENcloseH');%�ر�ˮ������ϵͳ
errCode=calllib('epanetnext','ENclose');%�ر�toolkitϵͳ
unloadlibrary('epanetnext');

plot(pressureValue(1,:),'g');
% hold on;
% plot(pressureValue(2,:),'b');
% hold on;
% plot(pressureValue(3,:));
% hold on;
% plot(pressureValue(4,:),'r');

