%%%%%%%%%%%%%%%%%%%%%%%%%
% Exploratory  analyses %
%   for homework 2 in   %
% Clustering Algorithms %
%%%%%%%%%%%%%%%%%%%%%%%%%
% Required functions:
% k_means.m
% k_medians.m
% k_medoids.m
% possibi.m
% distan.m
% calc_eta.m
% cost_comput.m
% possibi_cost.m
% rand_init.m
% rand_data_init.m
% distant_init.m


%%%%%%%%%%%%%%%%%%%%%%
% Data  loading  and %
% global  parameters %
%%%%%%%%%%%%%%%%%%%%%%

load data_country

% Since all tests will be repeated 10 times, 10 different seeds are
% predefined here to help with reproducibility
seeds = [42, 24, 12, 21, 90, 9, 50, 1, 100, 10];

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
num_features = size(Countrydata, 2);
num_countries = size(Countrydata, 1);
means = mean(Countrydata);
stdvs = std(Countrydata);


%%%%%%%%%%%%%%%%%%%
% Standardization %
%%%%%%%%%%%%%%%%%%%

% From this point on, the data will be standardized
Standardized = zeros(size(Countrydata, 1), num_features);
for i = 1:num_features
    column = Countrydata(:, i);
    Value = ((column - means(:, i)) / stdvs(:, i));
    Standardized(:, i) = Value;
end

Countrydata = Standardized;


%%%%%%%%%%%
% k-means %
%%%%%%%%%%%

% Set a range in the middle 50th percentile for picking random initial
% thetas
lower_limit = prctile(Countrydata, 25)';
upper_limit = prctile(Countrydata, 75)';

% Set a range for testing different number of clusters (m)
smallest_m = 2;
largest_m = 30;

% Repeat the process 10 times
num_repeats = 10;

% Array to store the mean cost for each m
k_means_mean_J_values = zeros(1, largest_m - smallest_m + 1);

% Loop over all ms
for m = smallest_m:largest_m
    J_values_for_m = zeros(1, num_repeats);
    for repeat = 1:num_repeats
        rand('seed', seeds(repeat));
        randn('seed', seeds(repeat));
        % Generate the random initial thetas that lie in the middle 50th
        % percentile of values
        initial_thetas = lower_limit + (upper_limit - lower_limit)...
                         .* rand(num_features, m);
        % Clustering and storing the J value
        [theta, bel, J] = k_means(Countrydata', initial_thetas);
        J_values_for_m(repeat) = J;
    end
    k_means_mean_J_values(m - smallest_m + 1) = mean(J_values_for_m);
end

% Plot the cost (J) vs the number of clusters (m)
k_means_m_values = smallest_m:largest_m;
figure;
plot(k_means_m_values, k_means_mean_J_values, '-o', 'LineWidth', 2, ...
    'MarkerSize', 6);
xlabel('Number of Clusters (m)');
ylabel('Cost Function (J)');
title('k-means Clustering: m vs J (averaged over 10 runs)');
grid on;


%%%%%%%%%%%%%
% k-medians %
%%%%%%%%%%%%%

% Similar procedure as with k-means
lower_limit = prctile(Countrydata, 25)';
upper_limit = prctile(Countrydata, 75)';
smallest_m = 2;
largest_m = 30;
num_repeats = 10;
k_medians_mean_J_values = zeros(1, largest_m - smallest_m + 1);
for m = smallest_m:largest_m
    J_values_for_m = zeros(1, num_repeats);
    for repeat = 1:num_repeats
        rand('seed', seeds(repeat));
        randn('seed', seeds(repeat));
        initial_thetas = lower_limit + (upper_limit - lower_limit)...
                         .* rand(num_features, m);
        [theta, bel, J] = k_medians(Countrydata', initial_thetas);
        J_values_for_m(repeat) = J;
    end
    k_medians_mean_J_values(m - smallest_m + 1) = mean(J_values_for_m);
end
k_medians_m_values = smallest_m:largest_m;
figure;
plot(k_medians_m_values, k_medians_mean_J_values, '-o', 'LineWidth', 2, ...
    'MarkerSize', 6);
xlabel('Number of Clusters (m)');
ylabel('Cost Function (J)');
title('k-medians Clustering: m vs J (averaged over 10 runs)');
grid on;


%%%%%%%%%%%%%
% k-medoids %
%%%%%%%%%%%%%

% Similar procedure as with k-means and k-medians
smallest_m = 2;
largest_m = 30;
num_repeats = 10;
k_medoids_mean_J_values = zeros(1, largest_m - smallest_m + 1);
for m = smallest_m:largest_m
    J_values_for_m = zeros(1, num_repeats);
    for repeat = 1:num_repeats
        [bel, J, w, a] = k_medoids(Countrydata', m, seeds(repeat));
        J_values_for_m(repeat) = J;
    end
    k_medoids_mean_J_values(m - smallest_m + 1) = mean(J_values_for_m);
end
k_medoids_m_values = smallest_m:largest_m;
figure;
plot(k_medoids_m_values, k_medoids_mean_J_values, '-o', 'LineWidth', 2, ...
    'MarkerSize', 6);
xlabel('Number of Clusters (m)');
ylabel('Cost Function (J)');
title('k-medoids Clustering: m vs J (averaged over 10 runs)');
grid on;


%%%%%%%%%%%%%%%
% Final Plots %
%%%%%%%%%%%%%%%

% Plotting all Js vs ms from all clustering algorithms
figure;
plot(k_means_m_values, k_means_mean_J_values, ...
    '-', 'LineWidth', 2, 'Color', ...
    '#0072BD', 'DisplayName', 'k-means');
hold on;
plot(k_medians_m_values, k_medians_mean_J_values, ...
    '-', 'LineWidth', 2, 'Color', ...
    '#D95319', 'DisplayName', 'k-medians');
hold on;
plot(k_medoids_m_values, k_medoids_mean_J_values, ...
    '-', 'LineWidth', 2, 'Color', ...
    '#77AC30', 'DisplayName', 'k-medoids');
xlabel('Number of Clusters (m)');
ylabel('Cost Function (J)');
title('Different clustering algorithms: m vs J (averaged over 10 runs)');
xline(3, '-', {'Apparent', 'elbow'}, 'Linewidth', 2, ...
    'HandleVisibility', 'off');
grid on;
legend();


%%%%%%%%%%%%%%%%%
% possibilistic %
%%%%%%%%%%%%%%%%%

% After finding the best number of clusters (3) based on k-means,
% k-medians, and k-medoids next we explore how the possibilistic scheme
% reacts with different qs
% The procedure is similar as with the other algorithms
init_proc = 3;
smallest_q = 1;
largest_q = 30;
m = 3;
num_repeats = 10;
possibi_mean_J_values = zeros(1, largest_q - smallest_q + 1);
for q = smallest_q:largest_q
    J_values_for_q = zeros(1, num_repeats);
    for repeat = 1:num_repeats
        % Calculating the eta parameter with the custom function eta_calc
        eta = calc_eta(Countrydata, m, q);
        % Possibilistic clustering
        [U, theta] = possibi(Countrydata', m, eta, q, seeds(repeat), ...
            init_proc);
        % Calculating the cost with the custom function possibi_cost
        J_values_for_q(repeat) = possibi_cost(Countrydata', U, theta, ... 
            q, eta);
    end
    possibi_mean_J_values(q - smallest_q + 1) = mean(J_values_for_q);
end
possibi_q_values = smallest_q:largest_q;
figure;
plot(possibi_q_values, possibi_mean_J_values, '-o', 'LineWidth', 2, ...
    'MarkerSize', 6);
xlabel('q value');
ylabel('Cost Function (J)');
title('possibilistic Clustering: q vs J (averaged over 10 runs)');
grid on;


% Save all variables
save("exploratory.mat");