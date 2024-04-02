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
% columns_to_drop = {};
% data_table = removevars(data_table, columns_to_drop);

% usunięcie brakujących wartości z 'COUNTRY' i 'AM'
% data_table = data_table(~ismissing(data_table.COUNTRY), :);
% data_table = data_table(~ismissing(data_table.AM), :);

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
% EnergyIntensityLevelOfPrimaryEnergy_MJ__2017PPPGDP_ - zużycie energii na jednostkę GDP w partytecie siły nabywczej [MJ/$2011 PPP GDP]
% Value_co2_emissions_kt_by_country - emisja dwutlenku węgla na osobę [tona metryczna per capita]
% Renewables__EquivalentPrimaryEnergy_ - ???
% gdp_growth - roczny wzrost GDP na podstawie waluty lokalnej [%]
% gdp_per_capita - GDP per capita [$]
% Density_n_P_Km2_ - gęstość zaludnienia [osoba/km^2]
% LandArea_Km2_ - powierzchnia całkowita [km^2]
% Latitude - szerokość geograficzna centroidu
% Longitude - długość geograficzna centroidu

