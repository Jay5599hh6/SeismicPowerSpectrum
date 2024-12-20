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

figure();
semilogx(NLNM_F, NLNM_DB, 'r','LineWidth', 3, 'DisplayName', 'NLNM');
hold on
semilogx(NHNM_F, NHNM_DB,  'r','LineWidth', 3, 'DisplayName', 'NHNM');

