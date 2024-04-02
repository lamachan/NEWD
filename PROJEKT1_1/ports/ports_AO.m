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

% wykres kołowy - stan portów
figure(1);
state_array = categorical(data_table.RE);
len = length(state_array);
counts = countcats(state_array);
counts(3) = len - sum(counts);
pie(counts)
colors = [0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250];
colormap(colors);
legend({'na powierzchni', 'pod wodą', 'brak'}, 'Location', 'northwest');
title('Pozostałości po portach', 'FontSize', 20);

% wykres słupkowy - liczba portów według państwa

figure(2)
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

% skumulowany wykres słupkowy - typ pozostałości po portach w zależności od
% państwa

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

figure(3)
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