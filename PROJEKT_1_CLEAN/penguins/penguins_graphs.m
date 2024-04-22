% NEWD - Wizualizacja danych 2024Z
% Projekt 1 - Matlab
% Zespół:
    % Alicja Oczkowska
    % Szymon Posiadała
    % Weronika Zbierowska
clc;
clear;
close all;

file_path = 'penguins_lter.csv';

opts = detectImportOptions(file_path);

data_table = readtable(file_path, opts);
summary(data_table);

missing_counts = sum(ismissing(data_table));
disp('Number of missing values in each column:');
disp(missing_counts);

% do usunięcia:
%   studyName, Comments - nieużyteczne
%   Region, Stage - 1 wartość
columns_to_drop = {'studyName', 'Region', 'Stage', 'Comments'};
data_table = removevars(data_table, columns_to_drop);

column_names = data_table.Properties.VariableNames;
disp('Column Names:');
disp(column_names);

% -------------------------------------------------------------------------
% WYKRESY
% -------------------------------------------------------------------------
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
% -------------------------------------------------------------------------
% wykres punktowy zależności długości dzioba od długości płetwy wg gatunku
figure;
hold on;
for i = 1:numel(unique_species)
    species_indices = strcmp(species, unique_species{i});
    scatter(data_table.FlipperLength_mm_(species_indices), data_table.CulmenLength_mm_(species_indices), 50, colors(i, :), 'filled');
end
hold off;

xlim([0 max(data_table.FlipperLength_mm_)+10]);
ylim([0 max(data_table.CulmenLength_mm_)+10]);
xlabel('Długość płetwy (mm)');
ylabel('Długość dzioba (mm)');
legend(unique_species, 'Location', 'best');
title('Zależność długości dzioba od długości płetwy wg gatunku', 'FontSize', 20);
grid on;
% -------------------------------------------------------------------------
% wykres punktowy zależności masy ciała od długości płetwy wg gatunku
figure;
hold on;
for i = 1:numel(unique_species)
    species_indices = strcmp(species, unique_species{i});
    scatter(data_table.FlipperLength_mm_(species_indices), data_table.BodyMass_g_(species_indices), 50, colors(i, :), 'filled');
end
hold off;

xlim([0 max(data_table.FlipperLength_mm_)+10]);
ylim([0 max(data_table.BodyMass_g_)+100]);
xlabel('Długość płetwy (mm)');
ylabel('Masa ciała (g)');
legend(unique_species, 'Location', 'best');
title('Zależność masy ciała od długości płetwy wg gatunku', 'FontSize', 20);
grid on;
% -------------------------------------------------------------------------
% wykres punktowy zależności masy ciała od długości dzioba wg gatunku
figure;
hold on;
for i = 1:numel(unique_species)
    species_indices = strcmp(species, unique_species{i});
    scatter(data_table.CulmenLength_mm_(species_indices), data_table.BodyMass_g_(species_indices), 50, colors(i, :), 'filled');
end
hold off;

xlim([0 max(data_table.CulmenLength_mm_)+10]);
ylim([0 max(data_table.BodyMass_g_)+100]);
xlabel('Długość dzioba (mm)');
ylabel('Masa ciała (g)');
legend(unique_species, 'Location', 'best');
title('Zależność masy ciała od długości dzioba wg gatunku', 'FontSize', 20);
grid on;
% -------------------------------------------------------------------------
% wykres punktowy zależności grubości dzioba od długości dzioba wg gatunku
figure;
hold on;
for i = 1:numel(unique_species)
    species_indices = strcmp(species, unique_species{i});
    scatter(data_table.CulmenLength_mm_(species_indices), data_table.CulmenDepth_mm_(species_indices), 50, colors(i, :), 'filled');
end
hold off;

xlim([0 max(data_table.CulmenLength_mm_)+10]);
ylim([0 max(data_table.CulmenDepth_mm_)+10]);
xlabel('Długość dzioba (mm)');
ylabel('Grubość dzioba (mm)');
legend(unique_species, 'Location', 'best');
title('Zależność grubości dzioba od długości dzioba wg gatunku', 'FontSize', 20);
grid on;
% -------------------------------------------------------------------------
% wykres kołowy płci pingwinów
sex_counts = countcats(categorical(data_table.Sex));

figure;
pie(sex_counts);
title('Proporcje płci wszystkich pingwinów', 'FontSize', 20);
legend({'brak informacji', 'female', 'male'}, 'Location', 'eastoutside');
% -------------------------------------------------------------------------
% wykres kołowy gatunków pingwinów
species_counts = countcats(categorical(data_table.Species));

figure;
pie(species_counts);
title('Proporcje gatunków wszystkich pingwinów', 'FontSize', 20);
legend(unique(data_table.Species), 'Location', 'eastoutside');
% -------------------------------------------------------------------------
% wykres słupkowy liczby pingwinów z wylągiem 2 jaj wg gatunku
species = data_table.Species;
clutch = data_table.ClutchCompletion;

unique_species = unique(species);
unique_clutch = unique(clutch);

counts = zeros(numel(unique_species), numel(unique_clutch));

for i = 1:numel(unique_species)
    for j = 1:numel(unique_clutch)
        counts(i, j) = sum(strcmp(species, unique_species{i}) & strcmp(clutch, unique_clutch{j}));
    end
end

disp(counts);

colors = [0.8500 0.3250 0.0980;  % czerwony - Adelie
          0.9290 0.6940 0.1250;  % żółty - Chinstrap
          0 0.4470 0.7410];      % niebieski - Gentoo
figure;
bar(counts, 'stacked');

for i = 1:numel(unique_species)
    set(gca, 'ColorOrderIndex', i);
    colormap(colors);
end

xticks(1:numel(unique_species));
xticklabels(unique_species);
xlabel('Gatunek');
ylabel('Liczba pingwinów');
legend(unique_clutch, 'Location', 'eastoutside', 'Orientation', 'vertical');
title('Liczba pingwinów a wyląg 2 jaj wg gatunku', 'FontSize', 20);
xtickangle(45);
grid on;
% -------------------------------------------------------------------------
% wykresy pudełkowe długości dzioba, grubości dzioba, długości płetw i masy ciała
data = data_table(strcmp(data_table.Sex, 'MALE') | strcmp(data_table.Sex, 'FEMALE'), :);

features = {'CulmenLength_mm_', 'CulmenDepth_mm_', 'FlipperLength_mm_', 'BodyMass_g_'};
feature_names = {'długość dzioba [mm]', 'grubość dzioba [mm]', 'długość płetw [mm]', 'masa ciała [g]'};

feature_values = cell(length(features), 1);
species_names = cell(length(features), 1);

for i = 1:length(features)
    feature_values{i} = data.(features{i});
    
    species_names{i} = strcat(data.Species, "-", data.Sex);
end

for i = 1:length(features)
    figure;
    boxplot(feature_values{i}, species_names{i});
    ylabel(feature_names{i});
    title('Wykres pudełkowy dla cechy ', feature_names{i}, 'FontSize', 20);
    xtickangle(45);
end