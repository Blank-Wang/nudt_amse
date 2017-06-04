% clear all
% clc
% close all
load probability16;
XVarNames = {'whale 1','whale 2','whale 3','whale 4','whale 15','whale 17','whale 19','whale 6','whale 7','whale 22','whale 8','whale 9','whale 10','whale 12','whale 13','whale 24'};

A=test20000;

SUM_A=sum(A);
for i =1:16
A(:,i)=A(:,i)/SUM_A(i);
end
SUM_A2=sum(A);
Sum_subtract_i_A=zeros(1,16);
 B=zeros(16);

for i =1:16
 Sum_subtract_i_A(i)=SUM_A2(i)-A(i,i);
 B(:,i)=A(:,i)/Sum_subtract_i_A(i);
 B(i,i)=1;
 end
%   matrixplot(B,'FillStyle','nofill','XVarNames',XVarNames,'YVarNames',XVarNames,'TextColor','Auto','ColorBar','on');
  matrixplot(B,'XVarNames',XVarNames,'YVarNames',XVarNames,'TextColor',[0.6,0.6,0.6],'ColorBar','on');
  matrixplot(A,'XVarNames',XVarNames,'YVarNames',XVarNames,'DisplayOpt','off','FigSize','Full','ColorBar','on','FigShape','d');

