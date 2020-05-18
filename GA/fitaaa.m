function [R,RMSEC,beta,y] = fitaaa(x,X,L)     %��Ӧ�Ⱥ���


    %X=xlsread('C:\Users\c430\Desktop\GA\HY1.xlsx');%��������
    j = 1;
    %f = 7;
    for i=1:L
        if x(i) == 1
            XX(:,j:j+19) = X(:,20*i-18:20*i+1);
            j = j+20;
        end
    end
    YY = X(:,1);
    [xl,yl,xs,ys,beta,pctvar,mse]=plsregress(XX,YY,9);%��xr��Y����pls�ع�
    RMSEC = sqrt(sum((YY-(XX*beta(2:end,:)+beta(1,:))).^2)/50);
    y = XX*beta(2:end,:)+beta(1,:);
    R = sqrt(1-(sum((YY-(XX*beta(2:end,:)+beta(1,:))).^2))/(sum((YY-mean(YY)).^2)));

    z = R/(1+RMSEC);
    %disp(z)
end