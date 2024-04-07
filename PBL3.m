clc;
close all;
clear all;

%%
%folderPath = 'C:\Users\USER\iCloudDrive\학교\4학년\1학기\PBL\ssp126'; 
folderPath = 'C:\Users\turtl\iCloudDrive\학교\4학년\1학기\PBL\ssp126\worldmap';

ncdisp('nshf_MERRA2_2004-2021_1x1.nc');

nshf_data = ncread('nshf_MERRA2_2004-2021_1x1.nc', 'nshf_J_D_YLL');

lon = ncread('nshf_MERRA2_2004-2021_1x1.nc', 'lon');
lat = ncread('nshf_MERRA2_2004-2021_1x1.nc', 'lat');
year = ncread('nshf_MERRA2_2004-2021_1x1.nc', 'year');

amoc_values = readtable('AMOC_RAPID_2004_2021.txt');
amoc_values = table2array(amoc_values);

years = (2004:2021)';

nshf_annual_change = diff(nshf_data, 1, 3);
amoc_annual_change = diff(amoc_values);
correlation_map = zeros(size(nshf_data, 1), size(nshf_data, 2));

for i = 1:size(nshf_data, 1)
    for j = 1:size(nshf_data, 2)

        nshf_change_at_point = squeeze(nshf_annual_change(i, j, :));

        if length(nshf_change_at_point) == length(amoc_annual_change)
            correlation_map(i, j) = corr(nshf_change_at_point, amoc_annual_change, 'Rows', 'complete');
        else
            correlation_map(i, j) = NaN; 
        end
    end
end

worldmap('World')
pcolorm(lat, lon, correlation_map)
colorbar
title('NSHF and AMOC Change Correlation Map')

%%
[Lon, Lat] = meshgrid(lon, lat);

% corr> |0.6|
significant_correlation_indices = abs(correlation_map) >= 0.6;

[row_indices, col_indices] = find(significant_correlation_indices);

significant_lats = Lat(row_indices + (col_indices - 1) * size(Lat, 1));
significant_lons = Lon(row_indices + (col_indices - 1) * size(Lon, 1));

disp('Significant correlation locations (lat, lon):');
for k = 1:length(significant_lats)
    fprintf('Latitude: %f, Longitude: %f\n', significant_lats(k), significant_lons(k));
end

%%
significant_correlation_indices = abs(correlation_map) >= 0.6;

[row_indices, col_indices] = find(significant_correlation_indices);

significant_lats = Lat(row_indices + (col_indices - 1) * size(Lat, 1));
significant_lons = Lon(row_indices + (col_indices - 1) * size(Lon, 1));

disp('Significant correlation locations (lat, lon):');
for k = 1:length(significant_lats)
    fprintf('Latitude: %f, Longitude: %f\n', significant_lats(k), significant_lons(k));
end

worldmap('World')
pcolorm(lat, lon, correlation_map) % Plot the correlation map
hold on

geoshow(significant_lats, significant_lons, 'DisplayType', 'point', 'Marker', 'o', 'Color', 'r')

colorbar
title('NSHF and AMOC Change Correlation Map (Significant correlations > 0.6)')

hold off
