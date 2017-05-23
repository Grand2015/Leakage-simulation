%% ����©���⣨2017.5.23��
% 2�Žڵ���ɢ��ϵ��0.05
%�ܶεĴֲ�ϵ��Ϊ100���ܾ�DN600���ܳ�100m

%��������
%%�������0.004s������ʱ��Ϊ2min
%%���ŵĹر�ʱ��0.17~0.25s֮�䣨ȡ0.2s��
%%��������ͬʱ��ĺ�����q=-50t+50

clc;
clear;
close all;
%% �����ʼ����
EN_NODECOUNT=0;CLOSED=0;
EN_TANKCOUNT=1;EN_SAVEDATA=1;EN_LENGTH=1;OPEN=1;
EN_LINKCOUNT=2;EN_TIMER=2;
EN_EMITTER=3;
EN_INITSTATUS=4;
EN_INITSETTING=5;
EN_FCV=6;
EN_FLOW=8;
EN_PRESSURE=11;EN_STATUS=11;
EN_SETTING=12;



pressure=0;flow=0;flowChange=0;
nodeNum=0;tankNum=0;linkNum=0;
time=0;%��ʼ������ʱ�䣨��λ��s��
tStep=1;
status=0;
linkID='';
linkType=0;
valveID='';
valveIndex=0;
valveInitFlow=792;
emitter_leakage=0;
emitter_demand=0;
% inputFile='leakageSimulation.inp';
% outputFile='leakageSimulation.rpt';
inputFile='PDA_min_DN600.inp';
outputFile='PDA_min_DN600.rpt';
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
[errCode,linkNum]=calllib('epanetnext','ENgetcount',EN_LINKCOUNT,linkNum);%��ȡ�ܶ��������������ţ�
%% ��������
for i=1:linkNum
   errCode=calllib('epanetnext','ENsetlinkvalue',i,EN_INITSTATUS,OPEN);%���ó�ʼʱ���йܶζ�Ϊ��
   [errCode,linkType]=calllib('epanetnext','ENgetlinktype',i,linkType);%���ܶ����ͣ���������
   if linkType==EN_FCV
       valveIndex=i;%��ȡ��������
       [errCode,valveID]=calllib('epanetnext','ENgetlinkid',i,valveID);%��ȡ����ID
       errCode=calllib('epanetnext','ENsetlinkvalue',i,EN_INITSETTING,valveInitFlow);%���ó�ʼʱ���йܶζ�Ϊ��
   end
end

% [errCode,emitter_leakage]=calllib('epanetnext','ENgetnodevalue',2,EN_EMITTER,emitter_leakage);
% [errCode,emitter_demand]=calllib('epanetnext','ENgetnodevalue',7,EN_EMITTER,emitter_demand);

%% ִ��ˮ��ģ��
errCode= calllib('epanetnext','ENopenH');%��ˮ������ϵͳ
errCode=calllib('epanetnext','ENinitH',1);%��ʼ����1�Ǳ���ˮ�������ˮ���ļ�
j=1;
while(tStep && ~errCode)
   [errCode,time]=calllib('epanetnext','ENrunH',time);%ִ��timeʱ�̵�ˮ��ģ��
   for i=1:junctionNum
      [errCode,pressure]=calllib('epanetnext','ENgetnodevalue',i,EN_PRESSURE,pressure); 
      pressureValueWithoutLeakage(i,j)=roundn(pressure,-4);
   end
   [errCode,flow]=calllib('epanetnext','ENgetlinkvalue',valveIndex,EN_FLOW,flow);%���ܶ��е�����
   valveFlowWithoutLeakage(1,j)=roundn(flow,-2);
   j=j+1;
   [errCode,tStep]=calllib('epanetnext','ENnextH',tStep);
end
errCode=calllib('epanetnext','ENcloseH');%�ر�ˮ������ϵͳ
errCode=calllib('epanetnext','ENclose');%�ر�toolkitϵͳ
unloadlibrary('epanetnext');
%% ©�������

pressure=0;flow=0;flowChange=0;
nodeNum=0;tankNum=0;linkNum=0;
time=0;%��ʼ������ʱ�䣨��λ��s��
tStep=1;
status=0;
linkID='';
linkType=0;
valveID='';
valveIndex=0;
valveInitFlow=792;
emitter_leakage=0;
emitter_demand=0;
% inputFile='leakageSimulation.inp';
% outputFile='leakageSimulation.rpt';
inputFile='PDA_min_DN600.inp';
outputFile='PDA_min_DN600.rpt';
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
[errCode,linkNum]=calllib('epanetnext','ENgetcount',EN_LINKCOUNT,linkNum);%��ȡ�ܶ��������������ţ�
%% ��������
for i=1:linkNum
   errCode=calllib('epanetnext','ENsetlinkvalue',i,EN_INITSTATUS,OPEN);%���ó�ʼʱ���йܶζ�Ϊ��
   [errCode,linkType]=calllib('epanetnext','ENgetlinktype',i,linkType);%���ܶ����ͣ���������
   if linkType==EN_FCV
       valveIndex=i;%��ȡ��������
       [errCode,valveID]=calllib('epanetnext','ENgetlinkid',i,valveID);%��ȡ����ID
       errCode=calllib('epanetnext','ENsetlinkvalue',i,EN_INITSETTING,valveInitFlow);%���ó�ʼʱ���йܶζ�Ϊ��
   end
end

[errCode,emitter_leakage]=calllib('epanetnext','ENgetnodevalue',2,EN_EMITTER,emitter_leakage);
errCode=calllib('epanetnext','ENsetnodevalue',2,EN_EMITTER,0.05);

[errCode,emitter_leakage]=calllib('epanetnext','ENgetnodevalue',2,EN_EMITTER,emitter_leakage);

% [errCode,emitter_demand]=calllib('epanetnext','ENgetnodevalue',7,EN_EMITTER,emitter_demand);

%% ִ��ˮ��ģ��
errCode= calllib('epanetnext','ENopenH');%��ˮ������ϵͳ
errCode=calllib('epanetnext','ENinitH',1);%��ʼ����1�Ǳ���ˮ�������ˮ���ļ�
j=1;
while(tStep && ~errCode)
   [errCode,time]=calllib('epanetnext','ENrunH',time);%ִ��timeʱ�̵�ˮ��ģ��
   for i=1:junctionNum
      [errCode,pressure]=calllib('epanetnext','ENgetnodevalue',i,EN_PRESSURE,pressure); 
      pressureValueWithLeakage(i,j)=roundn(pressure,-4);
   end
   [errCode,flow]=calllib('epanetnext','ENgetlinkvalue',valveIndex,EN_FLOW,flow);%���ܶ��е�����
   valveFlowWithLeakage(1,j)=roundn(flow,-2);
   j=j+1;
   [errCode,tStep]=calllib('epanetnext','ENnextH',tStep);
end
errCode=calllib('epanetnext','ENcloseH');%�ر�ˮ������ϵͳ
errCode=calllib('epanetnext','ENclose');%�ر�toolkitϵͳ
unloadlibrary('epanetnext');


for i=1:32
    data(1,i)=pressureValueWithoutLeakage(1,i);
    dataLeakage(1,i)=pressureValueWithLeakage(1,i);
end


Fs=1000;
subplot(3,1,1);
t=0:1/Fs:1;
plot(1000*t(1:32),data(1:32),'g');
hold on;
plot(1000*t(1:32),dataLeakage(1:32),'r');
xlabel('time(mm)');
title('һԪʱ������ֱ��ͼ');

Y=fft(data,512);
Pyy=Y.*conj(Y)/512;
f=1000*(0:256)/512;

YLeakage=fft(dataLeakage,512);
PyyLeakage=YLeakage.*conj(YLeakage)/512;
fLeakage=1000*(0:256)/512;

subplot(3,1,2);
plot(f,Pyy(1:257),'g');
hold on;
plot(fLeakage,PyyLeakage(1:257),'r');
title('��ɢ���ݵĸ���ҶƵ��ͼ');
xlabel('Ƶ�ʣ�Hz��');

Fs=1000;
NFFT=1024;
Cx=xcorr(data,'unbiased');
Cxk=fft(Cx,NFFT);
Pxx=abs(Cxk);

CxLeakage=xcorr(dataLeakage,'unbiased');
CxkLeakage=fft(CxLeakage,NFFT);
PxxLeakage=abs(CxkLeakage);

t=0:round(NFFT/2-1);
k=t*Fs/NFFT;
P=10*log10(Pxx(t+1));
PLeakage=10*log10(PxxLeakage(t+1));
subplot(3,1,3);
plot(k,P,'g');
hold on;
plot(k,PLeakage,'r');
title('�׹��Ƶ�����غ�����');
xlabel('Ƶ�ʣ�Hz��');





% figure(1);
% Fs=1000;
% subplot(3,1,1);
% t=0:1/Fs:1;
% plot(1000*t(1:32),data(1:32));
% xlabel('time(mm)');
% title('һԪʱ������ֱ��ͼ');
% 
% Y=fft(data,512);
% Pyy2=Y.*conj(Y)/512;
% f2=1000*(0:256)/512;
% subplot(3,1,2);
% plot(f2,Pyy2(1:257));
% title('��ɢ���ݵĸ���ҶƵ��ͼ');
% xlabel('Ƶ�ʣ�Hz��');
% 
% Fs=1000;
% NFFT=1024;
% Cx=xcorr(data,'unbiased');
% Cxk=fft(Cx,NFFT);
% Pxx=abs(Cxk);
% t=0:round(NFFT/2-1);
% k=t*Fs/NFFT;
% P=10*log10(Pxx(t+1));
% subplot(3,1,3);
% plot(k,P);
% title('�׹��Ƶ�����غ�����');
% xlabel('Ƶ�ʣ�Hz��');
% 
% figure(2);
% subplot(1,2,1);
% plot(pressureValue(1,:),'r');
% hold on;
% plot(pressureValue(2,:),'g');
% hold on;
% plot(pressureValue(3,:),'b');
% hold on;
% plot(pressureValue(4,:));
% legend('�ڵ�1','�ڵ�2','�ڵ�3','�ڵ�4');
% xlabel('ģ��ʱ��/min');
% ylabel('�ڵ�ѹ��/m');
% title('δ����©���¼�ʱ���ڵ�1,2,3,4��ʱ��ѹ��ֵ');
% subplot(1,2,2);
% plot(pressureValue(7,:));
% xlabel('ģ��ʱ��/min');
% ylabel('�ڵ�ѹ��/m');
% title('δ����©���¼�ʱ���ڵ�7��ʱ��ѹ��ֵ');

