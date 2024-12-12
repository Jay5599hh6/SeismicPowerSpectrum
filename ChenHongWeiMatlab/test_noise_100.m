clear all；
w1=[];w2=[];w3=[];
clc;clear;
close all
clear all
station='C:\Users\Lenovo\Desktop\2023第二批定型\武汉博远\六通道\B\noise-re-b';
UDfiles=dir(station)
for  fn=3:3
close all;                     
fileNameUD=UDfiles(fn).name;    
fid=fopen([station '/' fileNameUD],'r');  
tline1=fgetl(fid);
% [data,text] = xlsread([station '/' fileNameUD ],2);
textdate=textscan(fid,'%s %s %s %s %s %s %s');
%tline2=fgetl(fid);
date1=str2num(char(textdate{1}));
date2=str2num(char(textdate{2}));
date3=str2num(char(textdate{3}));

w1=date1;
w2=date2;                   
w3=date3;
end;

%  [w1,w2,w3,srate,insname] = load_edas_asc('B.txt');
%   [w1,w2,w3,srate,insname] = load_edas_asc('noiseA50.txt');
%   [w1,w2,w3,srate] = load_edas_dat('19700101090523_00.dat');
  
%  NAME1 = 'HNZ'; NAME2 =  'HNE'; NAME3 = 'HNN';     %KineA
%   NAME1 = 'HHZ'; NAME2 =  'HHE'; NAME3 = 'HHN';     %guralp
%  NAME1 = 'HLZ'; NAME2 =  'HLE'; NAME3 = 'HLN';     %reftek
%   NAME1 = 'UD '; NAME2 =  'EW '; NAME3 = 'NS ';     %tianyuan
%  NAME1 = 'HNZ'; NAME2 =  'HNN'; NAME3 = 'HNE';     %TDE
%   NAME1 = 'HNN'; NAME2 =  'HNE'; NAME3 = 'HNZ';
%   NAME1 = 'UD '; NAME2 =  'EW '; NAME3 = 'NS ';     %tianyuan
%   NAME1 = 'HHZ'; NAME2 =  'HHX'; NAME3 = 'HHY';     %nanoA
%   NAME1 = 'HNZ'; NAME2 =  'HNX'; NAME3 = 'HNY';     %nanoB
% NAME1 = 'HNZ'; NAME2 =  'HNE'; NAME3 = 'HNN';     %TDE
% NAME1 = 'HHZ'; NAME2 =  'HHE'; NAME3 = 'HHN';     %reftek
%  NAME1 = 'LMZ'; NAME2 =  'LME'; NAME3 = 'LMN';     %reftek
%   NAME1 = 'ELZ'; NAME2 =  'ELE'; NAME3 = 'ELN';     %reftek
%  NAME1 = 'EHZ'; NAME2 =  'EHE'; NAME3 = 'EHN';     %reftek
%  NAME1 = 'BHZ'; NAME2 =  'BHE'; NAME3 = 'BHN';     %reftek
% aa = rdmseed('YGD_3334sst2_20240118100000.conti_id1012-0.mseed');
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

 conver =0.2;              %转换因子FS/2^bit（μV/count）
%  conver =10*10^6/2^27;              %转换因子FS/2^bit（μV/count）
% conver =5*10^6/2^27;              %转换因子FS/2^bit（μV/count）
%  conver =0.01953;           %转换因子FS/2^bit（μV/count）375
%  conver=0.009313;                      %uV/count
%  conver=0.149;                      %uV/count
%  conver =0.0374*10^-6;
% conver = 37.4*10^-3; 
 rate =100;                        
% conver = 3.278;
%  conver =2.441; 
% conver =0.149;    %量程正负20V
 
% w1=w1(200000:370000);
% w2=w2(200000:370000);
% w3=w3(200000:370000);

 dataL =120000;
% dataL =10000;
%% minseed
figure(9);
subplot(3,1,1);
plot(w1);
 subplot(3,1,2);
plot(w2);
subplot(3,1,3);
plot(w3);
[x,y] = ginput(1);
x(1) = floor(x(1));
     
w1 = w1(x(1):x(1)+dataL-1);
w2 = w2(x(1):x(1)+dataL-1);
w3 = w3(x(1):x(1)+dataL-1);

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

%%

for i = 1:1:3
    switch i
        case 1 
           dataL = length(w1);
            ww = w1(1:dataL);
        case 2 
           dataL = length(w2);
            ww = w2(1:dataL);
        case 3 
           dataL = length(w3);
            ww = w3(1:dataL);
    end

t=[0:0.01:dataL/rate-0.01];
t=t';
 
    if dataL == 0
        continue
    end
   
%     ww = ww(1:360000);          %数据范围 
    offset(i) = mean(ww);   %单位V
    ww = detrend(ww)*conver;      %count值转化为电压值
    [psd,f] = pwelch(ww,floor(dataL/10),floor(dataL/20),floor(dataL/10),rate);   %5-10分钟，窗值再除2
    pdb = 10*log10(psd);     %转化为分贝

    figure(i);
    subplot(2,1,1);
    plot(t,ww);
    set(gca,'xlim',[0  dataL/100]); %720000
    title('Self Noise Time Series');
    xlabel('t / s');
    ylabel('Signal / uV');
    subplot(2,1,2);
    semilogx(f,pdb);
    title('Self Noise Power Spectra');
    grid on;
    xlabel('f / Hz');
    ylabel('Power Spectrum Density / μV^2/Hz');

    fH = 40;   %40  0.2
    fL = 0.01;  %0.01  0.001
    N = floor(dataL/10);
    iL = ceil(N*fL/rate)+1;
    iH = floor(N*fH/rate)+1;
    rms(i) = sqrt((fH-fL)/(1+iH-iL)*sum(psd(iL:iH)));   %单位V
    DR(i)=20*log10(200000/(2*rms(i)));
end
selfnoiserms = rms;
offsetreslut = offset*conver/200000;
