function amplitude=lsf_amplitude(time,data)
%% Calculate annual amplitude of a time series
A=[ones(size(data,1),1) time-time(1) cos(2*pi*time) sin(2*pi*time) cos(4*pi*time) sin(4*pi*time)];
B=data;
coeff=lscov(A,B);
amplitude=(coeff(3,:).^2+coeff(4,:).^2).^0.5;
amplitude=amplitude';
end