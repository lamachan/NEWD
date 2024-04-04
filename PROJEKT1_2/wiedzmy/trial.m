% Step 1: Load the CSV file
data = readtable('csvki/WDB_Trial.csv');

% Step 2: Extract the "Verdict" and "Sentence" columns
verdictData = data.Verdict;
sentenceData = data.Sentence;

% Step 3: Count the occurrences of each unique value
verdictCounts = countcats(categorical(verdictData));
sentenceCounts = countcats(categorical(sentenceData));

% Step 4: Create pie charts
figure;

% Plot for Verdict
subplot(1, 2, 1);
verdictLabels = categories(categorical(verdictData));
verdictPie = pie(verdictCounts, verdictLabels);
title('Verdict');

% Plot for Sentence
subplot(1, 2, 2);
sentenceLabels = categories(categorical(sentenceData));
sentencePie = pie(sentenceCounts, sentenceLabels);
title('Sentence');

% Step 5: Add legend with percentages and use distinguishable colors
for i = 1:numel(verdictLabels)
    verdictPieText{i} = sprintf('%s: %.1f%%', verdictLabels{i}, (verdictCounts(i) / sum(verdictCounts)) * 100);
end

for i = 1:numel(sentenceLabels)
    sentencePieText{i} = sprintf('%s: %.1f%%', sentenceLabels{i}, (sentenceCounts(i) / sum(sentenceCounts)) * 100);
end

% Add legend to the Verdict pie chart
verdictPieText = flip(verdictPieText);
legend(verdictPie(1:2:end), verdictPieText, 'Location', 'eastoutside');

% Add legend to the Sentence pie chart
legend(sentencePie(1:2:end), sentencePieText, 'Location', 'eastoutside');

% Use distinguishable colors for both pie charts
colormap(jet);
