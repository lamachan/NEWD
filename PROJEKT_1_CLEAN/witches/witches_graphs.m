% NEWD - Wizualizacja danych 2024Z
% Projekt 1 - Matlab
% Zespół:
    % Alicja Oczkowska
    % Szymon Posiadała
    % Weronika Zbierowska
clc;
clear;
close all;

% -------------------------------------------------------------------------
% PLIK WDB_RitaualObjects.csv
% -------------------------------------------------------------------------
file_path_RO = 'data/WDB_RitualObject.csv';

opts = detectImportOptions(file_path_RO);

data_table_RO = readtable(file_path_RO, opts);
summary(data_table_RO);

% -------------------------------------------------------------------------
% Top 20 najczęściej używanych przedmiotów w trakcie rytuałów
[counts, category] = groupcounts(data_table_RO.RitualObject_Type);
countsTable = table(category, counts, 'VariableNames', {'Category', 'Count'});
sortedCountsTable = sortrows(countsTable, 'Count', 'descend');
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
% PLIK WDB_MusicalInstrument.csv
% -------------------------------------------------------------------------
file_path_MI = 'data/WDB_MusicalInstrument.csv';

opts = detectImportOptions(file_path_MI);

data_table_MI = readtable(file_path_MI, opts);
summary(data_table_MI);

% -------------------------------------------------------------------------
% Top 20 najczęściej używanych przedmiotów w trakcie rytuałów
[counts, category] = groupcounts(data_table_MI.MusicalInstrument_Type);
countsTable = table(category, counts, 'VariableNames', {'Category', 'Count'});
sortedCountsTable = sortrows(countsTable, 'Count', 'descend');
sortedCountsTable = sortedCountsTable(1:4, :);
categoricalX = categorical(sortedCountsTable.Category);
categoricalX = reordercats(categoricalX, sortedCountsTable.Category);
totalCounts = sum(sortedCountsTable.Count);
categoryPercentages = sortedCountsTable.Count / totalCounts * 100;

figure;
pie(categoryPercentages);
legendLabels = cellstr(sortedCountsTable.Category);
legend(legendLabels, 'Location', 'best');
axis square;
title('Instrumenty muzyczne używane w trakcie rytuałów', 'FontSize', 20);

% -------------------------------------------------------------------------
% PLIK WDB_Accused.csv
% -------------------------------------------------------------------------
file_path = 'data/WDB_Accused.csv';

opts = detectImportOptions(file_path);
data_table = readtable(file_path, opts);

columns_to_drop = {'AccusedRef','AccusedSystemId','AccusedID','FirstName','LastName','M_Firstname','M_Surname','Alias','Patronymic','DesTitle','Age_estcareer','Age_estchild','Res_parish','Res_presbytery','Res_county','Res_burgh','Res_NGR_Letters','Res_NGR_Easting','Res_NGR_Northing','Ethnic_origin','Notes','Createdby','Createdate','Lastupdatedby','Lastupdatedon'};
data_table = removevars(data_table, columns_to_drop);

missing_counts = sum(ismissing(data_table));
disp('Number of missing values in each column:');
disp(missing_counts);

column_names = data_table.Properties.VariableNames;
disp('Column Names:');
disp(column_names);

% -------------------------------------------------------------------------
% wykres kołowy - płeć
figure;
counts = countcats(categorical(data_table.Sex));
pie(counts)
colors = [0.867 0.110 0.467;0.173 0.498 0.722];
colormap(colors);
legend({'kobiety', 'mężczyźni'}, 'Location', 'best');
title('Płeć osoby oskarżonej o czary', 'FontSize', 20);
% -------------------------------------------------------------------------
% wykres kołowy - stan cywilny
figure;
status = categorical(data_table.MaritalStatus);
status = removecats(status, "/");
status = rmmissing(status);
counts = countcats(status);
pie(counts)
legend({"związek nieuregulowany", "w małżeństwie", "samotny", "brak informacji", "owdowiały"},'Location', 'best');
title('Stan cywilny', 'FontSize', 20);
% -------------------------------------------------------------------------
% wykres kołowy - status socjoekonomiczny
figure;
status = categorical(data_table.SocioecStatus);
status = rmmissing(status);
counts = countcats(status);
pie(counts)
colors = [0.988 0.553 0.349;0.569 0.749 0.859;0.878 0.953 0.973;1 1 0.749;0.922 0.255 0;1 0.824 0.341;0.271 0.459 0.706];
colormap(colors);
legend({"właściciel ziemski", "bez ziemi", "klasa niższa", "klasa średnia", "szlachta", "klasa wyższa", "bardzo ubodzy"},'Location', 'best');
title('Status socjoekonomiczny', 'FontSize', 20);
% -------------------------------------------------------------------------
% histogram - wiek
figure;
histogram(data_table.Age)
title('Rozkład wieku osób oskarżonych o czary', 'FontSize', 20);
grid on;
% -------------------------------------------------------------------------
% histogram - najczęstsze zawody; top 10
figure;
histogram(categorical(data_table.Occupation))
h = histogram(categorical(data_table.Occupation));
h.DisplayOrder = 'descend';
h.NumDisplayBins = 10;
title('Zawody osób oskarżanych o czary - top 10', 'FontSize', 20);
grid on;
% -------------------------------------------------------------------------
% mapa - najczęstsze miejsca zamieszkania; top 10
figure;
Latitude = [56.1867, 55.9311, 55.9055, 57.3420, 55.8765, 55.9463, 55.8931, 55.9349, 55.9595, 56.0130];
Longitude = [-3.5515, -2.8282, -3.1333, -4.6723, -2.9130, -3.0583, -3.0666, -3.1259, -2.9845, -3.6035];
Settlement = ["Crook of Devon", "Sammuelston", "Gilmerton", "Buntoit", "Paiston", "Fisherrow", "Dalkeith", "Niddry", "Prestonpans", "Barrowstouness"];
geoscatter(Latitude, Longitude, 5, 'b', 'filled');
text(Latitude, Longitude, Settlement, 'Vert','bottom', 'Horiz','center', 'FontSize',10)
geobasemap('landcover');
% -------------------------------------------------------------------------
% PLIK WDB_Trial.csv
% -------------------------------------------------------------------------
data = readtable('data/WDB_Trial.csv');

verdictData = data.Verdict;
sentenceData = data.Sentence;

verdictCounts = countcats(categorical(verdictData));
sentenceCounts = countcats(categorical(sentenceData));

% -------------------------------------------------------------------------
% wykres kołowy - werdykt
figure;
verdictLabels = categories(categorical(verdictData));
verdictPie = pie(verdictCounts, verdictLabels);
title('Verdict', 'FontSize', 20);

for i = 1:numel(verdictLabels)
    verdictPieText{i} = sprintf('%s: %.1f%%', verdictLabels{i}, (verdictCounts(i) / sum(verdictCounts)) * 100);
end
verdictPieHandles = findobj(verdictPie, 'Type', 'patch');
legend(verdictPieHandles, verdictPieText, 'Location', 'eastoutside');

% -------------------------------------------------------------------------
% wykres kołowy - kara
figure;
sentenceLabels = categories(categorical(sentenceData));
sentencePie = pie(sentenceCounts, sentenceLabels);
title('Sentence', 'FontSize', 20);

for i = 1:numel(sentenceLabels)
    sentencePieText{i} = sprintf('%s: %.1f%%', sentenceLabels{i}, (sentenceCounts(i) / sum(sentenceCounts)) * 100);
end
sentencePieHandles = findobj(sentencePie, 'Type', 'patch');
legend(sentencePieHandles, sentencePieText, 'Location', 'eastoutside');

colormap(jet);

% -------------------------------------------------------------------------
% PLIK WDB_Torture.csv
% -------------------------------------------------------------------------
data = readtable('data/WDB_Torture.csv');

tortureTypes = data.Torturetype;
validEntries = ~strcmp(tortureTypes, '');
tortureTypes = tortureTypes(validEntries);
uniqueTypes = unique(tortureTypes);

% -------------------------------------------------------------------------
% wykres kołowy - rodzaje tortur
counts = zeros(size(uniqueTypes));
for i = 1:length(uniqueTypes)
    counts(i) = sum(strcmp(tortureTypes, uniqueTypes{i}));
end

percentages = counts / sum(counts);
[percentages, idx] = sort(percentages, 'descend');
uniqueTypes = uniqueTypes(idx);
counts = counts(idx);

figure;
hPie = pie(counts, uniqueTypes);
title('Distribution of Torture Types', 'FontSize', 20);

percentValues = 100*percentages;
percentValues = round(percentValues,2);
textObjs = findobj(hPie,'Type','text');
for i = 1:numel(percentValues)
    percentStr = sprintf('%s: %.2f%%', uniqueTypes{i}, percentValues(i));
    textObjs(i).String = percentStr;
end

% -------------------------------------------------------------------------
% PLIK WDB_Ordeal.csv
% -------------------------------------------------------------------------
data = readtable('data/WDB_Ordeal.csv');

ordealtype_column = data.Ordealtype;
unique_ordealtype = unique(ordealtype_column);

% -------------------------------------------------------------------------
% wykres kołowy - rodzaje testów na wiedźmę
counts = zeros(size(unique_ordealtype));
for i = 1:numel(unique_ordealtype)
    counts(i) = sum(strcmp(ordealtype_column, unique_ordealtype{i}));
end

total_count = sum(counts);
percentages = counts / total_count * 100;

figure;
pie(percentages);
legend(unique_ordealtype, 'Location', 'bestoutside');
title('Distribution of Ordeal Types', 'FontSize', 20);

% -------------------------------------------------------------------------
% PLIK WDB_Case.csv
% -------------------------------------------------------------------------
data = readtable('data/WDB_Case.csv');

dancingData = categorical(data.Dancing);
singingData = categorical(data.Singing);
foodAndDrinkData = categorical(data.FoodAndDrink);
witchesMeetingData = categorical(data.WitchesMeeting);

% -------------------------------------------------------------------------
% wykresy kołowe - aktywności na spotkaniach wiedźm
createPieChart(dancingData, 'Dancing');
createPieChart(singingData, 'Singing');
createPieChart(foodAndDrinkData, 'FoodAndDrink');
createPieChart(witchesMeetingData, 'Witchesmeeting');

function createPieChart(data, columnName)
    uniqueValues = categories(data);
    counts = countcats(data);

    totalValues = sum(counts);
    percentages = (counts / totalValues) * 100;

    figure;
    hPie = pie(counts, uniqueValues);
    title(['Distribution of ' columnName], 'FontSize', 20);

    labels = cellstr(num2str(percentages, '%.2f%%'));
    textObjs = findobj(hPie, 'Type', 'text');
    for i = 1:numel(textObjs)
        textObjs(i).String = strcat(uniqueValues{i}, {' '}, labels{i});
    end
end