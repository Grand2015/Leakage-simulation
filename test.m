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
EN_LINKCOUNT=2;
EN_INITSETTING=5;
EN_FCV=6;
EN_FLOW=8;
EN_PRESSURE=11;EN_STATUS=11;
EN_SETTING=12;
pressure=0;flow=0;errCode=0;
nodeNum=0;%�ڵ���Ŀ
tankNum=0;%ˮ����Ŀ
linkNum=0;%�ܶ���Ŀ
time=0;%��ʼ������ʱ��
tStep=1;
inputFile='leakageSimulation.inp';%EPANET�����ļ�
outputFile='leakageSimulation.rpt';%����ļ�
%% ִ��ˮ������
errCode=loadlibrary('epanetnext.dll','epanetnext.h');%��loadlibrary������ ����epanetnext.h�еĺ������壬����epanetnext.dll
% libfunctions epanetnext -full%�鿴epanetnext.dll֧�ֵĺ����ӿ�
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

errCode=calllib('epanetnext','ENopenH');%��ˮ������ϵͳ
errCode=calllib('epanetnext','ENinitH',0);%��ʼ����1�Ǳ���ˮ�������ˮ���ļ�
j=1;
while(tStep && ~errCode)
   [errCode,time]=calllib('epanetnext','ENrunH',time);%ִ��timeʱ�̵�ˮ��ģ��
   for i=1:junctionNum
      [errCode,pressure]=calllib('epanetnext','ENgetnodevalue',i,EN_PRESSURE,pressure); 
      pressureValue(i,j)=pressure;
   end
   j=j+1;
   [errCode,tStep]=calllib('epanetnext','ENnextH',tStep);
end
errCode=calllib('epanetnext','ENcloseH');%�ر�ˮ������ϵͳ
errCode=calllib('epanetnext','ENclose');%�ر�toolkitϵͳ
unloadlibrary('epanetnext');



