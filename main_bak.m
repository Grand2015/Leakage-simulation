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
       errCode=calllib('epanetnext','ENsetlinkvalue',i,EN_INITSETTING,100);%���ó�ʼʱ���йܶζ�Ϊ��
%        [errCode,from,to]=calllib('epanetnext','ENgetlinknodes',i,from,to);%��ȡ�ܵ���ʼλ�ã�ȷ������ܶ�
   end
   errCode=calllib('epanetnext','ENsetlinkvalue',i,EN_INITSETTING,OPEN);%���ó�ʼʱ���йܶζ�Ϊ��
%    [errCode,linkID]=calllib('epanetnext','ENgetlinkid',i,linkID);  %��ùܵ�id
%    linkNameStr=num2str(linkID);
%    [errcode,linkNameStr,linkIndex]=calllib('epanetnext','ENgetlinkindex',linkNameStr,linkIndex);  %��ùܵ�����
%    [errCode,from,to]=calllib('epanetnext','ENgetlinknodes',linkIndex,from,to);%��ȡ�ܵ���ʼλ�ã�ȷ������ܶ�
%    [errCode,length]=calllib('epanetnext','ENgetlinkvalue',linkIndex,EN_LENGTH,length);%��ȡ�ܵĳ���
%    [errCode,status]=calllib('epanetnext','ENgetlinkvalue',linkIndex,EN_STATUS,status);%��ȡ�ܵĿ���״̬
%    position(1,i)=linkIndex;
%    position(2,i)=from;
%    position(3,i)=to;
%    position(4,i)=length;
%    position(5,i)=status;
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
   errCode=calllib('epanetnext','ENsetlinkvalue',valveIndex,EN_SETTING,100);%��ⷧ�ŵ�ʵ��״̬%    [errCode,flow]=calllib('epanetnext','ENgetlinkvalue',valveIndex,EN_FLOW,flow);%���ܶ��е�����
 %%���Դ���
%    linkType=0;]=calllib('epanetnext','ENgetlinktype',valveIndex,linkType);%��ȡ�ܵ����ͣ��ж��Ƿ��Ƿ���,6ΪFCV�������Ʒ�
%    [errCode,status]=
%    [errCode,linkTypecalllib('epanetnext','ENgetlinkvalue',valveIndex,EN_STATUS,status);%��ⷧ�ŵ�ʵ��״̬
%    status=0;
%    [errCode,status]=calllib('epanetnext','ENgetlinkvalue',valveIndex,EN_SETTING,status);%��ⷧ�ŵ�ʵ��״̬
%%���Դ������
%     errCode=calllib('epanetnext','ENsetcontrol',1,EN_TIMER,valveIndex,100,0,controlTime);%���÷��ŵĳ�ʼ״̬������Ϊ100LPS
   for i=1:junctionNum
      [errCode,pressure]=calllib('epanetnext','ENgetnodevalue',i,EN_PRESSURE,pressure); 
      pressureValue(i,j)=pressure;
   end
   j=j+1;
   
%    %���ÿ������
%    if j==14
%        errCode=calllib('epanetnext','ENsetcontrol',rem(j,divisor),EN_TIMER,valveIndex,60,0,controlTime);
%    elseif j==15
%        errCode=calllib('epanetnext','ENsetcontrol',rem(j,divisor),EN_TIMER,valveIndex,40,0,controlTime);
%    elseif j==16
%        errCode=calllib('epanetnext','ENsetcontrol',rem(j,divisor),EN_TIMER,valveIndex,20,0,controlTime);
%    elseif j==17
%        errCode=calllib('epanetnext','ENsetcontrol',rem(j,divisor),EN_TIMER,valveIndex,0,0,controlTime);
%    end
   
   
%     [errCode,flow]=calllib('epanetnext','ENgetlinkvalue',valveIndex,EN_FLOW,flow);%���ܶ��е�����
%  %% ���Դ���
% %���Կ��ƹܶ�����
%     errCode=calllib('epanetnext','ENsetlinkvalue',str2num(valveID),EN_SETTING,flow/2);%���÷�������Ϊ30
%     [errCode,flowChange]=calllib('epanetnext','ENgetlinkvalue',str2num(valveID),EN_FLOW,flowChange);%���ܶ��е�����
% %���Դ������
%%
%     if(sampleNum<(time/(2*tStep)) && sampleNum>=(time/(2*tStep)-5))
%         %errCode=calllib('epanetnext','EN',4,EN_FLOW,flow);%���÷��������溯���仯
%     elseif(sampleNum<(time/(2*tStep)-5))
%         errCode=calllib('epanetnext','ENsetlinkvalue',str2num(valveID),EN_STATUS,CLOSED);%���÷���״̬Ϊ��
%     end
%     errCode=calllib('epanetnext','ENnextH',tStep);
     [errCode,tStep]=calllib('epanetnext','ENnextH',tStep);

%     processTime=processTime+tStep;
%     sampleNum=sampleNum-1;
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
