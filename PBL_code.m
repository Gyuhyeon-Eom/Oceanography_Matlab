%% 리스트함수를 통한 파일 불러오기
list = dir('C:\Users\turtl\iCloudDrive\학교\3학년\2학기\PBL\CTD_simple\');

load('variable_list.mat')

data_all = []; % 빈 행렬 생성

for i = 3:length(list)
    file_name = "C:\Users\turtl\iCloudDrive\학교\3학년\2학기\PBL\CTD_simple\"+list(i).name; % 파일 이름 생성
    
    data0 = readtable(file_name); % 해당 파일 불러오기
    data = table2array(data0); % table형식에서 배열형식으로 변경

    data_all = [data_all; data]; % 하나씩 불러와서 이어붙이기
end

data_1 = rmmissing(data_all);

yearColumn = 2;

data2022 = data_1(data_1(:,yearColumn) == 2022, :);

data2022(data2022 == -999) = NaN;

%% 365
month_data = data2022(:,3);
day_data = data2022(:,4);

days_in_month = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
month = [1 2 3 4 5 6 7 8 9 10 11 12];
days = zeros(length(month_data), 1);

for i = 1:length(month_data)
    month = month_data(i);
    day = day_data(i);
    days(i) = sum(days_in_month(1:month)) + day;
end

%% data_com
data_lat = data2022(:,5) ;
data_lon = data2022(:,6) ;
data_depth = data2022(:,7) ;
data_days = sortrows(days); 

data_com = [data_days, data_lat, data_lon, data_depth];

%% 2차원 lat,lon에 따른 depth
%{
figure;
scatter(data_lon, data_lat, 20, data_depth, 'filled');
colorbar();
xlabel('경도 (Longitude)');
ylabel('위도 (Latitude)');
title('위도와 경도에 따른 수심');
%}

%% Interpolation

lat = 50:0.5:80;
d_depth = depth(1:57);

F_data = zeros(length(lat),length(lon), length(d_depth), 1);
F_days = zeros(length(lat),length(lon), length(d_depth), 1);

for i = 1 : length(data_lat)
    for j = 1 : length(lat)
        [~, lat_index] = min((data_lat(i)-lat(j)).^2);
        F_data(j,:,:,:) = data_lat(lat_index);
        F_days(:,:,:,j) = data_days(i);
    end
end

for i = 1 : length(data_lon)
    for j = 1 : length(lon)
        [~, lon_index] = min((data_lon(i)-lon(j)).^2);
        F_data(:,j,:,:) = data_lon(lon_index);
    end
end

for i = 1 : length(data_depth)
    for j = 1 : length(d_depth)
        [~, depth_index] = min((data_depth(i)-d_depth(j)).^2);
        F_data(:,:,j,:) = data_depth(depth_index);
    end
end

F_data = cat(4, F_data, F_days);

     

























