function [eta] = calc_eta(X, m, q)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION (auxiliary)
% [eta] = calc_eta(X)
% eta_n = eta =
% \frac{\beta}{q\sqrt{m}, where
% \beta = \frac{1}{N} sum_{i=1}^{N}{||x_i - \bar{x}||}^2, 
% where \bar{x} is the mean i.e.
% \frac{1}{N} sum_{i=1}^{N} x_i
% 
% eta is replicated m times so it's ready to be used by the possibi
% function
%
% IPNUT ARGUEMENTS:
%  X:       lxN matrix, each column of which corresponds to a data vector.
%  m:       number of clusters.
%  q:       the "q" parameter of the algorithm. When this is not equal to 0
%           the original cost function is considered, while if it is 0 the
%           alternative one is considered.
%
% OUTPUT ARGUEMENTS:
% eta:      1xm matrix, with m copies of eta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x_hat = mean(X, 2);
beta = mean(sum((X - x_hat).^2, 1));
eta = beta / (q * sqrt(m));
eta = repmat(eta, 1, m);
end

