clear; clc; 
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Setting paths and loading scenario
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
code_dir = [pwd '\code'];
disp('Setting Paths...');
addpath(genpath(code_dir));
disp('Loading Scenario Information...')
load_scenario;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Loading GPS data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Loading Data...');
[GNSS_sites,GNSS_positions,GNSS_times,GNSS_data]=load_GNSS(udir,form,stafile,timespan);
disp('Data Loaded.');

save result/gnss_data.mat 
load result/gnss_data.mat 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Decomposition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Decompositing');
[coeff,scores,all_pc_explained,each_pc_explained,data_recon]=gnss_pca(GNSS_data,num_pc);
disp('Decomposition Completed');

save result/pca_decomposition.mat 
load result/pca_decomposition.mat 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Generating Green's functions and Laplacian matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Building Area model');
area_grid=make_area_grid(long,lat,study_area_border);
Green=is_compute_greens(GNSS_positions,area_grid,GNSS_sites,alph);
Lap=compute_laplacian(area_grid,n_neighbours);
disp('Area model Completed');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Determining smoothing factor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run('GCV_smooth_factor.m');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Inversion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Starting Inversion');
ewh_pc=inversion_model(Green,coeff,Lap,lap_weight,inversion_flag);
disp('Inversion Finished');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Restructure and building Predictions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Restructure total TWS changes and create predictions');
[ewh, data_pre]=recon_ewh_predi_vcd(scores,ewh_pc,Green);
disp('Restructurion Finished');

save result/gps_ewh.mat ewh GNSS_times area_grid;
save result/vcd_ewh_pc.mat ewh_pc GNSS_times  GNSS_sites GNSS_positions coeff scores each_pc_explained area_grid;
save result/obs_pre.mat GNSS_sites GNSS_positions GNSS_times GNSS_data data_recon data_pre;
save Inversion_TWS.mat;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot/display information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Plot and display results');
run('plot_gnss2tws_results.m');
run('checkerboard_test.m');
disp('End all');

close all;




