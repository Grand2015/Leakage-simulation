%% ���Դ��룺ͨ���������ID��ͨ��ID�������
% name='5';
% [errCode,name,linkIndex]=calllib('epanetnext','ENgetlinkindex',name,linkIndex);
% [errCode,linkID]=calllib('epanetnext','ENgetnodeid',3,linkID);
%���Դ������

%% ���Դ���
%���Կ��Ʒ��ſ���
% errCode=calllib('epanetnext','ENsetlinkvalue',valveIndex,EN_STATUS,CLOSED);%�رշ���
% [errCode,status]=calllib('epanetnext','ENgetlinkvalue',valveIndex,EN_STATUS,status);%��ȡ�ܵĿ���״̬
% errCode=calllib('epanetnext','ENsetlinkvalue',valveIndex,EN_STATUS,OPEN);%�򿪷���
%���Կ��ƹܶ�����
%���Դ������