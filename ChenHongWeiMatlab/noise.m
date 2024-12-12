clc;clear;
close all
clear all
% fid=fopen('D:\stall\wechat\WeChat_File\WeChat Files\wxid_iit5pp6g4upw21\FileStorage\File\2024-12\2024-12-03_16-19after.txt','rt'); %文件名，根据实际情况修改
% if( fid==-1 ) 
%     error('无法打开文件');
% end

% 打开文件选择对话框，让用户选择文件
[file, path] = uigetfile('*.txt', '选择数据文件'); % 只选择txt文件

% 检查是否选择了文件
if file == 0
    error('未选择文件');
end

% 构建文件的完整路径
filePath = fullfile(path, file);
fid = fopen(filePath, 'rt');
% 读取文件内容
try
    fgetl(fid); % 跳过第一行
    textdate = textscan(fid, '%s %s %s %s %s'); % 读取文件数据
    fclose(fid);
catch
    fclose(fid);
    error('文件读取失败，请检查格式');
end

%读取三通道数据
date1=str2num(char(textdate{1}));
date2=str2num(char(textdate{2}));
date3=str2num(char(textdate{3}));
n=1;                          % 设置调整倍数
UD=date1*n;
NS=date2*n;                    % 选择通道
EW=date3*n;

conver =980;              %txt数据单位为gal时为：100；单位为count时：50000（MSI）、100000（MSA） // m/s2
rate = 100;                     %设置采样率（sps）100 1
dataL = length(UD);
ww_UD=UD(1:dataL);
ww_NS=NS(1:dataL);
ww_EW=EW(1:dataL);

%ww = ww(1:360000);          %数据范围 
% offset_UD = mean(ww_UD);       %偏移量
% offset_NS = mean(ww_NS);
% offset_EW = mean(ww_EW);
 ww_UD = detrend(ww_UD)*conver;      %count值转化为电压值
 ww_NS = detrend(ww_NS)*conver; 
 ww_EW = detrend(ww_EW)*conver; 
 
[psd_UD,f] = pwelch(ww_UD,floor(dataL/10),floor(dataL/20),floor(dataL/10),rate);   %5-10分钟，窗值再除2
[psd_NS,f] = pwelch(ww_NS,floor(dataL/10),floor(dataL/20),floor(dataL/10),rate);
[psd_EW,f] = pwelch(ww_EW,floor(dataL/10),floor(dataL/20),floor(dataL/10),rate);
 pdb_UD = 20*log10(psd_UD);    %转化为分贝
 pdb_NS = 20*log10(psd_NS);
 pdb_EW = 20*log10(psd_EW);

 disp(length(f));
 disp(length(psd_UD));
 disp(length(psd_NS));
 disp(length(psd_EW));
 
figure(1);
subplot(3,1,1);
plot(ww_UD,'r');
set(gca,'xlim',[0  dataL]);     %720000
title('UD Self Noise Time Series');
grid on;
ylabel('加速度/gal');
subplot(3,1,2);
plot(ww_NS,'g');
set(gca,'xlim',[0  dataL]);     %720000
title('NS Self Noise Time Series');
grid on;
ylabel('加速度/gal');
subplot(3,1,3);
plot(ww_EW,'b');
set(gca,'xlim',[0  dataL]);     %720000
title('EW Self Noise Time Series');
grid on;
ylabel('加速度/gal');

figure(2);
subplot(1,1,1);
semilogx(f,pdb_UD,'r');
hold on
semilogx(f,pdb_NS,'g');
hold on
semilogx(f,pdb_EW,'b');
title('Self Noise Power Spectra');
grid on;
xlabel('f <Hz>');   
ylabel('Power Spectrum Density <dB/Hz>');

fH = 20;   %40  0.2
fL = 0.01;  %0.01  0.001
N = floor(dataL/10);
iL = floor(N*fL/rate);
iH = floor(N*fH/rate);
% rms_UD = sqrt((fH-fL)/(1+iH-iL)*sum(psd_UD(iL:iH)));   %单位V
% rms_NS = sqrt((fH-fL)/(1+iH-iL)*sum(psd_NS(iL:iH)));   %单位V
% rms_EW = sqrt((fH-fL)/(1+iH-iL)*sum(psd_EW(iL:iH)));   %单位V

mu_UD = mean(ww_UD);  % 计算UD通道的均值
mu_NS = mean(ww_NS);  % 计算NS通道的均值
mu_EW = mean(ww_EW);  % 计算EW通道的均值

% 计算并输出每个通道的RMS和dB值
rms_UD = sqrt((1/(length(ww_UD)-1)) * sum((ww_UD - mu_UD).^2));  % 计算UD通道的RMS
rms_NS = sqrt((1/(length(ww_NS)-1)) * sum((ww_NS - mu_NS).^2));  % 计算NS通道的RMS
rms_EW = sqrt((1/(length(ww_EW)-1)) * sum((ww_EW - mu_EW).^2));  % 计算EW通道的RMS

selfnoiserms_UD = rms_UD
% offsetreslut_UD = offset_UD

selfnoiserms_NS = rms_NS
% offsetreslut_NS = offset_NS

selfnoiserms_EW = rms_EW
% offsetreslut_EW = offset_EW
