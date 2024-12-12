clear all；
w1=[];w2=[];w3=[];
clc;clear;
close all
clear all
station='A';
UDfiles=dir(station);
for  fn=3:3
close all;                     
fileNameUD=UDfiles(fn).name;     %璇籙D鐨勫ご娈?
fid=fopen([station '/' fileNameUD],'r');  
tline1=fgetl(fid);
% [data,text] = xlsread([station '/' fileNameUD ],2);
textdate=textscan(fid,'%s %s %s %s %s %s %s');
%tline2=fgetl(fid);
%璇诲彇涓夐?閬撴暟鎹?
date1=str2num(char(textdate{1}));
date2=str2num(char(textdate{2}));
date3=str2num(char(textdate{3}));

w1=date1;
w2=date2;                    % 閫夋嫨閫氶亾
w3=date3;
end;
%    [w1,w2,w3,srate,insname] = load_edas_asc('12.txt');
%    [w1,w2,w3,srate] = load_edas_dat('1970012908344703__00_28.dat');
%  NAME1 = 'HNZ'; NAME2 =  'HNE'; NAME3 = 'HNN';     %KineA
%  NAME1 = 'HHZ'; NAME2 =  'HHE'; NAME3 = 'HHN';     %guralp
%  NAME1 = 'HHZ'; NAME2 =  'HHX'; NAME3 = 'HHY';     %nanoA
%  NAME1 = 'HNZ'; NAME2 =  'HNX'; NAME3 = 'HNY';     %nanoB
% NAME1 = 'HLZ'; NAME2 =  'HLE'; NAME3 = 'HLN';     %reftek
%  NAME1 = 'UD '; NAME2 =  'EW '; NAME3 = 'NS ';     %tianyuan
%  NAME1 = 'HNZ'; NAME2 =  'HNN'; NAME3 = 'HNE';     %TDE
%  NAME1 = 'HNN'; NAME2 =  'HNE'; NAME3 = 'HNZ'; %reftek深研院2

%  NAME1 = 'HHN'; NAME2 =  'HHE'; NAME3 = 'HHZ';     %深研院1
%  NAME1 = 'BHZ'; NAME2 =  'BHE'; NAME3 = 'BHN';     %reftek
%  NAME1 = 'LMZ'; NAME2 =  'LME'; NAME3 = 'LMN';     %reftek
%  NAME1 = 'ELZ'; NAME2 =  'ELE'; NAME3 = 'ELN';     %reftek 
%  NAME1 = 'HHZ'; NAME2 =  'HHE'; NAME3 = 'HHN';     %EDAS
% NAME1 = 'HNN'; NAME2 =  'HNE'; NAME3 = 'HNZ';
%  NAME1 = 'BHZ'; NAME2 =  'BHE'; NAME3 = 'BHN';     %reftek
% aa = rdmseed('YGD_3334sst2_20240118090232.conti_id1012-1.mseed');
% for i = 1:length(aa)
%    switch aa(i).ChannelIdentifier
%         case NAME1
%             w1 = [w1,aa(i).d'];
%         case NAME2
%             w2 = [w2,aa(i).d'];
%         case NAME3
%             w3 = [w3,aa(i).d'];        
%    end
% end

% w2=w1;
% w3=w1;
%  w1 = w1(1:40000);            %处理单通道数据
%  w2 = w2(1:40000);            %处理单通道数据
%  w3 = w3(1:40000);            %处理单通道数据

rate = 100;            %设置采样率
dataS =120;           %数据长度s 120
dataL = rate*dataS;    %数据长度count
%   conver = 20*2/2^28;    %V
%   conver =375*10^-6;      %V/count 0.0374 375   40/(2^(28))
%   conver = 2.384*10^-6;
%   conver =0.0374*10^-6;
%  conver =20*2/2^32;
%  conver = 0.149*10^-6;
conver =0.2*10^-6;
t=[0:0.01:dataS-0.01];

figure(9);
subplot(3,1,1);
plot(w1);
subplot(3,1,2);
plot(w2);
subplot(3,1,3);
plot(w3);
[x,y] = ginput(1);
x(1) = floor(x(1));
     
ww1 = w1(x(1):x(1)+dataL-1);
ww2 = w2(x(1):x(1)+dataL-1);
ww3 = w3(x(1):x(1)+dataL-1);
    
    subplot(3,1,1);
    ylim = get(gca,'ylim');
    hold on;
    plot([x(1) x(1)],ylim,'r');
    plot([x(1)+dataL-1 x(1)+dataL-1],ylim,'m');
    subplot(3,1,2);
    ylim = get(gca,'ylim');
    hold on;
    plot([x(1) x(1)],ylim,'r');
    plot([x(1)+dataL-1 x(1)+dataL-1],ylim,'m');
    subplot(3,1,3);
    ylim = get(gca,'ylim');
    hold on;
    plot([x(1) x(1)],ylim,'r');
    plot([x(1)+dataL-1 x(1)+dataL-1],ylim,'m');
n = length(ww1);
c=hanning(n);
m = floor(n/2);
W1 = fft(hanning(n).* detrend(ww1));
W2 = fft(hanning(n).* detrend(ww2));
W3 = fft(hanning(n).* detrend(ww3));

A1 = abs(W1(1:m));
A2 = abs(W2(1:m));
A3 = abs(W3(1:m));

f=1:1:m;
f=(f-1)/n*rate;

figure(1);
subplot(1,2,2);
semilogy(f,A1/max(A1));%semilogy
%xlabel('Normalization of 1 Hz');
set(gca,'ylim',[1e-10 1]);
set(gca,'xlim',[0 50]);
grid on;
xlabel('f / Hz');
title('fft(UD)');
ylabel('Normalized Amplitude Spectrum');
subplot(1,2,1);
plot(t,ww1*conver);
set(gca,'ylim',[-11 11]);
xlim([0 4])
title('Time Series(UD)');
xlabel('t / s');
ylabel('Signal / V');

figure(2);
subplot(1,2,2);
semilogy(f,A2/max(A2));%semilogy
%xlabel('Normalization of 1 Hz');
set(gca,'ylim',[1e-10 1]);
set(gca,'xlim',[0 50]);
grid on;
xlabel('f / Hz');
title('fft(EW)');
ylabel('Normalized Amplitude Spectrum');
subplot(1,2,1);
plot(t,ww1*conver);
set(gca,'ylim',[-11 11]);
xlim([0 4])
title('Time Series(EW)');
xlabel('t / s');
ylabel('Signal / V');

figure(3);
subplot(1,2,2);
semilogy(f,A3/max(A3));%semilogy
%xlabel('Normalization of 1 Hz');
% set(gca,'ylim',[1e-10 1]);
set(gca,'xlim',[0 50]);
grid on;
xlabel('f / Hz');
title('fft(NS)');
ylabel('Normalized Amplitude Spectrum');
subplot(1,2,1);
plot(t,ww1*conver);
set(gca,'ylim',[-11 11]);
xlim([0 4])
title('Time Series(NS)');
xlabel('t / s');
ylabel('Signal / V');

THD(1) = sqrt((10^(thd(ww1)/10))/(1+10^(thd(ww1)/10)))*100;   %采样率
THD(2) = sqrt((10^(thd(ww2)/10))/(1+10^(thd(ww2)/10)))*100;
THD(3) = sqrt((10^(thd(ww3)/10))/(1+10^(thd(ww3)/10)))*100;

THD





