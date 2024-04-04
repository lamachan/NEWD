% Load the CSV file
data = readtable('csvki/WDB_Case.csv');

% Extract the data for each column
dancingData = categorical(data.Dancing);
singingData = categorical(data.Singing);
foodAndDrinkData = categorical(data.FoodAndDrink);
witchesMeetingData = categorical(data.WitchesMeeting);

% Create pie charts for each column
createPieChart(dancingData, 'Dancing');
createPieChart(singingData, 'Singing');
createPieChart(foodAndDrinkData, 'FoodAndDrink');
createPieChart(witchesMeetingData, 'Witchesmeeting');

function createPieChart(data, columnName)
    % Count the occurrences of each unique value
    uniqueValues = categories(data);
    counts = countcats(data);

    % Calculate percentages
    totalValues = sum(counts);
    percentages = (counts / totalValues) * 100;

    % Plot a pie chart
    figure;
    pie(counts, uniqueValues);
    title(['Distribution of ' columnName]);

    % Add percentages to each slice
    labels = cellstr(num2str(percentages, '%.2f%%'));
    legend(uniqueValues, 'Location', 'bestoutside');
    textObjs = findobj(gca, 'Type', 'text');
    for i = 1:numel(textObjs)
        textObjs(i).String = strcat(uniqueValues{i}, {' '}, labels{i});
    end
end
