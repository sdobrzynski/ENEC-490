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
alpha = .25 + .5*rand(10000,1);
lowerbound = min(data)+ randn(10000,1)*.3;
upperbound = max(data)+ randn(10000,1)*.3;
dose = 1:1:120;
response = zeros(length(dose),1);
for a = 1:length(dose)
    response(a,1) = lowerbound+(upperbound-lowerbound)/(1+10.^(alpha-a));
end
subplot(2,2,3);plot(dose,response);
xlabel('Year','FontSize',14);
ylabel('MC Demand (MWh)','FontSize',14);

subplot(2,2,4);
autocorr(response);
xlabel('Months','FontSize',14);
ylabel('MC Autocorrelation','FontSize',14);
