% NEWD - Wizualizacja danych 2024Z
% Projekt 1 - Matlab
% Zespół:
    % Alicja Oczkowska
    % Szymon Posiadała
    % Weronika Zbierowska
clc;
clear;
close all;

file_path = 'global-data-on-sustainable-energy.csv';

opts = detectImportOptions(file_path);

data_table = readtable(file_path, opts);
summary(data_table);

missing_counts = sum(ismissing(data_table));
disp('Number of missing values in each column:');
disp(missing_counts);

% do usunięcia:
% Renewables__EquivalentPrimaryEnergy_ - dużo brakujących wartości
columns_to_drop = {'Renewables__EquivalentPrimaryEnergy_'};
data_table = removevars(data_table, columns_to_drop);

% -------------------------------------------------------------------------
% WYKRESY
% -------------------------------------------------------------------------
% Elektryczność z paliw kopalnych vs PKB per capita - wykres bąbelkowy na przestrzeni lat
figure;

idx = data_table.Year == 2000;
scatter(data_table.gdp_per_capita(idx), data_table.ElectricityFromFossilFuels_TWh_(idx), 'o', 'filled', 'SizeData', data_table.Value_co2_emissions_kt_by_country(idx)/10000, 'MarkerEdgeColor', 'black');  % Plot data for selected year
xlim([0, max(data_table.gdp_per_capita)]);
ylim([0, max(data_table.ElectricityFromFossilFuels_TWh_)]);
xlabel('PKB per capita');
ylabel('elektryczność wytwarzana z paliw kopalnych [TWh]');
title('Elektryczność z paliw kopalnych vs PKB per capita vs emisja CO2 per capita w roku 2000', 'FontSize', 20);

slider = uicontrol('Style', 'slider', 'Min', min(data_table.Year), 'Max', max(data_table.Year),...
    'Value', min(data_table.Year), 'Position', [150, 10, 300, 20], 'Callback', {@update_plot_bubble1, data_table});
% -------------------------------------------------------------------------
% Rozkład elektryczności według źródła vs kraj (Top 20) na przestrzeni lat
figure;

data_table.TotalEnergy_TWh_ = data_table.ElectricityFromFossilFuels_TWh_ + data_table.ElectricityFromNuclear_TWh_ + data_table.ElectricityFromRenewables_TWh_;
idx = data_table.Year == 2000 & ~isnan(data_table.TotalEnergy_TWh_);

sorted_data = sortrows(data_table(idx,:), 'TotalEnergy_TWh_', 'descend');
top_countries = sorted_data(1:20, :);

barData = [top_countries.ElectricityFromFossilFuels_TWh_, top_countries.ElectricityFromNuclear_TWh_, top_countries.ElectricityFromRenewables_TWh_];
bar(barData, 'stacked');
set(gca, 'XTick', 1:20, 'XTickLabel', top_countries.Entity);
ylim([0, max(data_table.TotalEnergy_TWh_)]);
xlabel('Kraj');
ylabel('Elektryczność [TWh]');
title('Rozkład elektryczności według źródła vs kraj (Top 20) w roku 2000', 'FontSize', 20);
legend('paliwa kopalne', 'atom', 'źródła odnawialne', 'Location', 'northeast');

years = unique(data_table.Year);
dropdown = uicontrol('Style', 'popupmenu', 'String', cellstr(num2str(years)), 'Position', [40, 10, 50, 20], 'Callback', {@update_plot_bar1, data_table});

uicontrol('Style', 'pushbutton', 'String', '<', 'Position', [10, 10, 30, 20], 'Callback', {@decreaseYear, dropdown, data_table, @update_plot_bar1});
uicontrol('Style', 'pushbutton', 'String', '>', 'Position', [90, 10, 30, 20], 'Callback', {@increaseYear, dropdown, data_table, @update_plot_bar1});
% -------------------------------------------------------------------------
% Wsparcie finansowe dla państw rozwijających się na projekty czystej energii vs kraj (Top 20) na przestrzeni lat
figure;

idx = data_table.Year == 2000 & ~isnan(data_table.FinancialFlowsToDevelopingCountries_US__);
sorted_data = sortrows(data_table(idx,:), 'FinancialFlowsToDevelopingCountries_US__', 'descend');
top_countries = sorted_data(1:20, :);

bar(top_countries.FinancialFlowsToDevelopingCountries_US__);
set(gca, 'XTick', 1:20, 'XTickLabel', top_countries.Entity);
ylim([0, max(data_table.FinancialFlowsToDevelopingCountries_US__)]);
xlabel('Kraj');
ylabel('Wparcie finansowe [$]');
title('Wsparcie finansowe dla państw rozwijających się na projekty czystej energii vs kraj (Top 20) w roku 2000', 'FontSize', 20);

years = unique(data_table.Year);
dropdown = uicontrol('Style', 'popupmenu', 'String', cellstr(num2str(years)), 'Position', [40, 10, 50, 20], 'Callback', {@update_plot_bar2, data_table});

uicontrol('Style', 'pushbutton', 'String', '<', 'Position', [10, 10, 30, 20], 'Callback', {@decreaseYear, dropdown, data_table, @update_plot_bar2});
uicontrol('Style', 'pushbutton', 'String', '>', 'Position', [90, 10, 30, 20], 'Callback', {@increaseYear, dropdown, data_table, @update_plot_bar2});
% -------------------------------------------------------------------------
% Emisja CO2 vs kraj (Top 20) na przestrzeni lat
figure;

idx = data_table.Year == 2000 & ~isnan(data_table.Value_co2_emissions_kt_by_country);
sorted_data = sortrows(data_table(idx,:), 'Value_co2_emissions_kt_by_country', 'descend');
top_countries = sorted_data(1:20, :);

bar(top_countries.Value_co2_emissions_kt_by_country);
set(gca, 'XTick', 1:20, 'XTickLabel', top_countries.Entity);
ylim([0, max(data_table.Value_co2_emissions_kt_by_country)]);
xlabel('Kraj');
ylabel('Emisja CO2 [kT]');
title('Emisja CO2 vs kraj (Top 20) w roku 2000', 'FontSize', 20);

years = unique(data_table.Year);
dropdown = uicontrol('Style', 'popupmenu', 'String', cellstr(num2str(years)), 'Position', [40, 10, 50, 20], 'Callback', {@update_plot_bar3, data_table});

uicontrol('Style', 'pushbutton', 'String', '<', 'Position', [10, 10, 30, 20], 'Callback', {@decreaseYear, dropdown, data_table, @update_plot_bar3});
uicontrol('Style', 'pushbutton', 'String', '>', 'Position', [90, 10, 30, 20], 'Callback', {@increaseYear, dropdown, data_table, @update_plot_bar3});
% -------------------------------------------------------------------------
% Dostęp do elektryczności i energia odnawialna na przestrzeni lat
figure;

yearly_means = grpstats(data_table(:, 2:end), 'Year', 'mean');
years = yearly_means.Year;
mean_values = [yearly_means.mean_AccessToElectricity__OfPopulation_, yearly_means.mean_RenewableEnergyShareInTheTotalFinalEnergyConsumption___];

plot(years, mean_values(:, 1), 'o-', 'DisplayName', 'Dostęp do elektryczności [%]');
hold on;
plot(years, mean_values(:, 2), 'o-', 'DisplayName', 'Energia odnawialna [%]');
hold off;
xlim([2000, 2019]);
ylim([0, 100]);
xlabel('Rok');
ylabel('Odsetek [%]')
title('Dostęp do elektryczności i energia odnawialna w latach 2000-2019', 'FontSize', 20);
legend('Location', 'northeast');
% -------------------------------------------------------------------------
% Elektryczność na przestrzeni lat
figure;

yearly_means = grpstats(data_table(:, 2:end), 'Year', 'mean');
years = yearly_means.Year;
mean_values = [yearly_means.mean_ElectricityFromFossilFuels_TWh_, yearly_means.mean_ElectricityFromNuclear_TWh_, yearly_means.mean_ElectricityFromRenewables_TWh_];

area(years, mean_values, 'LineStyle', 'none');
xlim([2000, 2020]);
ylim([0, 1.1 * max(sum(mean_values, 2))]);
xlabel('Rok');
ylabel('Elektryczność [TWh]')
title('Rozkład elektryczności wg źródła w latach 2000-2020', 'FontSize', 20);
legend('paliwa kopalne', 'atom', 'źródła odnawialne', 'Location', 'northwest');
% -------------------------------------------------------------------------
% Zależność dostępu do elektryczności od gęstości zaludnienia - wykres punktowy
figure;

idx = data_table.Year == 2020 & data_table.AccessToElectricity__OfPopulation_ < 100 & ~isnan(data_table.AccessToElectricity__OfPopulation_) & ~isnan(data_table.gdp_per_capita);
x = data_table.gdp_per_capita(idx);
y = data_table.AccessToElectricity__OfPopulation_(idx);
scatter(x, y, 'o', 'filled', 'SizeData', 30);
xlim([0, max(x)]);
ylim([0, max(y)]);
xlabel('PKB per capita [$]');
ylabel('Dostęp do elektryczności');
title('Zależność dostępu do elektryczności od PKB per capita', 'FontSize', 20);
% -------------------------------------------------------------------------
% FUNKCJE CALLBACK DO OBSŁUGI ELEMENTÓW UI WYKRESÓW INTERAKTYWNYCH
% -------------------------------------------------------------------------
% Callback - plot bubble 1
function update_plot_bubble1(source, ~, data_table)
    year = round(get(source, 'Value'));
    idx = data_table.Year == year;
    scatter(data_table.gdp_per_capita(idx), data_table.ElectricityFromFossilFuels_TWh_(idx), 'o', 'filled', 'SizeData', data_table.Value_co2_emissions_kt_by_country(idx)/10000, 'MarkerEdgeColor', 'black');  % Plot data for selected year
    xlim([0, max(data_table.gdp_per_capita)]);
    ylim([0, max(data_table.ElectricityFromFossilFuels_TWh_)]);
    xlabel('PKB per capita');
    ylabel('elektryczność wytwarzana z paliw kopalnych (węgiel, ropa naftowa, gaz ziemny) [TWh]');
    title('Elektryczność z paliw kopalnych vs PKB per capita w roku ', num2str(year), 'FontSize', 20);
end
% -------------------------------------------------------------------------
% Callback - plot bar 1
function update_plot_bar1(source, ~, data_table)
    year_idx = get(source, 'Value');
    selected_year = unique(data_table.Year(year_idx));
    idx = data_table.Year == selected_year & ~isnan(data_table.TotalEnergy_TWh_);
    sorted_data = sortrows(data_table(idx,:), 'TotalEnergy_TWh_', 'descend');
    top_countries = sorted_data(1:20, :);
    
    barData = [top_countries.ElectricityFromFossilFuels_TWh_, top_countries.ElectricityFromNuclear_TWh_, top_countries.ElectricityFromRenewables_TWh_];
    bar(barData, 'stacked');
    set(gca, 'XTick', 1:20, 'XTickLabel', top_countries.Entity);
    ylim([0, max(data_table.TotalEnergy_TWh_)]);
    xlabel('Kraj');
    ylabel('Elektryczność [TWh]');
    title('Rozkład elektryczności według źródła vs kraj (Top 20) w roku ', num2str(selected_year), 'FontSize', 20);
    legend('paliwa kopalne', 'atom', 'źródła odnawialne', 'Location', 'northeast');
end
% -------------------------------------------------------------------------
% Callback - plot bar 2
function update_plot_bar2(source, ~, data_table)
    year_idx = get(source, 'Value');
    selected_year = unique(data_table.Year(year_idx));
    idx = data_table.Year == selected_year & ~isnan(data_table.FinancialFlowsToDevelopingCountries_US__);
    sorted_data = sortrows(data_table(idx,:), 'FinancialFlowsToDevelopingCountries_US__', 'descend');
    top_countries = sorted_data(1:20, :);
    
    bar(top_countries.FinancialFlowsToDevelopingCountries_US__);
    set(gca, 'XTick', 1:20, 'XTickLabel', top_countries.Entity);
    ylim([0, max(data_table.FinancialFlowsToDevelopingCountries_US__)]);
    xlabel('Kraj');
    ylabel('Wsparcie finansowe [$]');
    title('Wsparcie finansowe dla państw rozwijających się na projekty czystej energii vs kraj (Top 20) w roku ', num2str(selected_year), 'FontSize', 20);
end
% -------------------------------------------------------------------------
% Callback - plot bar 3
function update_plot_bar3(source, ~, data_table)
    year_idx = get(source, 'Value');
    selected_year = unique(data_table.Year(year_idx));
    idx = data_table.Year == selected_year & ~isnan(data_table.Value_co2_emissions_kt_by_country);
    sorted_data = sortrows(data_table(idx,:), 'Value_co2_emissions_kt_by_country', 'descend');
    top_countries = sorted_data(1:20, :);

    bar(top_countries.Value_co2_emissions_kt_by_country);
    set(gca, 'XTick', 1:20, 'XTickLabel', top_countries.Entity);
    ylim([0, max(data_table.Value_co2_emissions_kt_by_country)]);
    xlabel('Kraj');
    ylabel('Emisja CO2 [kT]');
    title('Emisja CO2 vs kraj (Top 20) w roku ', num2str(selected_year), 'FontSize', 20);
end
% -------------------------------------------------------------------------
% FUNKCJE POMOCNICZNE DO OBSŁUGI STRZAŁEK W WYKRESACH INTERAKTYWNYCH
% -------------------------------------------------------------------------
function decreaseYear(~, ~, dropdown, data_table, update_function)
    current_value = get(dropdown, 'Value');
    if current_value > 1
        set(dropdown, 'Value', current_value - 1);
        update_function(dropdown, [], data_table);
    end
end

function increaseYear(~, ~, dropdown, data_table, update_function)
    current_value = get(dropdown, 'Value');
    num_years = numel(get(dropdown, 'String'));
    if current_value < num_years
        set(dropdown, 'Value', current_value + 1);
        update_function(dropdown, [], data_table);
    end
end