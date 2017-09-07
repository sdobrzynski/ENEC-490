%Lecture 5

%Read 2015 electricity demand data
data = csvread('hourly-day-ahead-bid-data-2015.csv',5,1);
vector = mat2vec(data);

%Read 2014 electricity demand data
bizarre_data = csvread('bizarre_data.csv')

%Pre-process Data
processed_data = pre_processor(bizarre_data);

candidates = find(processed_data > 130000);
index = candidates(find(candidates>7000))
day = floor(index/24);
hour = index - day*24;
answer = [day hour]

%histogram
figure;
histogram(processed_data,100); 
xlabel('Demand (MWh)','FontSize', 14)
ylabel('Frequency','FontSize', 14)
title('Pre-processed 2014 Data', 'FontSize',14)

%qqplot
figure; 
qqplot(processed_data); 
xlabel('Theoretical Normal Quantiles','FontSize',14)
ylabel('Empirical Data Normal Quantiles','FontSize',14)
title('QQ Plot of Pre-Processed Demand Data','FontSize',14)

%log transformation
transformed_data = log(processed_data); 

%histogram
figure; 
histogram(transformed_data,100); 
xlabel('log-Demand (MWh)','FontSize', 14)
ylabel('Frequency','FontSize', 14)
title('Log-Transformed 2014 Data', 'FontSize',14)


%qqplot
figure;
qqplot(transformed_data);
xlabel('Theoretical Normal Quantiles','FontSize',14)
ylabel('Empirical Data Normal Quantiles','FontSize',14)
title('QQ Plot of Log-Transformed Demand Data','FontSize',14)

%mean
mu = mean(transformed_data); 
dev = std(transformed_data); 

%number of standard deviations weird point is away from mean
number_stds = (transformed_data(index) - mu)/dev;

%moving window assessment
num_hours = length(transformed_data);
window = 500;

%ouput
outliers = zeros(num_hours,1);

% for i = 251 to i = 8510
for i = window/2 + 1:num_hours-window/2
    
    % calculate the mean for every point in transformed data from (i-250)
    % to (i + 250) (a 501 point window)
    window_mean = mean(transformed_data(i-250:i+250));
    
    % calculate the std. deviation for every point in transformed data from
    % (i-250) to (i + 250) (a 501 point window)
    window_std = std(transformed_data(i-250:i+250));
    
    % test whether points 251:8510 in transformed data are outliers
    if transformed_data(i) >= window_mean + 3*window_std | transformed_data(i) <= window_mean - 3*window_std
        outliers(i) = 1;
    else
        outliers(i) = 0;
    end
    
end

find(outliers>0)

%data mining
M = zeros(365,24);
for i = 1:365
    for j = 1:24
        M(i,j)=(transformed_data(24*(i-1)+j));
    end
end
peakdata = max(M,[],2);
tempdata = csvread('tempdata.csv');
scatter(tempdata(:,2),peakdata);
