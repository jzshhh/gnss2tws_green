%% Constants
global Aq Gq gq pw;
Aq=6371000; Gq=6.67259*10^-11;gq=9.8242;pw =1000;

%% Study period
timespan=[20060101 20201231];

%% GNSS data
udir='data/gnss';form='*.up';stafile='data/sites.info';

%% PCA decomposition
num_pc=2;

%% Study area
alph=0.25;
long=-126:alph:-106; lat=38:alph:52;
study_area_border=load('data/PNEB_border_buffer.dat');
n_neighbours=4;

%% Inversion
lap_weight = 0.018;
inversion_flag='LS'; % 'lsqlin'£¬ 'pinv'

%% Plotting
boundary_file='data/PNEB_border.dat';
[long_bou, lat_bou]=textread(boundary_file,'%f %f','commentstyle','shell');
boundary=[long_bou lat_bou];
is_plot_U_V=1; is_plot_amp=1;is_plot_ewh_ts=1;is_plot_vcd_ts=0;
