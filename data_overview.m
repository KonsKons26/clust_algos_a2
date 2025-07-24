%%%%%%%%%%%%%%%%%%%%
% Feeling the data %
%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%
% Data loading %
%%%%%%%%%%%%%%%%

load data_country;

%%%%%%%%%%%%%%%%%%%%%%
% General statistics %
%%%%%%%%%%%%%%%%%%%%%%

features = {
    "Child_mortality",...
    "Exports",...
    "Health",...
    "Imports",...
    "Income",...
    "Inflation",...
    "Life_expectancy",...
    "Total_fertility",...
    "GDPP"
};
num_features = size(Countrydata, 2)
num_countries = size(Countrydata, 1)
means = mean(Countrydata)
stdvs = std(Countrydata)
minima = min(Countrydata)
maxima = max(Countrydata)


%%%%%%%%%%%%%%%%
% Correlation  %
% coefficients %
%%%%%%%%%%%%%%%%

% Correlation coefficients on a matrix plot (pair plot) on unprocessed data
corrcoefs = corrcoef(Countrydata)
% fig
figure;
[~, axes] = plotmatrix(Countrydata);
for i = 1:num_features
    xlabel(axes(num_features, i), features{i});
    ylabel(axes(i, 1), features{i});
    for j = 1:num_features
        if i ~= j
            ax = axes(i, j);
            xpos = max(ax.XLim) * 0.75;
            ypos = max(ax.YLim) * 0.75;
            text(ax, xpos, ypos, sprintf('%.2f', corrcoefs(i, j)), ...
                'HorizontalAlignment', 'center', ...
                'FontSize', 10, 'FontWeight', 'bold', 'Color', 'red');
        end
    end
end
hold off;

% MinMax normalization
MinMaxed=zeros(size(Countrydata, 1), num_features);
for i=1:num_features
    column=Countrydata(:, i);
    MinMaxScale=((column-minima(i))/(maxima(i)-minima(i)));
    MinMaxed(:, i)=MinMaxScale;
end 
% Correlation coefficients of minmaxed data on a matrix plot
corrcoeffs = corrcoef(MinMaxed);
figure;
[~, axes] = plotmatrix(MinMaxed);
for i = 1:num_features
    xlabel(axes(num_features, i), features{i});
    ylabel(axes(i, 1), features{i});
    for j = 1:num_features
        if i ~= j
            ax = axes(i, j);
            xpos = max(ax.XLim) * 0.75;
            ypos = max(ax.YLim) * 0.75;
            text(ax, xpos, ypos, sprintf('%.2f', corrcoefs(i, j)), ...
                'HorizontalAlignment', 'center', ...
                'FontSize', 10, 'FontWeight', 'bold', 'Color', 'red');
        end
    end
end
hold off;

% Standardisation
Standardized = zeros(size(Countrydata, 1), num_features);
for i = 1:num_features
    column = Countrydata(:, i);
    Value = ((column-means(:, i)) / stdvs(:, i));
    Standardized(:, i) = Value;
end
% Correlation coefficients of standardized data on a matrix plot
corrcoefs = corrcoef(Standardized);
figure;
[~, axes] = plotmatrix(Standardized);
for i = 1:num_features
    xlabel(axes(num_features, i), features{i});
    ylabel(axes(i, 1), features{i});
    for j = 1:num_features
        if i ~= j
            ax = axes(i, j);
            xpos = max(ax.XLim) * 0.75;
            ypos = max(ax.YLim) * 0.75;
            text(ax, xpos, ypos, sprintf('%.2f', corrcoefs(i, j)), ...
                'HorizontalAlignment', 'center', ...
                'FontSize', 10, 'FontWeight', 'bold', 'Color', 'red');
        end
    end
end
hold off;


%%%%%%%%%%%%%%%%%
% PDF estimates %
%%%%%%%%%%%%%%%%%

% Kernel density estimation plots, with means and medians
figure;
for i = 1:num_features
    subplot(3, 3, i);
    [f, xi] = ksdensity(Standardized(:, i));
    plot(xi, f, '-k', 'Linewidth', 1.5);
    hold on;
    mea = mean(Standardized(:, i));
    xline(mea, '--b', 'Mean', 'Linewidth', 1, ...
        'HandleVisibility', 'off', ...
        'LabelHorizontalAlignment', 'right', ...
        'LabelVerticalAlignment', 'bottom');
    med = median(Standardized(:, i));
    xline(med, '--r', 'Median', 'Linewidth', 1, ...
        'HandleVisibility', 'off', ...
        'LabelHorizontalAlignment', 'left', ...
        'LabelVerticalAlignment', 'bottom');
    title(features{i})
    xlabel('Val');
    ylabel('Density')
    hold off;
end

% Comparing all pdfs on one plot
figure;
hold on;
grid on;
for i = 1:num_features
    [f, xi] = ksdensity(Standardized(:, i));
    plot(xi, f, 'LineWidth', 2); 
end
xlabel('Val');
ylabel('Density');
title('Kernel density estimations, superimposed')
hold off;
legend(features);


%%%%%%%%%%%%
% Boxplots %
%%%%%%%%%%%%

figure;
boxplot(Standardized);
xticks(1:numel(features));
xticklabels(features);
ylabel('Values');
xlabel('Features');
title('Boxplot')
hold off;
