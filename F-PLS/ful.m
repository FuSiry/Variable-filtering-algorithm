clear all;
X1=xlsread('C:\Users\c430\Desktop\�����ʺ�������\��������ɸѡ\ȫ��\���У����.xlsx');%��������
X2=xlsread('C:\Users\c430\Desktop\�����ʺ�������\��������ɸѡ\ȫ��\���Ԥ�⼯.xlsx');%��������
[Rc,RMSEC,beta,yc] = fitaaa(X1);
[Rp,RMSEP,yp] = fitbbb(X2,beta);