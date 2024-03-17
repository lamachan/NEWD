clc;
clear;
close all;

file_path = 'penguins_lter.csv';

opts = detectImportOptions(file_path);

data_table = readtable(file_path, opts);
summary(data_table);

% change 'ClutchCompletion' to logical

% missing_counts = sum(ismissing(data_table));
% disp('Number of missing values in each column:');
% disp(missing_counts);

% do usunięcia:
%   studyName, Comments - nieużyteczne
%   Region, Stage - 1 wartość
columns_to_drop = {'studyName', 'Region', 'Stage', 'Comments'};
data_table = removevars(data_table, columns_to_drop);

% usunięcie brakujących wartości z ?

column_names = data_table.Properties.VariableNames;
disp('Column Names:');
disp(column_names);
