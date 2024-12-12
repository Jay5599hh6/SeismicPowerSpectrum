clc;clear;
close all
clear all
fid_1=fopen('C:\Users\Administrator.DESKTOP-KRAKDBP\Desktop\20240906上午\3642\X\幅频特性\1.txt','rt'); %文件名，根据实际情况修改
fid_5=fopen('C:\Users\Administrator.DESKTOP-KRAKDBP\Desktop\20240906上午\3642\X\幅频特性\5.txt','rt'); %文件名，根据实际情况修改
fid_10=fopen('C:\Users\Administrator.DESKTOP-KRAKDBP\Desktop\20240906上午\3642\X\幅频特性\10.txt','rt'); %文件名，根据实际情况修改
fid_20=fopen('C:\Users\Administrator.DESKTOP-KRAKDBP\Desktop\20240906上午\3642\X\幅频特性\20.txt','rt'); %文件名，根据实际情况修改
if( fid_1==-1 ) 
    error('无法打开文件');
end
if( fid_1==-1 ) 
    error('无法打开文件');
end
if( fid_1==-1 ) 
    error('无法打开文件');
end

tline1=fgetl(fid_1);
tline5=fgetl(fid_5);
tline10=fgetl(fid_10);
tline20=fgetl(fid_20);
textdate_1=textscan(fid_1,'%s %s %s %s %s %s');
textdate_5=textscan(fid_5,'%s %s %s %s %s %s');
textdate_10=textscan(fid_10,'%s %s %s %s %s %s');
textdate_20=textscan(fid_20,'%s %s %s %s %s %s');
%读取1Hz三通道数据
date1_1=str2num(char(textdate_1{1}));
date2_1=str2num(char(textdate_1{2}));
date3_1=str2num(char(textdate_1{3}));
%读取5Hz三通道数据
date1_5=str2num(char(textdate_5{1}));
date2_5=str2num(char(textdate_5{2}));
date3_5=str2num(char(textdate_5{3}));
%读取10Hz三通道数据
date1_10=str2num(char(textdate_10{1}));
date2_10=str2num(char(textdate_10{2}));
date3_10=str2num(char(textdate_10{3}));
%读取20Hz三通道数据
date1_20=str2num(char(textdate_20{1}));
date2_20=str2num(char(textdate_20{2}));
date3_20=str2num(char(textdate_20{3}));

Fs=100;         %采样率
conver=100;     %txt数据单位为gal时为：100；单位为count时：50000（MSI）、100000（MSA）
f1=1; f5=5; f10=10; f20=20;           %输入频率
T1=30; T5=10; T10=5; T20=5;          %输入时间长度s，根据实际情况修改，最好选取中间稳定一段
L1=T1*Fs; L5=T5*Fs;L10=T10*Fs; L20=T20*Fs;
n=1;    
%1Hz三通道数据
UD1_1=date1_1*n/conver;    
NS2_1=date2_1*n/conver;
EW3_1=date3_1*n/conver;    %单位转换为m/s2
%5Hz三通道数据
UD1_5=date1_5*n/conver;    
NS2_5=date2_5*n/conver;
EW3_5=date3_5*n/conver;    %单位转换为m/s2
%10Hz三通道数据
UD1_10=date1_10*n/conver;    
NS2_10=date2_10*n/conver;
EW3_10=date3_10*n/conver;    %单位转换为m/s2
%20Hz三通道数据
UD1_20=date1_20*n/conver;    
NS2_20=date2_20*n/conver;
EW3_20=date3_20*n/conver;    %单位转换为m/s2
fclose(fid_1); fclose(fid_5); fclose(fid_10); fclose(fid_20);

%% 计算输出有效值
%   UD 1HZ
UD_1=UD1_1(1:T1*Fs); 
X1_1=fft(UD_1-mean(UD_1))*2/L1;
rms_UD_1=abs(X1_1(f1*T1+1))*0.7071;  %傅里叶变化幅值转换为有效值 
Y_UD_1=sqrt((sum((UD_1-mean(UD_1)).^2)/L1));      %标准有效值
% fprintf(' 1Hz \n');
% % fprintf('     UD向输出标准有效值为：%g \n',Y_UD_1);
% % fprintf('UD向输出傅里叶变化有效值为：%g \n',rms_UD_1);
UD_max_1=max(UD_1); UD_min_1=min(UD_1);
%  UD 5HZ
UD_5=UD1_5(1:T5*Fs); 
X1_5=fft(UD_5-mean(UD_5))*2/L5;
rms_UD_5=abs(X1_5(f5*T5+1))*0.7071;  %傅里叶变化幅值转换为有效值 
Y_UD_5=sqrt((sum((UD_5-mean(UD_5)).^2)/L5));      %标准有效值
% fprintf(' 5Hz \n');
% fprintf('     UD向输出标准有效值为：%g \n',Y_UD_5);
% fprintf('UD向输出傅里叶变化有效值为：%g \n',rms_UD_5);
UD_max_5=max(UD_5); UD_min_5=min(UD_5);
%  UD 10HZ
UD_10=UD1_10(1:T10*Fs); 
X1_10=fft(UD_10-mean(UD_10))*2/L10;
rms_UD_10=abs(X1_10(f10*T10+1))*0.7071;  %傅里叶变化幅值转换为有效值 
Y_UD_10=sqrt((sum((UD_10-mean(UD_10)).^2)/L10));      %标准有效值
% fprintf(' 10Hz \n');
% fprintf('     UD向输出标准有效值为：%g \n',Y_UD_10);
% fprintf('UD向输出傅里叶变化有效值为：%g \n',rms_UD_10);
UD_max_10=max(UD_10); UD_min_10=min(UD_10);
%  UD 20HZ
UD_20=UD1_20(1:T20*Fs); 
X1_20=fft(UD_20-mean(UD_20))*2/L20;
rms_UD_20=abs(X1_20(f20*T20+1))*0.7071;  %傅里叶变化幅值转换为有效值 
Y_UD_20=sqrt((sum((UD_20-mean(UD_20)).^2)/L20));      %标准有效值
% fprintf(' 20Hz \n');
% fprintf('     UD向输出标准有效值为：%g \n',Y_UD_20);
% fprintf('UD向输出傅里叶变化有效值为：%g \n',rms_UD_20);
UD_max_20=max(UD_20); UD_min_20=min(UD_20);

%   NS 1HZ
NS_1=NS2_1(1:T1*Fs);
X2_1=fft(NS_1-mean(NS_1))*2/L1;
rms_NS_1=abs(X2_1(f1*T1+1))*0.7071; %傅里叶变化幅值转换为有效值 
Y_NS_1=sqrt((sum((NS_1-mean(NS_1)).^2)/L1));     %标准有效值 
% fprintf('     NS向输出标准有效值为：%g \n',Y_NS_1);
% fprintf('NS向输出傅里叶变化有效值为：%g \n',rms_NS_1);
NS_max_1=max(NS_1);  NS_min_1=min(NS_1);
%   NS 5HZ
NS_5=NS2_5(1:T5*Fs);
X2_5=fft(NS_5-mean(NS_5))*2/L5;
rms_NS_5=abs(X2_5(f5*T5+1))*0.7071; %傅里叶变化幅值转换为有效值 
Y_NS_5=sqrt((sum((NS_5-mean(NS_5)).^2)/L5));     %标准有效值 
% fprintf('     NS向输出标准有效值为：%g \n',Y_NS_5);
% fprintf('NS向输出傅里叶变化有效值为：%g \n',rms_NS_5);
NS_max_5=max(NS_5);  NS_min_5=min(NS_5);
%   NS 10HZ
NS_10=NS2_10(1:T10*Fs);
X2_10=fft(NS_10-mean(NS_10))*2/L10;
rms_NS_10=abs(X2_10(f10*T10+1))*0.7071; %傅里叶变化幅值转换为有效值 
Y_NS_10=sqrt((sum((NS_10-mean(NS_10)).^2)/L10));     %标准有效值 
% fprintf('     NS向输出标准有效值为：%g \n',Y_NS_10);
% fprintf('NS向输出傅里叶变化有效值为：%g \n',rms_NS_10);
NS_max_10=max(NS_10);  NS_min_10=min(NS_10);
%   NS 20HZ
NS_20=NS2_20(1:T20*Fs);
X2_20=fft(NS_20-mean(NS_20))*2/L20;
rms_NS_20=abs(X2_20(f20*T20+1))*0.7071; %傅里叶变化幅值转换为有效值 
Y_NS_20=sqrt((sum((NS_20-mean(NS_20)).^2)/L20));     %标准有效值 
% fprintf('     NS向输出标准有效值为：%g \n',Y_NS_20);
% fprintf('NS向输出傅里叶变化有效值为：%g \n',rms_NS_20);
NS_max_20=max(NS_20);  NS_min_20=min(NS_20);

%  EW 1HZ
EW_1=EW3_1(1:T1*Fs);
X3_1=fft(EW_1-mean(EW_1))*2/L1;
rms_EW_1=abs(X3_1(f1*T1+1))*0.7071;  %傅里叶变化幅值转换为有效值 
Y_EW_1=sqrt((sum((EW_1-mean(EW_1)).^2)/L1));     %标准有效值 
% fprintf('     NS向输出标准有效值为：%g \n',Y_EW_1);
% fprintf('NS向输出傅里叶变化有效值为：%g \n',rms_EW_1);
EW_max_1=max(EW_1); EW_min_1=min(EW_1);
%  EW 5HZ
EW_5=EW3_5(1:T5*Fs);
X3_5=fft(EW_5-mean(EW_5))*2/L5;
rms_EW_5=abs(X3_5(f5*T5+1))*0.7071;  %傅里叶变化幅值转换为有效值 
Y_EW_5=sqrt((sum((EW_5-mean(EW_5)).^2)/L5));     %标准有效值 
% fprintf('     NS向输出标准有效值为：%g \n',Y_EW_5);
% fprintf('NS向输出傅里叶变化有效值为：%g \n',rms_EW_5);
EW_max_5=max(EW_5); EW_min_5=min(EW_5);
%  EW 10HZ
EW_10=EW3_10(1:T10*Fs);
X3_10=fft(EW_10-mean(EW_10))*2/L10;
rms_EW_10=abs(X3_10(f10*T10+1))*0.7071;  %傅里叶变化幅值转换为有效值 
Y_EW_10=sqrt((sum((EW_10-mean(EW_10)).^2)/L10));     %标准有效值 
% fprintf('     NS向输出标准有效值为：%g \n',Y_EW_10);
% fprintf('NS向输出傅里叶变化有效值为：%g \n',rms_EW_10);
EW_max_10=max(EW_10); EW_min_10=min(EW_10);
%  EW 20HZ
EW_20=EW3_20(1:T20*Fs);
X3_20=fft(EW_20-mean(EW_20))*2/L20;
rms_EW_20=abs(X3_20(f20*T20+1))*0.7071;  %傅里叶变化幅值转换为有效值 
Y_EW_20=sqrt((sum((EW_20-mean(EW_20)).^2)/L20));     %标准有效值 
% fprintf('     NS向输出标准有效值为：%g \n',Y_EW_20);
% fprintf('NS向输出傅里叶变化有效值为：%g \n',rms_EW_20);
EW_max_20=max(EW_20); EW_min_20=min(EW_20);

fprintf(' 1Hz                 Z轴         Y轴         X轴\n');
fprintf('      标准有效值为：%g    %g  %g \n',Y_UD_1,Y_NS_1,Y_EW_1);
fprintf('傅里叶变化有效值为：%g    %g  %g \n',rms_UD_1,rms_NS_1,rms_EW_1);
fprintf(' 5Hz                 Z轴         Y轴         X轴\n');
fprintf('      标准有效值为：%g    %g  %g \n',Y_UD_5,Y_NS_5,Y_EW_5);
fprintf('傅里叶变化有效值为：%g    %g  %g \n',rms_UD_5,rms_NS_5,rms_EW_5);
fprintf(' 10Hz                Z轴         Y轴         X轴\n');
fprintf('      标准有效值为：%g    %g  %g \n',Y_UD_10,Y_NS_10,Y_EW_10);
fprintf('傅里叶变化有效值为：%g    %g  %g \n',rms_UD_10,rms_NS_10,rms_EW_10);
fprintf(' 20Hz                Z轴         Y轴         X轴\n');
fprintf('      标准有效值为：%g    %g  %g \n',Y_UD_20,Y_NS_20,Y_EW_20);
fprintf('傅里叶变化有效值为：%g    %g  %g \n',rms_UD_20,rms_NS_20,rms_EW_20);

figure(1)
subplot(3,1,1)
t1=1/Fs:1/Fs:L1/Fs;
plot(t1,UD1_1,'b')
ylabel('m/s2');
xlabel('时间(s)');
title('1Hz_通道1-UD')
subplot(3,1,2)
t1=1/Fs:1/Fs:L1/Fs;
plot(t1,NS2_1,'r')
ylabel('m/s2');
xlabel('时间(s)');
title('1Hz_通道2-NS')
subplot(3,1,3)
t1=1/Fs:1/Fs:L1/Fs;
plot(t1,EW3_1,'g')
ylabel('m/s2');
xlabel('时间(s)');
title('1Hz_通道3-EW')

