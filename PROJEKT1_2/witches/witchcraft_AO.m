clc;
clear;
close all;

file_path = 'WDB_Accused.csv';

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

% wykres kołowy - płeć
figure;
counts = countcats(categorical(data_table.Sex));
pie(counts)
colors = [0.867 0.110 0.467;0.173 0.498 0.722];
colormap(colors);
legend({'kobiety', 'mężczyźni'}, 'Location', 'best');
title('Płeć osoby oskarżonej o czary', 'FontSize', 20);

% wykres kołowy - stan cywilny
figure;
status = categorical(data_table.MaritalStatus);
status = removecats(status, "/");
status = rmmissing(status);
counts = countcats(status);
pie(counts)
legend({"związek nieuregulowany", "w małżeństwie", "samotny", "brak informacji", "owdowiały"},'Location', 'best');
title('Stan cywilny', 'FontSize', 20);

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


% histogram - wiek
figure;
histogram(data_table.Age)
title('Rozkład wieku osób oskarżonych o czary', 'FontSize', 20);
grid on;

% histogram - najczęstsze zawody; top 10
figure;
histogram(categorical(data_table.Occupation))
h = histogram(categorical(data_table.Occupation));
h.DisplayOrder = 'descend';
h.NumDisplayBins = 10;
title('Zawody osób oskarżanych o czary - top 10', 'FontSize', 20);
grid on;

% mapa - najczęstsze miejsca zamieszkania; top 10

%histogram(categorical(data_table.Res_settlement))
%h = histogram(categorical(data_table.Res_settlement));
%h.DisplayOrder = 'descend';
%h.NumDisplayBins = 10;
figure;
Latitude = [56.1867, 55.9311, 55.9055, 57.3420, 55.8765, 55.9463, 55.8931, 55.9349, 55.9595, 56.0130];
Longitude = [-3.5515, -2.8282, -3.1333, -4.6723, -2.9130, -3.0583, -3.0666, -3.1259, -2.9845, -3.6035];
Settlement = ["Crook of Devon", "Sammuelston", "Gilmerton", "Buntoit", "Paiston", "Fisherrow", "Dalkeith", "Niddry", "Prestonpans", "Barrowstouness"];
geoscatter(Latitude, Longitude, 5, 'b', 'filled');
text(Latitude, Longitude, Settlement, 'Vert','bottom', 'Horiz','center', 'FontSize',10)
geobasemap('landcover');
%title('Pochodzenie - top 10', 'FontSize', 20);