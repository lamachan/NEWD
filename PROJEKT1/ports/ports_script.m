clc;
clear;
close all;

file_path = 'ports.csv';

opts = detectImportOptions(file_path);
opts.VariableTypes{1} = 'char';

data_table = readtable(file_path, opts);
summary(data_table);

missing_counts = sum(ismissing(data_table));
disp('Number of missing values in each column:');
disp(missing_counts);

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

% wizualizacja położenia portów na mapie
figure(1);
geoscatter(data_table.LATITUDE, data_table.LONGITUDE, 5, 'r', 'filled');
geobasemap('landcover');
title('Położenie portów');

% wizualizacja położenia portów z podziałem na rodzaj autora
figure(2);
for am = unique(data_table.AM)'
    indices = strcmp(data_table.AM, am);
    if strcmp(am, 'm')
        geoscatter(data_table.LATITUDE(indices), data_table.LONGITUDE(indices), 5, 'b', 'filled');
    else
        geoscatter(data_table.LATITUDE(indices), data_table.LONGITUDE(indices), 5, 'r', 'filled');
    end
    hold on;
end
geobasemap('landcover');
title('Położenie portów - autor');
legend({'starożytny', 'współczesny'}, 'Location', 'northwest');

% wykres kołowy - rodzaje autorów
figure(3);
counts = countcats(categorical(data_table.AM));
pie(counts)
colors = [1 0 0; 0 0 1];
colormap(colors);
legend({'starożytni', 'współcześni'}, 'Location', 'northwest');
title('Autorzy');