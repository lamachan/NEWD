clc;
clear;
close all;

file_path_RO = '../wiedzmy/csvki/WDB_RitualObject.csv';

opts = detectImportOptions(file_path_RO);

data_table_RO = readtable(file_path_RO, opts);
summary(data_table_RO);

file_path_MI = '../wiedzmy/csvki/WDB_MusicalInstrument.csv';

opts = detectImportOptions(file_path_MI);

data_table_MI = readtable(file_path_MI, opts);
summary(data_table_MI);

% -------------------------------------------------------------------------
% Top 20 najczęściej używanych przedmiotów w trakcie rytuałów

% Calculate the frequency of each unique value
[counts, categories] = groupcounts(data_table_RO.RitualObject_Type);

% Combine the counts and categories into a new table
countsTable = table(categories, counts, 'VariableNames', {'Category', 'Count'});

% Sort the table based on 'Count' in descending order to get the most common values on top
sortedCountsTable = sortrows(countsTable, 'Count', 'descend');

% Select the top 20 most common values
top20Counts = sortedCountsTable(1:20, :);
categoricalX = categorical(top20Counts.Category);
categoricalX = reordercats(categoricalX, top20Counts.Category);

figure;
bar(categoricalX, top20Counts.Count);
ylim([0, 1.1 * max(top20Counts.Count)])
xlabel('Rodzaj przedmiotu')
ylabel('Ilość rytuałów');
title('Top 20 najczęściej używanych przedmiotów w trakcie rytuałów', 'FontSize', 20);

% -------------------------------------------------------------------------
% Top 20 najczęściej używanych przedmiotów w trakcie rytuałów

% Calculate the frequency of each unique value
[counts, categories] = groupcounts(data_table_MI.MusicalInstrument_Type);

% Combine the counts and categories into a new table
countsTable = table(categories, counts, 'VariableNames', {'Category', 'Count'});

% Sort the table based on 'Count' in descending order to get the most common values on top
sortedCountsTable = sortrows(countsTable, 'Count', 'descend');
sortedCountsTable = sortedCountsTable(1:4, :);
categoricalX = categorical(sortedCountsTable.Category);
categoricalX = reordercats(categoricalX, sortedCountsTable.Category);

totalCounts = sum(sortedCountsTable.Count);
categoryPercentages = sortedCountsTable.Count / totalCounts * 100;

% Create the pie chart
figure;
pie(categoryPercentages);

% Add category labels as strings
legendLabels = cellstr(sortedCountsTable.Category);
legend(legendLabels, 'Location', 'best');

% Adjust the aspect ratio to make the pie circular
axis square;

title('Instrumenty muzyczne używane w trakcie rytuałów', 'FontSize', 20);