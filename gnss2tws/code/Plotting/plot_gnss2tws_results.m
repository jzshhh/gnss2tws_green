% Main function of plotting figures
if is_plot_U_V==1
    plot_gnss_vcd_L_U(GNSS_times,GNSS_positions,coeff,scores,boundary); % plot figure of spatial and temporal functions for each component
end
if is_plot_amp==1
    plot_amplitude_vcd_ewh(GNSS_times,long,lat,GNSS_positions,data_recon,area_grid,ewh,boundary); % maps of annual amplitudes of vertical crustal displacements and EWH
end
if is_plot_ewh_ts==1
    plot_area_ewh_time_series(GNSS_times,area_grid,ewh,boundary) % figure of regional averaged EWH time series 
end
if is_plot_vcd_ts==1
    plot_gnss_time_series(GNSS_sites,GNSS_times,GNSS_data,data_pre); % figures of GNSS observed and predicted time series at all stations.
end

