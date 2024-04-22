file_path = 'penguins_lter.csv';
data = readtable(file_path);
islands = unique(data.Island);
pingwin_counts = zeros(size(islands));
for i = 1:length(islands)
    pingwin_counts(i) = sum(strcmp(data.Island, islands{i}));
end
figure;
pie(pingwin_counts, islands);
title('Proporcje wszystkich pingwinów na poszczególnych wyspach');

%--------------------------------------------------------------------

islands = unique(data.Island);
for i = 1:length(islands)
    island_data = data(strcmp(data.Island, islands{i}), :);
    species_counts = tabulate(island_data.Species);
    species_names = species_counts(:, 1);
    species_percentages = cell2mat(species_counts(:, 3)) / 100;
    figure;
    pie(species_percentages, species_names);
    title(['Proporcje gatunków pingwinów na wyspie ', islands{i}]);
end


%--------------------------------------------------------------------

data = data(strcmp(data.Sex, 'MALE') | strcmp(data.Sex, 'FEMALE'), :);

features = {'CulmenLength_mm_', 'CulmenDepth_mm_', 'FlipperLength_mm_', 'BodyMass_g_'};

feature_values = cell(length(features), 1);
species_names = cell(length(features), 1);

for i = 1:length(features)
    feature_values{i} = data.(features{i});
    
    species_names{i} = strcat(data.Species, "-", data.Sex);
end

for i = 1:length(features)
    figure;
    boxplot(feature_values{i}, species_names{i});
    ylabel(strrep(features{i}, '_', ' '));
    title(['Wykres pudełkowy dla cechy ', strrep(features{i}, '_', ' ')]);
    xtickangle(45);
end

%----------------------------------------------------

sex_counts = countcats(categorical(data.Sex));

species_counts = countcats(categorical(data.Species));

figure;
pie(sex_counts);
title('Proporcje płci wszystkich pingwinów');
legend({'Female', 'Male'}, 'Location', 'eastoutside');

figure;
pie(species_counts);
title('Proporcje gatunków wszystkich pingwinów');
legend(unique(data.Species), 'Location', 'eastoutside');

