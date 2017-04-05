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

time=0;%��ʼ������ʱ�䣨��λ��s��
tStep=1;

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
pressure=0;
number=0;
errCode= calllib('epanetnext','ENopenH');%��ˮ������ϵͳ
errCode=calllib('epanetnext','ENinitH',0);%��ʼ����1�Ǳ���ˮ�������ˮ���ļ�

while(tStep && ~errCode)
   [errCode,time]=calllib('epanetnext','ENrunH',time);%ִ��processTimeʱ�̵�ˮ��ģ��
number=time/3600; 
if (number==11)
for i=1:2
[errCode,pressure]=calllib('epanet2','ENgetnodevalue',i,11,pressure); 
pressurevalue(i,1)=pressure; 
end 
end
     [errCode,tStep]=calllib('epanetnext','ENnextH',tStep);

end
errCode=calllib('epanetnext','ENcloseH');%�ر�ˮ������ϵͳ
errCode=calllib('epanetnext','ENclose');%�ر�toolkitϵͳ
unloadlibrary('epanetnext');

