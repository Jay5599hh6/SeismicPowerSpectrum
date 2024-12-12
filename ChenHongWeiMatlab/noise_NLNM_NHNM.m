clc;clear;
close all

% 定义NLNM和NHNM数据
NLNM_T = [600, 328, 154, 101, 70, 45, 31.6, 21.9, 15.6, ...
          12, 10, 6, 5, 4.3, 2.4, 1.24, 0.8, 0.4, 0.17, 0.1];
NLNM_DB = [-184.381, -187.491, -184.987, -185, -187.5, -187.5, -184.995, -177.505, ...
           -162.129, -166.247, -163.750, -148.999, -141.096, -141.1, -148.646, -163.697, ...
           -169.201, -166.697, -166.7, -168];
NHNM_T = [354.8, 20, 15.4, 7.9, 6.3, 4.6, 3.8, 0.8, 0.32, 0.22, 0.1];
NHNM_DB = [-126, -138.5, -120, -113.5, -101, -96.5, -98, -120, -110.5, -97.4, -91.5];

% 将NLNM_T和NHNM_T转换为频率
NLNM_F = 1 ./ NLNM_T;
NHNM_F = 1 ./ NHNM_T;

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

% 转换数据列为数字
try
    date1 = str2double(textdate{1});
    date2 = str2double(textdate{2});
    date3 = str2double(textdate{3});
catch
    error('文件格式不符合预期，请检查是否包含三通道数据');
end

% 设置采样和转换参数
n = 1;              % 调整倍数
rate = 100;         % 采样率 (Hz)
conver = 1.0/ 100000; % count 转换为加速度 (m/s^2)   强震仪转换
% conver = 1.0/ 50000; % count 转换为加速度 (m/s^2)   烈度仪转换


% 选择并去均值
UD = (date1 - mean(date1)) * n * conver;
NS = (date2 - mean(date2)) * n * conver;
EW = (date3 - mean(date3)) * n * conver;

UD_a = date1* conver;
NS_a = date1* conver;
EW_a = date1* conver;

% 去趋势
UD_det = detrend(UD);
NS_det = detrend(NS);
EW_det = detrend(EW);

disp(['length(UD)=',num2str(length(UD))]);
disp(['length(NS)=',num2str(length(NS))]);
disp(['length(EW)=',num2str(length(EW))]);

% Welch 方法计算功率谱
window = hamming(32768);
noverlap = 16384;
nfft = 32768;
dataL = length(UD); % 数据长度
[psd_UD, f] = pwelch(UD_det, window,noverlap, nfft, rate);
[psd_NS, f] = pwelch(NS_det, window, noverlap, nfft, rate);
[psd_EW, f] = pwelch(EW_det, window, noverlap, nfft, rate);
% [psd_UD, f] = pwelch(UD_det, floor(dataL / 10), floor(dataL / 20), floor(dataL / 10), rate);
% [psd_NS, f] = pwelch(NS_det, floor(dataL / 10), floor(dataL / 20), floor(dataL / 10), rate);
% [psd_EW, f] = pwelch(EW_det, floor(dataL / 10), floor(dataL / 20), floor(dataL / 10), rate);

%  psd_UD = psd_UD.*f.*f*4*pi*pi; %速度功率谱转换为加速度功率谱
%  psd_NS = psd_NS.*f.*f*4*pi*pi; %速度功率谱转换为加速度功率谱
%  psd_EW = psd_EW.*f.*f*4*pi*pi; %速度功率谱转换为加速度功率谱
pdb_UD = 10*log10(psd_UD);    %转化为分贝
pdb_NS = 10*log10(psd_NS);
pdb_EW = 10*log10(psd_EW);

disp(length(f));
disp(length(psd_UD));
disp(length(psd_NS));
disp(length(psd_EW));
 
figure(1);
subplot(3,1,1);
plot(UD_a,'r');
set(gca,'xlim',[0  dataL]);     %720000
% 设置当前坐标轴（由 gca 返回的坐标轴句柄）上的X轴显示范围。
% X轴的范围从 0 到 dataL，dataL 通常是数据的长度，确保X轴能够覆盖数据的整个范围。
title('UD ');
grid on;
ylabel('加速度/m/²');
subplot(3,1,2);
plot(NS_a,'g');
set(gca,'xlim',[0  dataL]);     %720000
title('NS ');
grid on;
ylabel('加速度/m/²');
subplot(3,1,3);
plot(EW_a,'b');
set(gca,'xlim',[0  dataL]);     %720000
title('EW ');
grid on;
ylabel('加速度/m/²');

figure(2);
subplot(1,1,1);
semilogx(f,pdb_UD,'r');
hold on
semilogx(f,pdb_NS,'g');
hold on
semilogx(f,pdb_EW,'b');
hold on
semilogx(NLNM_F, NLNM_DB, 'k','LineWidth', 3, 'DisplayName', 'NLNM');
hold on
semilogx(NHNM_F, NHNM_DB,  'k--','LineWidth', 3, 'DisplayName', 'NHNM');
title('Self Noise Power Spectra');
grid on;
xlabel('f <Hz>');   
ylabel('Power Spectrum Density <dB/Hz>');
legend('psdUD','psdNS','psdEW','NLNM','NHNM');

fH = 20;   %40  0.2
fL = 0.01;  %0.01  0.001
N = floor(dataL/10);
iL = floor(N*fL/rate);
iH = floor(N*fH/rate);
% rms_UD = sqrt((fH-fL)/(1+iH-iL)*sum(psd_UD(iL:iH)));   %单位V
% rms_NS = sqrt((fH-fL)/(1+iH-iL)*sum(psd_NS(iL:iH)));   %单位V
% rms_EW = sqrt((fH-fL)/(1+iH-iL)*sum(psd_EW(iL:iH)));   %单位V

mu_UD = mean(UD);  % 计算UD通道的均值
mu_NS = mean(NS);  % 计算NS通道的均值
mu_EW = mean(EW);  % 计算EW通道的均值

% 计算并输出每个通道的RMS和dB值
rms_UD = sqrt((1/(length(UD)-1)) * sum((UD).^2));  % 计算UD通道的RMS
rms_NS = sqrt((1/(length(NS)-1)) * sum((NS).^2));  % 计算NS通道的RMS
rms_EW = sqrt((1/(length(EW)-1)) * sum((EW).^2));  % 计算EW通道的RMS
% rms_UD = sqrt((1/(length(UD)-1)) * sum((UD - mu_UD).^2));  % 计算UD通道的RMS
% rms_NS = sqrt((1/(length(NS)-1)) * sum((NS - mu_NS).^2));  % 计算NS通道的RMS
% rms_EW = sqrt((1/(length(EW)-1)) * sum((EW - mu_EW).^2));  % 计算EW通道的RMS

selfnoiserms_UD = rms_UD
% offsetreslut_UD = offset_UD

selfnoiserms_NS = rms_NS
% offsetreslut_NS = offset_NS

selfnoiserms_EW = rms_EW
% offsetreslut_EW = offset_EW
