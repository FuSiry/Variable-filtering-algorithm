function IMGA
clear all;
clc;
%x1����[-2.048,2.048],x2����[-2.048,2.048],fitness:J=100*(x1^2-x2)^2+(1-x1)^2;
popsize=50;% the value of population ��Ⱥȡ����
%CodeL=2;%�������
len=35;
G=200;  % the max generation
mnum=8; % mnum---����ϸ����Ŀ
Pc=0.85;
Pm=0.05;
Tacl=0.8;     %���㿹��Ũ��
Best_result=3905.926;
X=xlsread('C:\Users\c430\Desktop\�����ʺ�������\��������ɸѡ\IGA\������У����.xlsx');%��������
Y = X(:,1);
X2=xlsread('C:\Users\c430\Desktop\�����ʺ�������\��������ɸѡ\IGA\������Ԥ�⼯.xlsx');%��������
Y1 = X2(:,1);
K1 = 1;
T1 = 0;
T2 = 0;
T3 = 0;
T4 = 0;
for k1 = 1:K1
%---------------------��ʼ����Ⱥ-------------------------%
for i=1:popsize
    x(i,:)=Initial(len);
    fx(i)=fitness(x(i,:),X,len);
end

%--------------------------------------------------------%
[Ag,RealValue]=affinity1(x,popsize,X,len);%�����뿹ԭ���׺���
%-------------------������ʼ����ϸ��----------------------%
for i=1:mnum 
    mcell(i,:)=Initial(len);
    mfx(i)=fitness(mcell(i,:),X,len);
end
%--------------------------------------------------------%
[mx,mAg]=memorycell(x,mcell,mnum,popsize,X,len);%���³�ʼ����ϸ��
[Order_Ag,Index_Ag]=sort(Ag);%��ʼ����ϸ�����³�ʼ��Ⱥ
x(Index_Ag(1:mnum),:)=mx;
[Ag,RealValue]=affinity1(x,popsize,X,len);%�����뿹ԭ���׺���
[Ab]=affinity2(x,popsize,len);%�����뿹��֮����׺���
C=(sum(Ab>Tacl,2)/popsize)';%���㿹��Ũ��
[Best_Ag,Index]=max(Ag);%���ʼ����Ӣ����
Best_Value(1)=RealValue(Index);
Temp_Value=Best_Value(1);
Best_gene=x(Index,:);
[Worst_Ag,Index1]=min(Ag);%���ʼ������
Worst_Value(1)=RealValue(Index1);
Worst_gene=x(Index1,:);
avg_Ag=0;
for k=1:popsize
    avg_Ag=avg_Ag+RealValue(k);
end
avg_Ag=avg_Ag/popsize;%���ʼ�������뿹ԭ�׺Ͷ�ƽ��ֵ
fprintf(1,'\n1--->Best : %f Worst : %f Avg : %f \n',Best_Value(1),Worst_Value(1),avg_Ag)
[mx,mAg]=memorycell(x,mcell,mnum,popsize,X,len);%���³�ʼ����ϸ��
%-------------------------------��ʼ����----------------------------------%
time(1)=1;
for gen=2:G
  time(gen)=gen;  
%---------------------1:Select Cross Mutation Operation----------------%
[E]=Select_Antibody(C,Ag,popsize);
[newench2select]=Select(x,E,popsize);%���Ƹ���
[newench2cross]=Cross(newench2select,Pc);%����
[ench2]=Mutate(newench2cross,Pm);%����
%[chrom]=decode(ench2,len,MinX,MaxX);%����
%-----------------------------2:���߲���-------------------------------%
[Ag,RealValue]=affinity1(ench2,popsize,X,len);%�����뿹ԭ���׺���
[Ab]=affinity2(ench2,popsize,len);%�����뿹��֮����׺���
C=(sum(Ab>Tacl,2)/popsize)';%���㿹��Ũ��
[Best_cur_Ag,Index]=max(Ag);
Best_cur_gene=ench2(Index,:);
[Worst_cur_Ag,index]=min(Ag);
Worst_Value=RealValue(index);
Worst_cur_gene=ench2(index);
avg_Value=0;
for k=1:popsize
    avg_Value=avg_Value+RealValue(k);
end
avg_Value=avg_Value/popsize;
%��Ӣ���屣������
if Best_cur_Ag < Best_Ag
    Best_Value(gen)=Temp_Value;
    ench2(index,:)=Best_gene;
elseif Best_cur_Ag >= Best_Ag
    Best_Value(gen)=RealValue(Index);
    Best_Ag=Best_cur_Ag;
    Temp_Value=RealValue(Index);
    Best_gene=Best_cur_gene;
end
fprintf(1,'\n%d--->BEST : %f WORST : %f AVG : %f \n',gen,Best_Value(gen),Worst_Value,avg_Value);
fprintf(1,'--->Value_F = %f',Best_Value(gen));
disp(Best_gene)
% if abs(Best_Value(gen)-Best_result)<0.001
%     fprintf(1,'�ڵ�%d�����������Ž� ',gen);
%     return;
% end
[mx,mAg]=memorycell(x,mcell,mnum,popsize,X,len);%���³�ʼ����ϸ��
[~,Index_Ag]=sort(Ag);%���±����Ļ���
ench2(Index_Ag(1:mnum),:)=mx;
x=ench2;
Ag(Index_Ag(1:mnum))=mAg;
end
j=1;
for i=1:len
    if Best_gene(i)==1;
        X_end(:,j:j+19) = X(:,20*i-18:20*i+1);
        j = j + 20;
    end
end
[Rc,RMSEC,beta,yc]= fitaaa(Best_gene,X,len);
% figure(1);
% plot(Y,yc,'ro');
% xlabel('Actual Value');
% ylabel('Predictive Value');
% text(7.7,9.8,['Rc = ',num2str(Rc)]);
% text(7.7,9.65,['RMSEC = ',num2str(RMSEC)]);
% hold on;
% plot([7.5,10],[7.5,10],'linewidth',1.5);
[Rp,RMSEP,yp]= fitbbb(Best_gene,X2,len,beta);
T1 = T1 + Rc;
T2 = T2 + RMSEC;
T3 = T3 + Rp;
T4 = T4 + RMSEP;
% figure(2);
% plot(Y1,yp,'ro');
% xlabel('Actual Value');
% ylabel('Predictive Value');
% text(7.7,9.8,['Rp = ',num2str(Rp)]);
% text(7.7,9.65,['RMSEP = ',num2str(RMSEP)]);
% hold on;
% plot([7.5,10],[7.5,10],'linewidth',1.5);
end
disp(T1/K1);
disp(T2/K1);
disp(T3/K1);
disp(T4/K1);
%------------------------------��ͼ--------------------------------%
%save IMGA_MAX_F1 time Best_Value
figure(3);
plot(time,Best_Value,'b');
xlabel('��������');ylabel('Ŀ�꺯��ֵ');% the value of objective
%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����Ŵ��㷨�Ӻ���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*
%---------------------���㿹���뿹ԭ���׺Ͷ�----------------%
function [Ag,Real]=affinity1(x,popsize,X,len) 
for i=1:popsize
    x1=x(i,:);
    Real(i) = fitness(x1,X,len);
    Ag(i)=Real(i)/1;%����ȡ����ֵʱ��������ȣ���Сֵʱ��תΪ�����ֵ���⣬����һ��
end
%---------------------------------------------------------%
%---------------------���㿹���뿹����׺Ͷ�----------------%
function [Ab]=affinity2(ench2,popsize,len)
for i=1:popsize
    for j=i:popsize
        gene1=ench2(i,:);
        gene2=ench2(j,:);
        s=0;
        for k=1:len
            if gene1(k)==gene2(k)
                Hj(k)=0;
            else
                Hj(k)=log10(2);
            end
            s=s+Hj(k);
        end
        H_2=s/len;
        Ab(i,j)=1/(1+H_2);
        Ab(j,i)=Ab(i,j);
    end
end
%------------------------------------------------------------------------%
%----------------------------���¼���ϸ��---------------------------------%
function [mx,mAg]=memorycell(x,mcell,mnum,popsize,X,len)
snum=mnum+popsize;
for i=1:popsize
    x1=x(i,:);
    GxAg(i)=fitness(x1,X,len);
end
for i=1:mnum
    GxmAg(i)=fitness(mcell(i,:),X,len);
end
TAg(1:popsize)=GxAg;
Tch(1:popsize,:)=x;
TAg(popsize+1:popsize+mnum)=GxmAg;
Tch(popsize+1:popsize+mnum,:)=mcell;
[OrderTAg,IndexTAg]=sort(TAg);
for i=1:mnum
    mx(i,:)=Tch(IndexTAg(snum+1-i),:);
    mAg(i)=OrderTAg(snum+1-i);
end

%[mgene,sumlen]=encode(mchrom,len,mnum,MaxX,MinX);
%------------------------------------------------------------------------%
%-------------------------------��������ı�׼--------------------------------%
function [E]=Select_Antibody(C,Ag,popsize)
lanm=0.7;
miu=1.25;
for i=1:popsize
    E(i)=lanm*Ag(i)+(1-lanm)*exp(-miu*C(i));
end
%------------------------------------------------------------------------%
%-----------------------------���̶Ĳ���ѡ����--------------------------%
function [newchselect]=Select(ench2,E,popsize)
sumE=sum(E);
pE=E/sumE;
psE=0;
psE(1)=pE(1);
for i=2:popsize
    psE(i)=psE(i-1)+pE(i);
end
for i=1:popsize
    sita=rand;
    for g=1:popsize
        if sita<=psE(g)
            n=g;
            break;
        end
    end
    newchselect(i,:)=ench2(n,:);
end
%------------------------------------------------------------------------%
%-----------------------------���㽻�淨--------------------------------%
function [newench2cross]=Cross(newench2select,Pc)
[Ordersj,Indexsj]=sort(rand(size(newench2select,1),1));%�������
newench2select=newench2select(Indexsj,:);
lchrom=size(newench2select,2);
poscut=ceil(rand(size(newench2select,1)/2,1)*(lchrom-1));%ѡ����������
poscut=poscut.*(rand(size(poscut))<Pc); %���ݽ�����ʽ��н���
for i=1:length(poscut),%length��A����ʾA�������/����
     newench2cross([2*i-1 2*i],:)=[newench2select([2*i-1 2*i],1:poscut(i)) newench2select([2*i 2*i-1],poscut(i)+1:lchrom)];%���㽻��
end
%------------------------------------------------------------------------%
%----------------------------------����----------------------------------%
function [newchmutate]=Mutate(newchcross,Pm)
point=find(rand(size(newchcross))<Pm);%���ֱ����
newchmutate=newchcross;
newchmutate(point)=1-newchcross(point);   
%------------------------------------------------------------------------%
function z = fitness(x,X,L)
    j = 1;
    f = 7;
    for i=1:L
        if x(i) == 1
            XX(:,j:j+19) = X(:,20*i-18:20*i+1);
            j = j+20;
        end
    end
    YY = X(:,1);
    [xl,yl,xs,ys,beta,pctvar,mse]=plsregress(XX,YY,f);%��xr��Y����pls�ع�
    RMSEC = sqrt(sum((YY-(XX*beta(2:end,:)+beta(1,:))).^2)/50);

    R = sqrt(1-(sum((YY-(XX*beta(2:end,:)+beta(1,:))).^2))/(sum((YY-mean(YY)).^2)));

    z = R/(1+RMSEC);
    
function result=Initial(length)     %��ʼ������
    for i=1:length
        r=rand();
        result(i)=round(r);
    end
    
