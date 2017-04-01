%% 
clear all;
clc;
ErrCode = 0;
NodeNum = 0;   %nodenum���ܽڵ���Ŀ�����Ը�������ֵ�����Ը�������ֵ
LinkNum = 0;
EN_NODECOUNT = 0;%�ڵ�
EN_LINKCOUNT = 2;%�ܶ�
EN_BASEDEMAND = 1;
BaseDemand = 0;
Index = 0;
fromnode = 0;
tonode = 0;
%����Ƶ��Ϊ250Hz���������4ms

file = 'frequencyTest.inp';                                       %ָ�����������ļ�  
%% ��ˮ������
%��ȡ������δ���ڵ��������������Ϊ�Ա�������ˮ�⣬��ˮ�ڸ���ˮ���ڵ㣬��ˮ�ڽڵ㣬���ڵ㣬�м�У��ܵ�����
%���Ƚ�epanetnext.dll epanetnext.h�ŵ���ǰ����Ŀ¼����ͬʱ������������ļ�
ErrCode = loadlibrary('epanetnext.dll','epanetnext.h');                     %  ��loadlibrary������ ����epanetnext.h�еĺ������壬����epanetnext.dll
libfunctions epanetnext -full                                          %  �鿴epanetnext.dll֧�ֵĺ����ӿ�
ErrCode = calllib('epanetnext','ENopen',file,'','');                         %  ��calllib��������EPANET�������е�ENopen����
while (ErrCode > 0)
        ErrCode = calllib('epanetnext','ENopen',file,'','');                         %  ��calllib��������EPANET�������е�ENopen��������ҪУ�˵Ĺ���ģ��
        if(ErrCode)  
            calllib('epanetnext','ENclose');                                       %  �����ʧ�ܣ���ر�
            ErrCode = loadlibrary('epanetnext.dll','epanetnext.h');                     % ��loadlibrary������ ����epanetnext.h�еĺ������壬����epanetnext.dll
        end
end
%��ȡ�ڵ���Ŀ
[ErrCode,NodeNum] = calllib('epanetnext','ENgetcount',EN_NODECOUNT,NodeNum);        %  ��ȡ�ܽڵ���Ŀ��ע���ȡ��ֵ�ķ�ʽ������Ҫ����ͬ�Ĳ���nodenum��Ҳ���Բ�ͬ
[ErrCode,LinkNum] = calllib('epanetnext','ENgetcount',EN_LINKCOUNT,LinkNum);
[errcode,fromnode,tonode]=calllib('epanetnext','ENgetlinknodes',5,fromnode,tonode);  %��ùܵ����˽ڵ�



for i = 1:LinkNum
 name = num2str(i);
 Index = 1;
[ErrCode,name,Index] = calllib('epanetnext','ENgetnodeindex',name,Index);  %��ȡ�ڵ�����
NodeIndex(i,1) = Index;

linkID='';
[errcode,linkID]=calllib('epanetnext','ENgetlinkid',i,linkID);  %��ùܵ�id
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

% errcode=calllib('epanetnext','ENsettimeparam',EN_DURATION,0);%��������
% errcode=calllib('epanetnext','ENsettimeparam',EN_HYDSTEP,3600);%����

 %% 
ErrCode = calllib('epanetnext','ENcloseH');                          %�ر�ˮ�����棬�ͷ��ڴ�
ErrCode = calllib('epanetnext','ENclose');                          %�ر��ļ����ͷ��ڴ�(������йرգ�����Ϊ�������溯����Ҫ���´�)




































