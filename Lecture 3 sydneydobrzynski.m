%Lecture 3

[data text combined] = xlsread('RNGWHHDm.xls','Data 1');

%call annual profile function
d = annual_profile(data); 
[months,years] = size(d);

%create new figure
figure; 
hold on;

%plot function within for loop
for i  = 1:years
    plot(d(:,i),'color',rand(1,3));
end

xlabel('Month','FontSize',14);
set(gca, 'XTickLabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'});
set(gca,'XTick',1:1:12);
ylabel('Natural Gas Price ($/MMBtu)','FontSize',14);
legend('2008','2009','2010','2011','2012','2013','2014','2015','2016');


%call monthly stats function
s = monthly_stats(data);

% april
april = s(4,1) + s(4,2)*randn(1000,1);

% january
january = s(1,1) + s(1,2)*randn(1000,1);

%histograms
figure;
edges = -5:0.5:15;
histogram(april,edges);
hold on;
histogram(january,edges);
xlabel('Natural Gas Price ($/MMBtu)','FontSize',14);
ylabel('Frequency','FontSize',14);
legend('April','January');
