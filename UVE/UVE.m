%%����Ϣ����������
x1=xlsread('C:\Users\c430\Desktop\�����ʺ�������\��������ɸѡ\UVE\�����ʺ���Ԥ��.xlsx');
x=x1(:,2:end);%���׾���
y=x1(:,1);%Ũ�Ⱦ���
f=7;%ncomp�����������
[n,m]=size(x);
R=normrnd(0.4,0.242,n,m);%����һ�������������
XR=[x,R];%x��R�������
B=[];
for i=1:n
    xr=XR;
    xr(i,:)=[];
    Y=y;
    Y(i)=[];
    [xl,yl,xs,ys,beta,pctvar,mse]=plsregress(xr,Y,f);%��xr��Y����pls�ع�
    B=[B,beta];%�ع�ϵ������B
end
me=mean(B,2);%���ֵ
s=std(B')';%���׼ƫ��
h=me./s;
h(1)=[];
hmax=max(abs(h(1+m:2*m)));%������[1+m,2m]�ϵõ����ֵ��������Ϊ��ֵ
index=find(abs(h) > hmax); %�ҵ�h������ֵ�Ĳ��ε�λ�ò���������
plot(1:m,h(1:m),'k',m+1:(2*m),h(m+1:end),'r')
hold on
plot((1:2*m),hmax,'b')
hold on
plot((1:2*m),-1*hmax,'b')
hold on
plot(index,h(index),'g+')
xlabel('real variables - index - random variables')
ylabel('ϵ����ֵ/��ƫ')
X=x(:,index);
index = index';

[m,n] = size(index);
for i = 1:n
    y = [y,x(:,index(i))]; 
end
z = fitness_2(y);
disp(z);



