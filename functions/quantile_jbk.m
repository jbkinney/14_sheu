% quantile_jbk.m: Custom quantile function to get around the need for the
% Matlab statistic toolbox
function x = quantile_jbk(xs, p)
    assert(p <= 1)
    assert(p > 0);
    sorted_xs = sort(xs);
    N = numel(xs);
    index = ceil(N*p);
    x = sorted_xs(index);
end