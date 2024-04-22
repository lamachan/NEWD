% NEWD - Wizualizacja danych 2024Z
% Projekt 1 - Matlab
% Zespół:
    % Alicja Oczkowska
    % Szymon Posiadała
    % Weronika Zbierowska
clc;
clear;
close all;

file_path = 'ports.csv';

opts = detectImportOptions(file_path);
opts.VariableTypes{1} = 'char';

data_table = readtable(file_path, opts);
summary(data_table);

% do usunięcia:
%   NAME, NAME_MOD - nieużyteczne
columns_to_drop = {'NAME', 'NAME_MOD'};
data_table = removevars(data_table, columns_to_drop);

% usunięcie brakujących wartości z 'COUNTRY' i 'AM'
data_table = data_table(~ismissing(data_table.COUNTRY), :);
data_table = data_table(~ismissing(data_table.AM), :);

column_names = data_table.Properties.VariableNames;
disp('Column Names:');
disp(column_names);

% zmiana formatu współrzędnych geograficznych
data_table.LATITUDE = str2double(strrep(data_table.LATITUDE, ',', '.'));
data_table.LONGITUDE = str2double(strrep(data_table.LONGITUDE, ',', '.'));

% porty o których stanie mamy informacje
no_missing_re = data_table(~ismissing(data_table.RE), :);

% -------------------------------------------------------------------------
% WYKRESY
% -------------------------------------------------------------------------
% wizualizacja położenia portów na mapie
figure;
geoscatter(data_table.LATITUDE, data_table.LONGITUDE, 5, 'r', 'filled');
geobasemap('landcover');
title('Położenie portów', 'FontSize', 20);
% -------------------------------------------------------------------------
% wykres kołowy - rodzaje autorów
figure;
counts = countcats(categorical(data_table.AM));
pie(counts)
colors = [1 0 0; 0 0 1];
colormap(colors);
legend({'starożytni', 'współcześni'}, 'Location', 'northwest');
title('Autorzy', 'FontSize', 20);
% -------------------------------------------------------------------------
% wizualizacja położenia portów z rozbiciem na rodzaj autora
for am = unique(data_table.AM)'
    indices = strcmp(data_table.AM, am);
    if strcmp(am, 'm')
        figure;
        geoscatter(data_table.LATITUDE(indices), data_table.LONGITUDE(indices), 5, 'b', 'filled');
        geobasemap('landcover');
        title('Położenie portów - autor współczesny', 'FontSize', 20);
    else
        figure;
        geoscatter(data_table.LATITUDE(indices), data_table.LONGITUDE(indices), 5, 'r', 'filled');
        geobasemap('landcover');
        title('Położenie portów - autor starożytny', 'FontSize', 20);

    end
end
% -------------------------------------------------------------------------
% wizualizacja położenia portów z podziałem na stan portu
figure;
legend_labels = {};
for re = unique(no_missing_re.RE)'
    indices = strcmp(no_missing_re.RE, re);
    if strcmp(re, 'r')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'b', 'filled');
        legend_labels{end+1} = 'widoczny';
    elseif strcmp(re, 'rs')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'r', 'filled');
        legend_labels{end+1} = 'zatopiony lub zamulony';
    end
    hold on;
end
geobasemap('landcover');
title('Położenie portów - stan portu', 'FontSize', 20);
legend(legend_labels, 'Location', 'northwest');
% -------------------------------------------------------------------------
% wizualizacje położenia portów, o których stanie mamy informacje i
% zawierają struktury:
% -------------------------------------------------------------------------
% BW - widoczny falochron
figure;
legend_labels = {};
for bw = unique(no_missing_re.BW)'
    indices = strcmp(no_missing_re.BW, bw);
    if strcmp(bw, 'X')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'b', 'filled');
        legend_labels{end+1} = 'widoczny';
    elseif strcmp(bw, 'X?')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'g', 'filled');
        legend_labels{end+1} = 'może widoczny';
    else
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'r', 'filled');
        legend_labels{end+1} = 'niewidoczny';
    end
    hold on;
end
geobasemap('landcover');
title('Położenie portów - falochron', 'FontSize', 20);
legend(legend_labels, 'Location', 'northwest');
% -------------------------------------------------------------------------
% QU - widoczne nabrzeże, molo lub pomost
figure;
legend_labels = {};
for qu = unique(no_missing_re.QU)'
    indices = strcmp(no_missing_re.QU, qu);
    if strcmp(qu, 'X')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'b', 'filled');
        legend_labels{end+1} = 'widoczny';
    elseif strcmp(qu, 'X?')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'g', 'filled');
        legend_labels{end+1} = 'może widoczny';
    else
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'r', 'filled');
        legend_labels{end+1} = 'niewidoczny';
    end
    hold on;
end
geobasemap('landcover');
title('Położenie portów - nabrzeże, molo lub pomost', 'FontSize', 20);
legend(legend_labels, 'Location', 'northwest');
% -------------------------------------------------------------------------
% MO - widoczne miejsce do cumowania (np. pachołek)
figure;
legend_labels = {};
for mo = unique(no_missing_re.MO)'
    indices = strcmp(no_missing_re.MO, mo);
    if strcmp(mo, 'X')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'b', 'filled');
        legend_labels{end+1} = 'widoczny';
    elseif strcmp(mo, 'X?')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'g', 'filled');
        legend_labels{end+1} = 'może widoczny';
    else
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'r', 'filled');
        legend_labels{end+1} = 'niewidoczny';
    end
    hold on;
end
geobasemap('landcover');
title('Położenie portów - miejsce do cumowania', 'FontSize', 20);
legend(legend_labels, 'Location', 'northwest');
% -------------------------------------------------------------------------
% CN - widoczny kanał (do żeglugi, płukania basenu lub odmulania)
figure;
legend_labels = {};
for cn = unique(no_missing_re.CN)'
    indices = strcmp(no_missing_re.CN, cn);
    if strcmp(cn, 'X')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'b', 'filled');
        legend_labels{end+1} = 'widoczny';
    elseif strcmp(cn, 'X?')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'g', 'filled');
        legend_labels{end+1} = 'może widoczny';
    else
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'r', 'filled');
        legend_labels{end+1} = 'niewidoczny';
    end
    hold on;
end
geobasemap('landcover');
title('Położenie portów - kanał (do żeglugi, płukania basenu lub odmulania)', 'FontSize', 20);
legend(legend_labels, 'Location', 'northwest');
% -------------------------------------------------------------------------
% SL - widoczna pochylnia
figure;
legend_labels = {};
for sl = unique(no_missing_re.SL)'
    indices = strcmp(no_missing_re.SL, sl);
    if strcmp(sl, 'X')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'b', 'filled');
        legend_labels{end+1} = 'widoczny';
    elseif strcmp(sl, 'X?')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'g', 'filled');
        legend_labels{end+1} = 'może widoczny';
    else
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'r', 'filled');
        legend_labels{end+1} = 'niewidoczny';
    end
    hold on;
end
geobasemap('landcover');
title('Położenie portów - pochylnia', 'FontSize', 20);
legend(legend_labels, 'Location', 'northwest');
% -------------------------------------------------------------------------
% SH - widoczna stocznia
figure;
legend_labels = {};
for sh = unique(no_missing_re.SH)'
    indices = strcmp(no_missing_re.SH, sh);
    if strcmp(sh, 'X')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'b', 'filled');
        legend_labels{end+1} = 'widoczny';
    elseif strcmp(sh, 'X?')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'g', 'filled');
        legend_labels{end+1} = 'może widoczny';
    else
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'r', 'filled');
        legend_labels{end+1} = 'niewidoczny';
    end
    hold on;
end
geobasemap('landcover');
title('Położenie portów - stocznia', 'FontSize', 20);
legend(legend_labels, 'Location', 'northwest');
% -------------------------------------------------------------------------
% PH - widoczna latarnia morska
figure;
legend_labels = {};
for ph = unique(no_missing_re.PH)'
    indices = strcmp(no_missing_re.PH, ph);
    if strcmp(ph, 'X')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'b', 'filled');
        legend_labels{end+1} = 'widoczny';
    elseif strcmp(ph, 'X?')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'g', 'filled');
        legend_labels{end+1} = 'może widoczny';
    else
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'r', 'filled');
        legend_labels{end+1} = 'niewidoczny';
    end
    hold on;
end
geobasemap('landcover');
title('Położenie portów - latarnie morskie', 'FontSize', 20);
legend(legend_labels, 'Location', 'northwest');
% -------------------------------------------------------------------------
% CO - widoczny "cothon", czyli kolisty basen wydrążony przez człowieka
figure;
legend_labels = {};
for co = unique(no_missing_re.CO)'
    indices = strcmp(no_missing_re.CO, co);
    if strcmp(co, 'X')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'b', 'filled');
        legend_labels{end+1} = 'widoczny';
    elseif strcmp(co, 'X?')
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'g', 'filled');
        legend_labels{end+1} = 'może widoczny';
    else
        geoscatter(no_missing_re.LATITUDE(indices), no_missing_re.LONGITUDE(indices), 10, 'r', 'filled');
        legend_labels{end+1} = 'niewidoczny';
    end
    hold on;
end
geobasemap('landcover');
title('Położenie portów - "cothon", czyli kolisty basen wydrążony przez człowieka', 'FontSize', 20);
legend(legend_labels, 'Location', 'northwest');
% -------------------------------------------------------------------------
% histogram liczby struktur w portach widocznych
empty_cells = cellfun(@isempty, no_missing_re{:, 10:17});
structure_counts = sum(~empty_cells, 2);

figure;
histogram(structure_counts);
xlabel('liczba struktur');
ylabel('częstość');
title('Histogram liczby struktur w portach widocznych', 'FontSize', 20);
grid on;
% -------------------------------------------------------------------------
% mapa liczby struktur w portach widocznych
figure;
A = 20;
C = structure_counts;
geoscatter(no_missing_re.LATITUDE, no_missing_re.LONGITUDE, A, C,'filled');
geobasemap('landcover');
colormap(flipud(hot(7)));
cbh = colorbar;
cbh.Ruler.Exponent = 0;
title('Liczba struktur w portach widocznych', 'FontSize', 20);
% -------------------------------------------------------------------------
% wykres słupkowy liczby portów z widoczną daną strukturą
counts = sum(strcmp(no_missing_re{:, 10:17}, 'X'));
[~, most_common_index] = max(counts);

figure;
bar(counts);
xlabel('Struktura');
ylabel('Liczba portów');
title('Liczba portów z widoczną daną strukturą', 'FontSize', 20);
xticks(1:length(counts));
xticklabels({'falochron', 'nabrzeże/molo', 'miejsce do cumowania', 'kanał', 'pochylnia', 'stocznia', 'latarnia morska', 'cothon'});
grid on;
hold on;
bar(most_common_index, counts(most_common_index), 'r');
legend('widoczna', 'najczęściej widoczna');
% -------------------------------------------------------------------------
% wykres kołowy - stan portów
figure;
state_array = categorical(data_table.RE);
len = length(state_array);
counts = countcats(state_array);
counts(3) = len - sum(counts);
pie(counts)
colors = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250];
colormap(colors);
legend({'na powierzchni', 'pod wodą', 'brak'}, 'Location', 'northwest');
title('Pozostałości po portach', 'FontSize', 20);
% -------------------------------------------------------------------------
% wykres słupkowy - liczba portów według państwa
figure;
regions = categorical(data_table.COUNTRY);
for i = 1:length(regions)
    seperated_name = allwords(char(regions(i)));
    if strcmp(seperated_name{1}, 'Egypt:')
        seperated_name{1} = 'Egypt';
    end
    if strcmp(seperated_name{1}, 'GR:') || strcmp(seperated_name{1}, 'GR')
        seperated_name{1} = 'Greece';
    end
    if strcmp(seperated_name{1}, 'Malta:')
        seperated_name{1} = 'Malta';
    end
    if strcmp(seperated_name{1}, 'TR:') || strcmp(seperated_name{1}, 'TR')
        seperated_name{1} = 'Turkey';
    end
    if strcmp(seperated_name{1}, 'UK')
        seperated_name{1} = 'United Kingdom';
    end
    regions(i) = seperated_name{1};
end

regions = removecats(regions);
histogram(regions)
h = histogram(regions);
h.DisplayOrder = 'descend';
ylabel('Liczba portów');
title('Liczba portów w zależności od państwa', 'FontSize', 20);
grid on;
% -------------------------------------------------------------------------
% skumulowany wykres słupkowy - typ pozostałości po portach w zależności od państwa
no_missing_re = data_table(~ismissing(data_table.RE), :);
for i = 1:length(no_missing_re.COUNTRY)
    seperated_name = allwords(char(no_missing_re.COUNTRY(i)));
    if strcmp(seperated_name{1}, 'Egypt:')
        seperated_name{1} = 'Egypt';
    end
    if strcmp(seperated_name{1}, 'GR:') || strcmp(seperated_name{1}, 'GR')
        seperated_name{1} = 'Greece';
    end
    if strcmp(seperated_name{1}, 'Malta:')
        seperated_name{1} = 'Malta';
    end
    if strcmp(seperated_name{1}, 'TR:') || strcmp(seperated_name{1}, 'TR')
        seperated_name{1} = 'Turkey';
    end
    if strcmp(seperated_name{1}, 'UK')
        seperated_name{1} = 'United Kingdom';
    end
    no_missing_re.COUNTRY{i} = seperated_name{1};
end

unique_country = unique(no_missing_re.COUNTRY);
counts = zeros(8, numel(unique_country));

for i = 1:length(unique_country)
    indices = strcmp(no_missing_re.COUNTRY, unique_country(i));

    counts(1, i) = sum(countcats(categorical(no_missing_re.BW(indices))));
    counts(2, i) = sum(countcats(categorical(no_missing_re.QU(indices))));
    counts(3, i) = sum(countcats(categorical(no_missing_re.MO(indices))));
    counts(4, i) = sum(countcats(categorical(no_missing_re.CN(indices))));
    counts(5, i) = sum(countcats(categorical(no_missing_re.SL(indices))));
    counts(6, i) = sum(countcats(categorical(no_missing_re.SH(indices))));
    counts(7, i) = sum(countcats(categorical(no_missing_re.PH(indices))));
    counts(8, i) = sum(countcats(categorical(no_missing_re.CO(indices))));
end

colors = [0 0.4470 0.7410;
          0.8500 0.3250 0.0980;
          0.9290 0.6940 0.1250;
          0.4940 0.1840 0.5560;
          0.4660 0.6740 0.1880;
          0.3010 0.7450 0.9330;
          0.6350 0.0780 0.1840;
          1 0 1];

figure;
bar(counts', 'stacked');
hold on
Colors = colormap(colors);

for i = 1:length(unique_country)
    for j = 1:8
        ax = gca;
        ax.ColorOrder = Colors;
    end
end

legend('', 'Location', 'eastoutside', 'Orientation', 'vertical');

legend_labels = ["falochron", "nabrzeże", "miejsce do cumowania", "kanał", "pochylnia", "stocznia", "latarnia morska", "cothon"];
for j =1:8
    scatter([NaN NaN], [NaN NaN], "filled", 'Color', Colors(j, :), 'DisplayName', legend_labels(j))
end
hold off
xticks(1:numel(unique_country));
xticklabels(unique_country);
title('Liczba struktów w zależności od państwa', 'FontSize', 20);
grid on;