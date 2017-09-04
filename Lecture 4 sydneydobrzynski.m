%Statistics

%1
%Load data from Excel
[data, text, combined] = xlsread('monthly_demandNC.xlsx');

%2
%annual profile
d = annual_profile(data); 

%3
%year on year differences
[months,years] = size(d);
differences = zeros(months,years-1);

for i = 1:12
    for j = 1:years-1
        differences(i,j) = (d(i,j+1) - d(i,j))/d(i,j);
    end
end

%create new figure
figure; 
hold on;

%plot function within for loop
for i  = 1:12
    plot(differences(i,:)*100,'color',rand(1,3));
end

xlabel('Year','FontSize',14);
set(gca, 'XTickLabel',{'1998','2000','2002','2004','2006','2008','2010','2012','2014'});
set(gca,'XTick',1:2:18);
ylabel('Demand Growth (%)','FontSize',14);
legend('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

%4
%annual demand percentages
totals = sum(d);
monthly_fractions = zeros(months,years);
for i = 1:years
    monthly_fractions(:,i) = d(:,i)/totals(i);
end

%create new figure
figure; 
hold on;

%plot function within for loop
for i  = 1:12
    plot(monthly_fractions(i,:)*100,'color',rand(1,3));
end

xlabel('Year','FontSize',14);
set(gca, 'XTickLabel',{'1998','2000','2002','2004','2006','2008','2010','2012','2014'});
set(gca,'XTick',1:2:18);
ylabel('% of Total Annual Demand','FontSize',14);
legend('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec','Location','northwest');


%Simulation

%bootstrapping
num_years = 10;
bootstrap_sample = zeros(12*num_years,1);
for i = 1:num_years
    for j = 1:12
    s = ceil(years*rand(1));
    bootstrap_sample((i-1)*12+j) = d(j,s);
    end
end

figure;
%bootstrap sample
subplot(2,2,1);
plot(bootstrap_sample);
xlabel('Year','FontSize',14);
ylabel('BS Demand (MWh)','FontSize',14);

%autocorrelation
subplot(2,2,2);
autocorr(bootstrap_sample);
xlabel('Months','FontSize',14);
ylabel('BS Autocorrelation','FontSize',14);

%montecarlo
% find the mean and std. deviation of each calendar month over the 18 year period
s = monthly_stats(d); % what size is s? what information is in each column? 

%number of 'pretend' years you want to simulate
sim_years = 10;
% ouput
mc_sample = zeros(sim_years*12,1);

for i = 1:sim_years
    for j = 1:12
    
    %fill in the values of mc_sample one at a time
    mc_sample() = s() + s()*randn(1);
    
    end
end


subplot(2,2,3);
plot(mc_sample);
xlabel('Year','FontSize',14);
ylabel('MC Demand (MWh)','FontSize',14);

subplot(2,2,4);
autocorr(response);
xlabel('Months','FontSize',14);
ylabel('MC Autocorrelation','FontSize',14);
