clc;clear;
close all
clear all
fid=fopen('E:\Huhui\Project\Boyuan\DataProcessor\DataProcessor\MSA30\Y\100sps\幅频特性\1.txt','rt'); %文件名，根据实际情况修改
if( fid==-1 ) 
    error('无法打开文件');
end
tline1=fgetl(fid);
textdate=textscan(fid,'%s %s %s %s %s');
%读取三通道数据
date1=str2num(char(textdate{1}));
date2=str2num(char(textdate{2}));
date3=str2num(char(textdate{3}));

Fs=100;         %采样率
conver=100000;     %txt数据单位为gal时为：100；单位为count时：50000（MSI）、100000（MSA）
n=1;                   % 设置调整倍数//自测验证用（禁改）
UD1=date1*n/conver;    
NS2=date2*n/conver;
EW3=date3*n/conver;    %单位转换为m/s2
fclose(fid);

%% 计算输出有效值
f=1;           %输入频率
T1=30;           %输入时间长度s，根据实际情况修改，最好选取中间稳定一段
UD=UD1(1:T1*Fs);
L1=length(UD);     %数据长度
mean1=mean(UD);
x1=UD-mean1;
X1=fft(x1)*2/L1;
fprintf('\n通道1-UD向输出有效值：\n');
rms_UD=abs(X1(f*T1+1))*0.7071  %傅里叶变化幅值转换为有效值 
Y_UD=sqrt((sum(x1.^2)/L1))      %标准有效值
UD_max=max(UD)
UD_min=min(UD)

NS=NS2(1:T1*Fs);
L2=length(NS);     %数据长度
mean2=mean(NS);
x2=NS-mean2;
X2=fft(x2)*2/L2;
fprintf('\n通道2-NS向输出有效值：\n');
rms_NS=abs(X2(f*T1+1))*0.7071 %傅里叶变化幅值转换为有效值 
Y_NS=sqrt((sum(x2.^2)/L2))     %标准有效值 
NS_max=max(NS)
NS_min=min(NS)

EW=EW3(1:T1*Fs);
L3=length(EW);     %数据长度
mean3=mean(EW);
x3=EW-mean3;
X3=fft(x3)*2/L3;
fprintf('\n通道3-EW向输出有效值：\n');
rms_EW=abs(X3(f*T1+1))*0.7071  %傅里叶变化幅值转换为有效值 
Y_EW=sqrt((sum(x3.^2)/L3))     %标准有效值 
EW_max=max(EW)
EW_min=min(EW)

figure(1)
subplot(3,1,1)
t1=1/Fs:1/Fs:L1/Fs;
plot(t1,UD1,'b')
ylabel('m/s2');
xlabel('时间(s)');
title('通道1-UD')

subplot(3,1,2)
t1=1/Fs:1/Fs:L2/Fs;
plot(t1,NS2,'r')
ylabel('m/s2');
xlabel('时间(s)');
title('通道2-NS')

subplot(3,1,3)
t1=1/Fs:1/Fs:L3/Fs;
plot(t1,EW3,'g')
ylabel('m/s2');
xlabel('时间(s)');
title('通道3-EW')

