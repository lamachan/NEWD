clc;
clear;
close all;

file_path = 'penguins_lter.csv';

opts = detectImportOptions(file_path);

data_table = readtable(file_path, opts);
% summary(data_table);

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
% disp('Column Names:');
% disp(column_names);



% wykres słupkowy liczby pingwinów na danej wyspie z podziałem na gatunki
species = data_table.Species;
islands = data_table.Island;

unique_species = unique(species);
unique_islands = unique(islands);

counts = zeros(numel(unique_species), numel(unique_islands));

for i = 1:numel(unique_species)
    for j = 1:numel(unique_islands)
        counts(i, j) = sum(strcmp(species, unique_species{i}) & strcmp(islands, unique_islands{j}));
    end
end

disp(counts);

colors = [0.8500 0.3250 0.0980;  % czerwony - Adelie
          0.9290 0.6940 0.1250;  % żółty - Chinstrap
          0 0.4470 0.7410];      % niebieski - Gentoo
figure;

bar(counts', 'stacked');

for i = 1:numel(unique_species)
    set(gca, 'ColorOrderIndex', i);
    colormap(colors);
end

xticks(1:numel(unique_islands));
xticklabels(unique_islands);
xlabel('Wyspy');
ylabel('Liczba pingwinów');
legend(unique_species, 'Location', 'eastoutside', 'Orientation', 'vertical');
title('Liczba pingwinów na każdej wyspie wg gatunku', 'FontSize', 20);
xtickangle(45);
grid on;

% wykres punktowy zależności długości dzioba od długości płetwy wg gatunku
figure;
hold on;
for i = 1:numel(unique_species)
    species_indices = strcmp(species, unique_species{i});
    scatter(data_table.FlipperLength_mm_(species_indices), data_table.CulmenLength_mm_(species_indices), 50, colors(i, :), 'filled');
end
hold off;

xlabel('Długość płetwy (mm)');
ylabel('Długość dzioba (mm)');
legend(unique_species, 'Location', 'best');
title('Zależność długości dzioba od długości płetwy wg gatunku', 'FontSize', 20);
grid on;

% wykres punktowy zależności masy ciała od długości płetwy wg gatunku
figure;
hold on;
for i = 1:numel(unique_species)
    species_indices = strcmp(species, unique_species{i});
    scatter(data_table.FlipperLength_mm_(species_indices), data_table.BodyMass_g_(species_indices), 50, colors(i, :), 'filled');
end
hold off;

xlabel('Długość płetwy (mm)');
ylabel('Masa ciała (g)');
legend(unique_species, 'Location', 'best');
title('Zależność masy ciała od długości płetwy wg gatunku', 'FontSize', 20);
grid on;

% wykres punktowy zależności masy ciała od długości dzioba wg gatunku
figure;
hold on;
for i = 1:numel(unique_species)
    species_indices = strcmp(species, unique_species{i});
    scatter(data_table.CulmenLength_mm_(species_indices), data_table.BodyMass_g_(species_indices), 50, colors(i, :), 'filled');
end
hold off;

xlabel('Długość dzioba (mm)');
ylabel('Masa ciała (g)');
legend(unique_species, 'Location', 'best');
title('Zależność masy ciała od długości dzioba wg gatunku', 'FontSize', 20);
grid on;

% wykres punktowy zależności grubości dzioba od długości dzioba wg gatunku
figure;
hold on;
for i = 1:numel(unique_species)
    species_indices = strcmp(species, unique_species{i});
    scatter(data_table.CulmenLength_mm_(species_indices), data_table.CulmenDepth_mm_(species_indices), 50, colors(i, :), 'filled');
end
hold off;

xlabel('Długość dzioba (mm)');
ylabel('Grubość dzioba (mm)');
legend(unique_species, 'Location', 'best');
title('Zależność grubości dzioba od długości dzioba wg gatunku', 'FontSize', 20);
grid on;