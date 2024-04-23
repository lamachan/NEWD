clc;
clear;
close all;

% Step 1: Load the CSV file
data = readtable('csvki/WDB_Torture.csv');

% Step 2: Extract the relevant data
tortureTypes = data.Torturetype;

% Step 3: Count occurrences of each Torturetype and exclude empty entries
validEntries = ~strcmp(tortureTypes, ''); % Identify non-empty entries
tortureTypes = tortureTypes(validEntries); % Filter out empty entries
uniqueTypes = unique(tortureTypes);
counts = zeros(size(uniqueTypes));
for i = 1:length(uniqueTypes)
    counts(i) = sum(strcmp(tortureTypes, uniqueTypes{i}));
end

% Calculate percentages
percentages = counts / sum(counts);

% Sort by percentage
[percentages, idx] = sort(percentages, 'descend');
uniqueTypes = uniqueTypes(idx);
counts = counts(idx);

% Step 4: Plot the pie chart with default colors and percentages
figure;
hPie = pie(counts, uniqueTypes);
title('Distribution of Torture Types');
% Adding percentages to each slice
percentValues = 100*percentages;
percentValues = round(percentValues,2);
textObjs = findobj(hPie,'Type','text');
for i = 1:numel(percentValues)
    percentStr = sprintf('%s: %.2f%%', uniqueTypes{i}, percentValues(i));
    textObjs(i).String = percentStr;
end
