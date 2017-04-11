%% ����©����
%3�Žڵ���ɢ��ϵ��0.5��©����5LPS
%�ܶεĴֲ�ϵ��Ϊ100
%�������0.004s������ʱ��Ϊ2min
%���ŵĹر�ʱ��0.17~0.25s֮�䣨ȡ0.2s��
%��������ͬʱ��ĺ�����q=-50t+50
clc;
clear all;
close all;
%% �����ʼ����
EN_NODECOUNT=0;CLOSED=0;
EN_TANKCOUNT=1;EN_SAVEDATA=1;EN_LENGTH=1;OPEN=1;
EN_LINKCOUNT=2;EN_TIMER=2;
EN_INITSETTING=5;
EN_FCV=6;
EN_FLOW=8;
EN_PRESSURE=11;EN_STATUS=11;
EN_SETTING=12;
pressure=0;flow=0;flowChange=0;
divisor=12;%����ȡ�����ı�����
controlTime=60;%���ƶ�����ʱ�䣨��λ��s��
% position=[ ];
nodeNum=0;%�ڵ���Ŀ
tankNum=0;%ˮ����Ŀ
linkNum=0;%�ܶ���Ŀ
% length=0;
time=0;%��ʼ������ʱ�䣨��λ��s��
% processTime=0;
valveCloseTime= 0.02;%���Źر�ʱ��
tStep=1;
% tStep=0.004;%��ʼ��ˮ�������Ĳ������������������ֵ����λ��s��
sampleNum=time/tStep;%��������
sampleNumConst=sampleNum;
% from=0;to=0;%�ܶε���ʼλ��
% linkNameStr='';
% linkIndex=0;
status=0;
linkID='';
linkType=0;%�ܶ�����
valveID='';%����ID
valveIndex=0;%��������
inputFile='leakageSimulation.inp';%EPANET�����ļ�
outputFile='leakageSimulation.rpt';%����ļ�
%% ִ��ˮ������
errCode=loadlibrary('epanetnext.dll','epanetnext.h');%��loadlibrary������ ����epanetnext.h�еĺ������壬����epanetnext.dll
libfunctions epanetnext -full%�鿴epanetnext.dll֧�ֵĺ����ӿ�
errCode=calllib('epanetnext','ENopen',inputFile,outputFile,'');%��calllib��������EPANET�������е�ENopen����
while (errCode>0)
        errCode=calllib('epanetnext','ENopen',inputFile,outputFile,'');%��calllib��������EPANET�������е�ENopen��������ҪУ�˵Ĺ���ģ��
        if(errCode)  
            calllib('epanetnext','ENclose');%�����ʧ�ܣ���ر�
            errCode=loadlibrary('epanetnext.dll','epanetnext.h');%��loadlibrary������ ����epanetnext.h�еĺ������壬����epanetnext.dll
        end
end

%��ȡ�ܶεĲ�����Ϣ
[errCode,nodeNum]=calllib('epanetnext','ENgetcount',EN_NODECOUNT,nodeNum);%��ȡ�ڵ�����
[errCode,tankNum]=calllib('epanetnext','ENgetcount',EN_TANKCOUNT,tankNum);%��ȡˮ������
junctionNum=nodeNum-tankNum;%���ӵ���Ŀ�����ܽڵ���Ŀ��ȥˮ����Ŀ
[errCode,linkNum]=calllib('epanetnext','ENgetcount',EN_LINKCOUNT,linkNum);%��ȡ�ܶ�����
%% ���Դ��룺ͨ���������ID��ͨ��ID�������
% name='5';
% [errCode,name,linkIndex]=calllib('epanetnext','ENgetlinkindex',name,linkIndex);
% [errCode,linkID]=calllib('epanetnext','ENgetnodeid',3,linkID);
%���Դ������
%% 
for i=1:linkNum
   [errcode,linkType]=calllib('epanetnext','ENgetlinktype',i,linkType);%���ܶ����ͣ���������
   if linkType==EN_FCV
       valveIndex=i;%��ȡ��������
       [errCode,valveID]=calllib('epanetnext','ENgetlinkid',i,valveID);%��ȡ����ID
%        [errCode,from,to]=calllib('epanetnext','ENgetlinknodes',i,from,to);%��ȡ�ܵ���ʼλ�ã�ȷ������ܶ�
   end
   errCode=calllib('epanetnext','ENsetlinkvalue',i,EN_INITSETTING,OPEN);%���ó�ʼʱ���йܶζ�Ϊ��
end

errCode= calllib('epanetnext','ENopenH');%��ˮ������ϵͳ
errCode=calllib('epanetnext','ENinitH',0);%��ʼ����1�Ǳ���ˮ�������ˮ���ļ�

%% ���Դ���
%���Կ��Ʒ��ſ���
% errCode=calllib('epanetnext','ENsetlinkvalue',valveIndex,EN_STATUS,CLOSED);%�رշ���
% [errCode,status]=calllib('epanetnext','ENgetlinkvalue',valveIndex,EN_STATUS,status);%��ȡ�ܵĿ���״̬
% errCode=calllib('epanetnext','ENsetlinkvalue',valveIndex,EN_STATUS,OPEN);%�򿪷���
%���Կ��ƹܶ�����

%���Դ������
%% 
j=1;
while(tStep && ~errCode)
   [errCode,time]=calllib('epanetnext','ENrunH',time);%ִ��timeʱ�̵�ˮ��ģ��
   
%     errCode=calllib('epanetnext','ENsetcontrol',1,EN_TIMER,valveIndex,100,0,controlTime);%���÷��ŵĳ�ʼ״̬������Ϊ100LPS
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
errCode=calllib('epanetnext','ENcloseH');%�ر�ˮ������ϵͳ
errCode=calllib('epanetnext','ENclose');%�ر�toolkitϵͳ
unloadlibrary('epanetnext');

% plot(pressureValue(1,:),'g');
% hold on;
% plot(pressureValue(2,:),'b');
% hold on;
% plot(pressureValue(3,:));
% hold on;
% plot(pressureValue(4,:),'r');

