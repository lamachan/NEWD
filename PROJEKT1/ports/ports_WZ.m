clc;
clear;
close all;

file_path = 'ports.csv';

opts = detectImportOptions(file_path);
opts.VariableTypes{1} = 'char';

data_table = readtable(file_path, opts);
% summary(data_table);

missing_counts = sum(ismissing(data_table));
% disp('Number of missing values in each column:');
% disp(missing_counts);

% do usunięcia:
%   NAME, NAME_MOD - nieużyteczne
columns_to_drop = {'NAME', 'NAME_MOD'};
data_table = removevars(data_table, columns_to_drop);

% usunięcie brakujących wartości z 'COUNTRY' i 'AM'
data_table = data_table(~ismissing(data_table.COUNTRY), :);
data_table = data_table(~ismissing(data_table.AM), :);

column_names = data_table.Properties.VariableNames;
% disp('Column Names:');
% disp(column_names);
% NB - id
% LATITUDE - szerokość geograficzna (+ = N, - = S)
% LONGITUDE - długość geograficzne (+ = E, - = W)
% AUTH_ANC - autor starożytny wspominający o porcie
% AUTH_MOD - autor współczesny wsponinający o porcie
% COUNTRY - kraj lub region w 2012 r.
% AM:
%     "a" = autor starożytny
%     "m" - autor współczesny
% PP - ?
% RE:
%     "r" = port nadal widoczny w 2012 r.
%     "rs" = port zatopiony lub zamulony
% BW - widoczny falochron
% QU - widoczne nabrzeże, molo lub pomost
% MO - widoczne miejsce do cumowania (np. pachołek)
% CN - widoczny kanał (do żeglugi, płukania basenu lub odmulania)
% SL - widoczna pochylnia
% SH - widoczna stocznia
% PH - widoczna latarnia morska
% CO - widoczny "cothon", czyli kolisty basen wydrążony przez człowieka

% zmiana formatu współrzędnych geograficznych
data_table.LATITUDE = str2double(strrep(data_table.LATITUDE, ',', '.'));
data_table.LONGITUDE = str2double(strrep(data_table.LONGITUDE, ',', '.'));

% porty o których stanie mamy informacje
no_missing_re = data_table(~ismissing(data_table.RE), :);

% wizualizacja położenia portów na mapie
figure;
geoscatter(data_table.LATITUDE, data_table.LONGITUDE, 5, 'r', 'filled');
geobasemap('landcover');
title('Położenie portów', 'FontSize', 20);

% wykres kołowy - rodzaje autorów
figure;
counts = countcats(categorical(data_table.AM));
pie(counts)
colors = [1 0 0; 0 0 1];
colormap(colors);
legend({'starożytni', 'współcześni'}, 'Location', 'northwest');
title('Autorzy', 'FontSize', 20);

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

% wizualizacje położenia portów, o których stanie mamy informacje i
% zwierają struktury
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



% histogram liczby struktur w portach widocznych
empty_cells = cellfun(@isempty, no_missing_re{:, [10:17]});
structure_counts = sum(~empty_cells, 2);

figure;
histogram(structure_counts);
xlabel('liczba struktur');
ylabel('częstość');
title('Histogram liczby struktur w portach widocznych', 'FontSize', 20);
grid on;

% mapa liczby struktur w portach widocznych
figure;
A = 20; % marker size
C = structure_counts; % marker color
geoscatter(no_missing_re.LATITUDE, no_missing_re.LONGITUDE, A, C,'filled');
geobasemap('landcover');
colormap(flipud(hot(7)));
cbh = colorbar;
cbh.Ruler.Exponent = 0;
title('Liczba struktur w portach widocznych', 'FontSize', 20);

% wykres słupkowy liczby portów z widoczną daną strukturą
counts = sum(strcmp(no_missing_re{:, [10:17]}, 'X'));
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