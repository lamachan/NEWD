clc;
clear;
close all;

file_path = 'global-data-on-sustainable-energy.csv';

opts = detectImportOptions(file_path);

data_table = readtable(file_path, opts);
% summary(data_table);
% 
% missing_counts = sum(ismissing(data_table));
% disp('Number of missing values in each column:');
% disp(missing_counts);

% do usunięcia:
% Renewables__EquivalentPrimaryEnergy_ - dużo brakujących wartości
columns_to_drop = {'Renewables__EquivalentPrimaryEnergy_'};
data_table = removevars(data_table, columns_to_drop);

% KOLUMNY:
% Entity - nazwa kraju lub regionu obserwacji
% Year - rok obserwacji (2000-2020)
% AccessToElectricity__OfPopulation_ - populacji z dostępem do elektryczności [%]
% AccessToCleanFuelsForCooking - ???
% Renewable_electricity_generating_capacity_per_capita - zdolność wytwórcza elektryczności ze źródeł odnawialnych [per capita]
% FinancialFlowsToDevelopingCountries_US__ - wsparcie finansowe dla państw rozwijających się na projekty czystej energii [$]
% RenewableEnergyShareInTheTotalFinalEnergyConsumption___ - energia odnawialna w całkowitym zużyciu energii [%]
% ElectricityFromFossilFuels_TWh_ - elektryczność wytwarzana z paliw kopalnych (węgiel, ropa naftowa, gaz ziemny) [TWh]
% ElectricityFromNuclear_TWh_ - elektryczność wytwarzana z energii atomowej [TWh]
% ElectricityFromRenewables_TWh_ - elektryczność wytwarzana ze źródeł odnawialnych [TWh]
% Low_carbonElectricity__Electricity_ - elektryczność wytwarzana ze źródeł niskoemisyjnych (atom, odnawialne) [%]
% PrimaryEnergyConsumptionPerCapita_kWh_person_ - zużycie energii na osobę [kWh per capita]
% EnergyIntensityLevelOfPrimaryEnergy_MJ__2017PPPGDP_ - zużycie energii na jednostkę GDP w parytecie siły nabywczej [MJ/$2011 PPP GDP]
% Value_co2_emissions_kt_by_country - emisja dwutlenku węgla na osobę [tona metryczna per capita]
% Renewables__EquivalentPrimaryEnergy_ - ???
% gdp_growth - roczny wzrost PKB na podstawie waluty lokalnej [%]
% gdp_per_capita - PKB per capita [$]
% Density_n_P_Km2_ - gęstość zaludnienia [osoba/km^2]
% LandArea_Km2_ - powierzchnia całkowita [km^2]
% Latitude - szerokość geograficzna centroidu
% Longitude - długość geograficzna centroidu

% -------------------------------------------------------------------------
% Elektryczność z paliw kopalnych vs PKB per capita - wykres bąbelkowy na przestrzeni lat
figure;
% Initial plot
idx = data_table.Year == 2000;  % Find index of the selected year
scatter(data_table.gdp_per_capita(idx), data_table.ElectricityFromFossilFuels_TWh_(idx), 'o', 'filled', 'SizeData', data_table.Value_co2_emissions_kt_by_country(idx)/10000, 'MarkerEdgeColor', 'black');  % Plot data for selected year
xlim([0, max(data_table.gdp_per_capita)]);
ylim([0, max(data_table.ElectricityFromFossilFuels_TWh_)]);
xlabel('PKB per capita');
ylabel('elektryczność wytwarzana z paliw kopalnych [TWh]');
title('Elektryczność z paliw kopalnych vs PKB per capita w roku 2000', 'FontSize', 20);

% Create slider
slider = uicontrol('Style', 'slider', 'Min', min(data_table.Year), 'Max', max(data_table.Year),...
    'Value', min(data_table.Year), 'Position', [150, 10, 300, 20], 'Callback', {@update_plot_bubble1, data_table});
% -------------------------------------------------------------------------
% Rozkład elektryczności według źródła vs kraj (Top 20) na przestrzeni lat
figure;
% Initial plot
data_table.TotalEnergy_TWh_ = data_table.ElectricityFromFossilFuels_TWh_ + data_table.ElectricityFromNuclear_TWh_ + data_table.ElectricityFromRenewables_TWh_;
idx = data_table.Year == 2000 & ~isnan(data_table.TotalEnergy_TWh_);
% Sort data_table based on energy consumption
sorted_data = sortrows(data_table(idx,:), 'TotalEnergy_TWh_', 'descend');
% Select top 20 countries
top_countries = sorted_data(1:20, :);
% disp(top_countries)

barData = [top_countries.ElectricityFromFossilFuels_TWh_, top_countries.ElectricityFromNuclear_TWh_, top_countries.ElectricityFromRenewables_TWh_];
bar(barData, 'stacked');
set(gca, 'XTick', 1:20, 'XTickLabel', top_countries.Entity);
ylim([0, max(data_table.TotalEnergy_TWh_)]);
xlabel('Kraj');
ylabel('Elektryczność [TWh]');
title('Rozkład elektryczności według źródła vs kraj (Top 20) w roku 2000', 'FontSize', 20);
legend('paliwa kopalne', 'atom', 'źródła odnawialne', 'Location', 'northeast');

% Create dropdown menu for year selection
years = unique(data_table.Year);
dropdown = uicontrol('Style', 'popupmenu', 'String', cellstr(num2str(years)), 'Position', [40, 10, 50, 20], 'Callback', {@update_plot_bar1, data_table});

% Create arrow buttons for changing year
uicontrol('Style', 'pushbutton', 'String', '<', 'Position', [10, 10, 30, 20], 'Callback', {@decreaseYear, dropdown, data_table, @update_plot_bar1});
uicontrol('Style', 'pushbutton', 'String', '>', 'Position', [90, 10, 30, 20], 'Callback', {@increaseYear, dropdown, data_table, @update_plot_bar1});
% -------------------------------------------------------------------------
% Wsparcie finansowe dla państw rozwijających się na projekty czystej energii vs kraj (Top 20) na przestrzeni lat
figure;
% Initial plot
idx = data_table.Year == 2000 & ~isnan(data_table.FinancialFlowsToDevelopingCountries_US__);
% Sort data_table based on energy consumption
sorted_data = sortrows(data_table(idx,:), 'FinancialFlowsToDevelopingCountries_US__', 'descend');
% Select top 20 countries
top_countries = sorted_data(1:20, :);
disp(top_countries)

bar(top_countries.FinancialFlowsToDevelopingCountries_US__);
set(gca, 'XTick', 1:20, 'XTickLabel', top_countries.Entity);
ylim([0, max(data_table.FinancialFlowsToDevelopingCountries_US__)]);
xlabel('Kraj');
ylabel('Wparcie finansowe [$]');
title('Wsparcie finansowe dla państw rozwijających się na projekty czystej energii vs kraj (Top 20) w roku 2000', 'FontSize', 20);

% Create dropdown menu for year selection
years = unique(data_table.Year);
dropdown = uicontrol('Style', 'popupmenu', 'String', cellstr(num2str(years)), 'Position', [40, 10, 50, 20], 'Callback', {@update_plot_bar2, data_table});

% Create arrow buttons for changing year
uicontrol('Style', 'pushbutton', 'String', '<', 'Position', [10, 10, 30, 20], 'Callback', {@decreaseYear, dropdown, data_table, @update_plot_bar2});
uicontrol('Style', 'pushbutton', 'String', '>', 'Position', [90, 10, 30, 20], 'Callback', {@increaseYear, dropdown, data_table, @update_plot_bar2});
% -------------------------------------------------------------------------
% Emisja CO2 vs kraj (Top 20) na przestrzeni lat
figure;
% Initial plot
idx = data_table.Year == 2000 & ~isnan(data_table.Value_co2_emissions_kt_by_country);
% Sort data_table based on energy consumption
sorted_data = sortrows(data_table(idx,:), 'Value_co2_emissions_kt_by_country', 'descend');
% Select top 20 countries
top_countries = sorted_data(1:20, :);
disp(top_countries)

bar(top_countries.Value_co2_emissions_kt_by_country);
set(gca, 'XTick', 1:20, 'XTickLabel', top_countries.Entity);
ylim([0, max(data_table.Value_co2_emissions_kt_by_country)]);
xlabel('Kraj');
ylabel('Emisja CO2 [kT]');
title('Emisja CO2 vs kraj (Top 20) w roku 2000', 'FontSize', 20);

% Create dropdown menu for year selection
years = unique(data_table.Year);
dropdown = uicontrol('Style', 'popupmenu', 'String', cellstr(num2str(years)), 'Position', [40, 10, 50, 20], 'Callback', {@update_plot_bar3, data_table});

% Create arrow buttons for changing year
uicontrol('Style', 'pushbutton', 'String', '<', 'Position', [10, 10, 30, 20], 'Callback', {@decreaseYear, dropdown, data_table, @update_plot_bar3});
uicontrol('Style', 'pushbutton', 'String', '>', 'Position', [90, 10, 30, 20], 'Callback', {@increaseYear, dropdown, data_table, @update_plot_bar3});
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
% Callback function to update plot bubble 1
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
% Callback function to update plot bar 1
function update_plot_bar1(source, ~, data_table)
    year_idx = get(source, 'Value');  % Get index of selected year
    selected_year = unique(data_table.Year(year_idx));  % Get selected year
    idx = data_table.Year == selected_year & ~isnan(data_table.TotalEnergy_TWh_);
    % Sort data_table based on energy consumption
    sorted_data = sortrows(data_table(idx,:), 'TotalEnergy_TWh_', 'descend');
    % Select top 20 countries
    top_countries = sorted_data(1:20, :);
    % disp(top_countries)
    
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
% Callback function to update plot bar 2
function update_plot_bar2(source, ~, data_table)
    year_idx = get(source, 'Value');  % Get index of selected year
    selected_year = unique(data_table.Year(year_idx));  % Get selected year
    idx = data_table.Year == selected_year & ~isnan(data_table.FinancialFlowsToDevelopingCountries_US__);
    % Sort data_table based on energy consumption
    sorted_data = sortrows(data_table(idx,:), 'FinancialFlowsToDevelopingCountries_US__', 'descend');
    % Select top 20 countries
    top_countries = sorted_data(1:20, :);
    % disp(top_countries)
    
    bar(top_countries.FinancialFlowsToDevelopingCountries_US__);
    set(gca, 'XTick', 1:20, 'XTickLabel', top_countries.Entity);
    ylim([0, max(data_table.FinancialFlowsToDevelopingCountries_US__)]);
    xlabel('Kraj');
    ylabel('Wsparcie finansowe [$]');
    title('Wsparcie finansowe dla państw rozwijających się na projekty czystej energii vs kraj (Top 20) w roku ', num2str(selected_year), 'FontSize', 20);
end
% -------------------------------------------------------------------------
% Callback function to update plot bar 3
function update_plot_bar3(source, ~, data_table)
    year_idx = get(source, 'Value');  % Get index of selected year
    selected_year = unique(data_table.Year(year_idx));  % Get selected year
    idx = data_table.Year == selected_year & ~isnan(data_table.Value_co2_emissions_kt_by_country);
    % Sort data_table based on energy consumption
    sorted_data = sortrows(data_table(idx,:), 'Value_co2_emissions_kt_by_country', 'descend');
    % Select top 20 countries
    top_countries = sorted_data(1:20, :);
    % disp(top_countries)
    
    bar(top_countries.Value_co2_emissions_kt_by_country);
    set(gca, 'XTick', 1:20, 'XTickLabel', top_countries.Entity);
    ylim([0, max(data_table.Value_co2_emissions_kt_by_country)]);
    xlabel('Kraj');
    ylabel('Emisja CO2 [kT]');
    title('Emisja CO2 vs kraj (Top 20) w roku ', num2str(selected_year), 'FontSize', 20);
end
% -------------------------------------------------------------------------
% utility functions for arrows
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