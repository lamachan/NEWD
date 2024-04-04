% Step 1: Load the data from the CSV file
data = readtable('csvki/WDB_Ordeal.csv');

% Step 2: Extract the 'Ordealtype' column
ordealtype_column = data.Ordealtype;

% Step 3: Count the occurrences of each unique value
unique_ordealtype = unique(ordealtype_column);
counts = zeros(size(unique_ordealtype));
for i = 1:numel(unique_ordealtype)
    counts(i) = sum(strcmp(ordealtype_column, unique_ordealtype{i}));
end

% Step 4: Calculate percentages
total_count = sum(counts);
percentages = counts / total_count * 100;

% Step 5: Create a pie chart with percentages and legend
figure;
pie(percentages);
legend(unique_ordealtype, 'Location', 'bestoutside');
title('Distribution of Ordeal Types');
