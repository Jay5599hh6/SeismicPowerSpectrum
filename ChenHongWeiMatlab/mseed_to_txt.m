clear all;
clc;
UD=[];NS=[];EW=[];
%  [w1,w2,w3,srate,insname] = load_edas_asc('thd.txt');
%  [w1,w2,w3,srate] = load_edas_dat('2023013117252406__01_28.dat');

NAME1 = 'HHZ'; NAME2 =  'HHE'; NAME3 = 'HHN';     %guralp

UD1 = rdmseed('BYDBS012024080814.mseed');
%NS1 = rdmseed('NS2.mseed');
%EW1 = rdmseed('EW2.mseed');
for i = 1:length(UD1)
   switch UD1(i).ChannelIdentifier
        case NAME1
            UD = [UD,UD1(i).d'];
   end
end
% for i = 1:length(NS1)
%    switch NS1(i).ChannelIdentifier
%         case NAME3
%             NS = [NS,NS1(i).d'];
%    end
% end
% for i = 1:length(EW1)
%    switch EW1(i).ChannelIdentifier
%         case NAME2
%             EW = [EW,EW1(i).d'];
%    end
% end
fileUD=fopen('Z.txt','w');
% fileNS=fopen('Y.txt','w');
% fileEW=fopen('X.txt','w');
fprintf(fileUD,'%1d\n',UD);
% fprintf(fileNS,'%1d\n',NS);
% fprintf(fileEW,'%1d\n',EW);
fclose(fileUD);
% fclose(fileNS);
% fclose(fileEW);

L1=length(UD)
% L2=length(NS)
% L3=length(EW)
Fs=100;
figure(1)
subplot(3,1,1)
t1=1/Fs:1/Fs:L1/Fs;
plot(t1,UD,'b')
ylabel('V');
xlabel('时间(s)');
title('通道1-UD')
% subplot(3,1,2)
% t1=1/Fs:1/Fs:L2/Fs;
% plot(t1,NS,'b')
% ylabel('V');
% xlabel('时间(s)');
% title('通道1-NS')
% subplot(3,1,3)
% t1=1/Fs:1/Fs:L3/Fs;
% plot(t1,EW,'b')
% ylabel('V');
% xlabel('时间(s)');
% title('通道1-EW')

