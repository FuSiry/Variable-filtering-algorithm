clear all;
X1=xlsread('C:\Users\c430\Desktop\�����ʺ�������\��������ɸѡ\PCA\�����ʺ���Ԥ��.xlsx');
X = X1(:,2:end);
Y = X1(:,1);
z=zscore(X);               %���ݱ�׼��
M=cov(z);                  %Э����
[V,D]=eig(M);             %���Э������������������������
d=diag(D);                %ȡ����������������������ȡ��ÿһ���ɷֵĹ����ʣ�
eig1=sort(d,'descend');     %�������ʰ��Ӵ�СԪ������
v=fliplr(V);              %����D����������������
S=0;
i=20;
gxl = (sum(eig1(1:i)))/(sum(eig1));
% while S/sum(eig1)<0.99997
%     i=i+1;
%     S=S+eig1(i);
% end                         %����ۻ������ʴ���85%�����ɷ�
NEW=z*v(:,1:i);              %����������������µ�����
XX = [Y,NEW];
rd(1:78) = randperm(78);
x_train = XX(rd(1:50),:);
x_test = XX(rd(51:end),:);
[RMSEC,Rc,RMSEP,Rp] = fitness_1(x_train,x_test);
W=100*eig1/sum(eig1);
figure(1)
pareto(W);                  %���������ʵ�ֱ��ͼ
bar(W);