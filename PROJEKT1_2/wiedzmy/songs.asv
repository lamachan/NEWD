% Load the CSV file
data = readtable('csvki/WDB_Case.csv');

% Extract the SingingText data
singingText = data.SingingText;

% Filter out NaN values
validIndices = ~isnan(singingText);
singingText = singingText(validIndices);

% Display the non-NaN values
fprintf('Non-NaN values from the SingingText column:\n');
for i = 1:length(singingText)
    fprintf('%d. %s\n', i, singingText{i});
end
