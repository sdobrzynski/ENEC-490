%Lecture 7

coal_2012 = xlsread('coal860_data.xlsx',1);
coal_2015 = xlsread('coal860_data.xlsx',2);
retired = setdiff(coal_2012,coal_2015,'rows');
bins = zeros(91,1);

for i = 1:length(coal_2015)
    year = coal_2015(i,4)
    bins((year-1924),1) = bins((year-1924),1)+coal_2015(i,3)
end

