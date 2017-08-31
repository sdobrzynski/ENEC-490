function [ s ] = monthly_stats( data )
d = annual_profile(data)
s = zeros(12,2);
s(:,1) = mean(d,2);
s(:,2) = std(d,0,2);
end
