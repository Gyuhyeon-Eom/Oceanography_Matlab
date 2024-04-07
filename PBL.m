clc;
close all;
clear all;

%%
%folderPath = 'C:\Users\USER\iCloudDrive\학교\4학년\1학기\PBL\ssp126'; 
folderPath = 'C:\Users\turtl\iCloudDrive\학교\4학년\1학기\PBL\ssp126';
year = 1850 : 2100 ; 

amocFiles = dir(fullfile(folderPath, 'AMOC*.txt'));

nshfFiles = dir(fullfile(folderPath, 'nshf*'));

amoc_mean = zeros(251, length(amocFiles));

legendNames = {};

for i = 1:length(amocFiles)

    currentFile = amocFiles(i).name;
    amoc_data = load(fullfile(folderPath, currentFile));
    amoc_mean(:,i) = mean(amoc_data, 2); 
    legend_labels_amoc{i} = strrep(strrep(currentFile, 'AMOC_CMIP6_', ''), '_ssp245_1850-2100_J_D_MYM.txt', '');

end

nshf_mean = zeros(251, length(nshfFiles));


for i = 1:length(nshfFiles)

    currentFile = nshfFiles(i).name;
    nsfh_data = load(fullfile(folderPath, currentFile));
    nshf_mean(:,i) = mean(nsfh_data, 2); 

end

amoc_ensemble_mean = zeros();
nshf_ensemble_mean = zeros();

for i = 1 : 251
    amoc_ensemble_mean(i) = mean(amoc_mean(i,:));
    nshf_ensemble_mean(i) = mean(nshf_mean(i,:));
end
figure;
plot(year,amoc_ensemble_mean)

subplot(2,1,1);
hold on;
grid on;
plot(year,amoc_mean);
plot(year, amoc_ensemble_mean, 'k-', 'LineWidth', 2);
title('AMOC Index(Annual mean)')
xlabel('Year')
ylabel('AMOC Index[Sv]')
hold on;
grid on;

subplot(2,1,2)
hold on;
grid on;
plot(year,nshf_mean);
plot(year, nshf_ensemble_mean, 'k-', 'LineWidth', 2);
title('nshf (Annual mean)')
xlabel('Year')
ylabel('nshf')
    
legend(legend_labels_amoc, 'FontSize', 6, 'Location', 'east');

%%
start_year = input('start_year: ');
end_year = input('end_year: ');
years_of_interest = start_year:end_year;

amoc_slope = zeros(length(amocFiles), 1);
nshf_slope = zeros(length(nshfFiles), 1);

for i = 1:length(amocFiles)
    currentFile = amocFiles(i).name;
    amoc_data = load(fullfile(folderPath, currentFile));
    amoc_mean_yearly = mean(amoc_data, 2);
    selected_years_idx = ismember(year, years_of_interest);
    selected_years_data = amoc_mean_yearly(selected_years_idx);
    p = polyfit(years_of_interest', selected_years_data, 1);
    amoc_slope(i) = p(1);
end

for i = 1:length(nshfFiles)
    currentFile = nshfFiles(i).name;
    nshf_data = load(fullfile(folderPath, currentFile));
    nshf_mean_yearly = mean(nshf_data, 2);
    selected_years_idx = ismember(year, years_of_interest);
    selected_years_data = nshf_mean_yearly(selected_years_idx);
    p = polyfit(years_of_interest', selected_years_data, 1);
    nshf_slope(i) = p(1);
end

dt = start_year-end_year;

amoc_change_rate = amoc_slope * dt;
nshf_change_rate = nshf_slope * dt;

figure;
scatter(nshf_change_rate, amoc_change_rate);
xlabel('nshf의 변화율');
ylabel('AMOC의 변화율');
title('AMOC와 nshf의 변화율 간의 상관관계');

figure;
scatter(nshf_change_rate, amoc_change_rate);
xlabel('nshf의 변화율');
ylabel('AMOC의 변화율');
title('AMOC와 nshf의 변화율 간의 상관관계');

hold on;
grid on;

coefficients = polyfit(nshf_change_rate, amoc_change_rate, 1);
x_values = min(nshf_change_rate):0.01:max(nshf_change_rate);
y_values = polyval(coefficients, x_values);


plot(x_values, y_values, 'r', 'LineWidth', 2);

correlation_coefficient = corr(nshf_change_rate, amoc_change_rate)

text(0.8 * max(nshf_change_rate), 0.8 * max(amoc_change_rate), ...
    ['상관계수: ', num2str(correlation_coefficient)], 'FontSize', 9);

legend('Data', 'Linear Regression', 'Location', 'best');
hold off;

%%
lag = 10 ;

minLength = min(length(amoc_ensemble_mean), length(nshf_ensemble_mean)) - lag;
amoc_lagged = amoc_ensemble_mean(1:minLength);
nshf_lagged = nshf_ensemble_mean(lag+1:minLength+lag);

lagged_correlation = corr(amoc_lagged', nshf_lagged');

figure;
scatter(nshf_lagged, amoc_lagged);
xlabel('nshf의 변화율 (지연 10년)');
ylabel('AMOC의 변화율');
title('AMOC와 nshf의 변화율 간의 상관관계 (지연 10년)');
hold on;
grid on;

coefficients_lagged = polyfit(nshf_lagged, amoc_lagged, 1)
x_values_lagged = min(nshf_lagged):0.01:max(nshf_lagged);
y_values_lagged = polyval(coefficients_lagged, x_values_lagged);
plot(x_values_lagged, y_values_lagged, 'r', 'LineWidth', 2);

text(0.8 * max(nshf_lagged), 0.8 * max(amoc_lagged), ...
    ['상관계수: ', num2str(lagged_correlation)], 'FontSize', 9);

legend('Data (Lagged)', 'Linear Regression', 'Location', 'best');
hold off;


%%

nshf_interval = 10; 
n_years = length(years_of_interest);
n_intervals = n_years - nshf_interval + 1;

amoc_change_rate_interval = zeros(length(amocFiles), n_intervals);
nshf_change_rate_interval = zeros(length(nshfFiles), n_intervals);

for i = 1:length(amocFiles)
    currentFile = amocFiles(i).name;
    amoc_data = load(fullfile(folderPath, currentFile));
    amoc_mean_yearly = mean(amoc_data, 2);
    for j = 1:n_intervals
        selected_years_idx = find(year >= years_of_interest(j) & year <= (years_of_interest(j) + nshf_interval - 1));
        selected_years_data = amoc_mean_yearly(selected_years_idx);
        p = polyfit(year(selected_years_idx)', selected_years_data, 1);
        amoc_change_rate_interval(i, j) = p(1);
    end
end

for i = 1:length(nshfFiles)
    currentFile = nshfFiles(i).name;
    nshf_data = load(fullfile(folderPath, currentFile));
    nshf_mean_yearly = mean(nshf_data, 2);
    for j = 1:n_intervals
        selected_years_idx = find(year >= years_of_interest(j) & year <= (years_of_interest(j) + nshf_interval - 1));
        selected_years_data = nshf_mean_yearly(selected_years_idx);
        p = polyfit(year(selected_years_idx)', selected_years_data, 1);
        nshf_change_rate_interval(i, j) = p(1);
    end
end

correlation_coefficients = zeros(n_intervals, 1);
for i = 1:n_intervals
    correlation_coefficients(i) = corr(nshf_change_rate_interval(:,i), amoc_change_rate_interval(:,i));
end

figure;
plot(years_of_interest(1:end-nshf_interval+1), correlation_coefficients, 'LineWidth', 2);
xlabel('Year');
ylabel('Correlation Coefficient');
title('10-Year Interval Correlation between AMOC and nshf');
grid on;

for i = 1:n_intervals
    correlation_coefficients(i) = corr(nshf_change_rate_interval(:,i), amoc_change_rate_interval(:,i));
end

figure;
plot(years_of_interest(1:end-nshf_interval+1), correlation_coefficients, 'o-', 'LineWidth', 2); % 'o-'를 추가하여 동그라미 표시
xlabel('Year');
ylabel('Correlation Coefficient');
title('10-Year Interval Correlation between AMOC and nshf');
grid on;


%{
심층수 형성 지역의 nshf만 뽑아서 분석해보는게 좋다.
관측데이터를 공간으로 펼쳐서 nshf의 측정을 확인해보고 이를 이용해서 분석
AMOC의 관측자료가 04년부터 시작되어서 자료가 짧다.
연간 자료로 만족 해야한다. 관측자료가 2004년에서 2021년까지 밖에 없어서
연간 변동성으로 분석을 해보자.
관측에서 amoc의 연변동성이 주는 NSHF의 지역별 영향을 보려면 어떤 분석을 해야할까?
관측데이터는 월단위 -> 자유도가 늘어나긴 하는데 연단위로 (별 의미 없음)
자료는 연평균으로 제공 받을 것
->연평균을 해야 바람에 의한 노이즈가 없다.
모든 grid와 상관관계를 해서 corr map을 그려볼수도있다.
모든 grid의 nshf와 amoc을 직접적으로 corr할 건가? 다른 방법이 있을까?
-> 변화량 끼리 corr하는 것이 더 확실하다. 
nshf가 10년정도 amoc에 영향을 줘야 어느정도 영향이 있기 때문에 lag를 
10으로 설정해둔 것이다.
모형같은 경우에는 모형마다 하나씩 VIRUS가 있어서 어떤건 잘맞고 어떤건 안맞는
경우가 있어서,( 주제에 따라서도 다 다르다 ) 따라서 모형끼리 평균을 한것
-> 때문에 인과관계를 확실히 하기 힘들다.

%}