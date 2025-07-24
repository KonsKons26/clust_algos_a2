%%%%%%%%%%%%%%%%%%%%%%
%  Final clustering  %
% and visualizations %
%%%%%%%%%%%%%%%%%%%%%%
% Required functions:
% k_medians.m


%%%%%%%%%%%%%%%%%%%%
% Data loading and %
% setting the seed %
%%%%%%%%%%%%%%%%%%%%

load exploratory;

seed = 10;
rand('seed', seed);
randn('seed', seed);


%%%%%%%%%%%%%%
% Clustering %
%%%%%%%%%%%%%%

lower_limit = prctile(Countrydata, 25)';
upper_limit = prctile(Countrydata, 75)';

m = 3;

initial_thetas = lower_limit + (upper_limit - lower_limit) ...
    .* rand(num_features, m);

[thetas, bel, J] = k_medians(Countrydata', initial_thetas);


%%&&&&&
% PCA %
%%%%%%%

[coeff, score] = pca(Countrydata);
pc1 = score(:, 1);
pc2 = score(:, 2);

figure;
hold on;
color1 = [0, 114, 189] / 255;  % #0072BD in RGB
color2 = [217, 83, 25] / 255;  % #D95319 in RGB
color3 = [237, 177, 32] / 255; % #EDB120 in RGB

h = gscatter(pc1, pc2, bel, [color1; color2; color3], 'o');
for i = 1:length(h)
    h(i).LineWidth = 2;
end
xlabel('Principal Component 1');
ylabel('Principal Component 2');
title('PCA Projection Colored by Cluster');
legend('Cluster 1', 'Cluster 2', 'Cluster 3');
hold off;


%%%%%%%%%
% t-SNE %
%%%%%%%%%

Y = tsne(Countrydata);
figure;
hold on;
h = gscatter(Y(:, 1), Y(:, 2), bel, [color1; color2; color3], 'o');
for i = 1:length(h)
    h(i).LineWidth = 2;
end
xlabel('t-SNE Dimension 1');
ylabel('t-SNE Dimension 2');
title('t-SNE Visualization');
legend('Cluster 1', 'Cluster 2', 'Cluster 3');
hold off;


%%%%%%%
% MDS %
%%%%%%%

Y = mdscale(pdist(Countrydata), 2);
figure;
hold on;
h = gscatter(Y(:, 1), Y(:, 2), bel, [color1; color2; color3], 'o');
for i = 1:length(h)
    h(i).LineWidth = 2;
end
xlabel('MDS Dimension 1');
ylabel('MDS Dimension 2');
title('MDS visualization');
legend('Cluster 1', 'Cluster 2', 'Cluster 3');
hold off;


%%%%%%%%%%%%%%%%%
%  Visualizing  %
% the  clusters %
%%%%%%%%%%%%%%%%%

cluster1 = country(bel == 1);
cluster2 = country(bel == 2);
cluster3 = country(bel == 3);

maxLength = max([length(cluster1), length(cluster2), length(cluster3)]);

cluster1 = [cluster1; repmat({''}, maxLength - length(cluster1), 1)];
cluster2 = [cluster2; repmat({''}, maxLength - length(cluster2), 1)];
cluster3 = [cluster3; repmat({''}, maxLength - length(cluster3), 1)];

clusterTable = table(cluster1, cluster2, cluster3, 'VariableNames', ...
    {'Cluster1', 'Cluster2', 'Cluster3'});

disp(clusterTable);


%%%%%%%%
% Save %
%%%%%%%%

writetable(clusterTable, 'clusters.csv');
save("clusters.mat");
