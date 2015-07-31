function plot_width_vs_width(abundances, specification, fig)

% Verify information
assert(strcmp('width_vs_width', specification{1}))

% Get list of samples. Man this is awkward
sample_names = specification{2};
num_samples = numel(sample_names);
samples = zeros(num_samples,1);
descriptions = {};
for n = 1:num_samples
    sample_found = false;
    for m=1:numel(abundances)
        if strcmp(abundances(m).name,sample_names(n))
            samples(n,1) = m;
            sample_found = true;
        end
    end
    if ~sample_found
        disp(['Error: cannot find data for ' sample_names(n)]);
        assert(false);
    end
end
assert(num_samples == numel(samples))
assert(num_samples >= 2)

% Create plot names
experiments = {};
batches = {};
for n=1:num_samples
    experiments{n} = sample_names{n}(2:end);
    batches{n} = sample_names{n}(1);
end
experiments = unique(experiments);
batches = unique(batches);
plot_name = [horzcat(experiments{:}) '_' horzcat(batches{:})];
plot_title = [horzcat(experiments{:}) ' ' horzcat(batches{:})];

% Determine min_width and max_height
these_abundances = abundances(samples);
for n=1:numel(these_abundances)
    min_heights(n) = these_abundances(n).min_height;
    max_widths(n) = these_abundances(n).max_width;
end

% Make sure min_width and max_heights are the same across samples
assert(min(min_heights) == max(min_heights))
assert(min(max_widths) == max(max_widths))
min_height = min_heights(1);
max_width = max_widths(1);

% Get colors. Default to those in specification. If none there, use
% those in annotation. 
assert(numel(specification) == 3)
assert(numel(specification{3}) == num_samples-1)
for n=2:num_samples
    descriptions{n,1} = these_abundances(n).description;
    colors(n,:) = specification{3}{n-1};
end

% Create figure
figure(fig)
clf
set(gca, 'fontsize', 16, 'box', 'on', 'linewidth', 2)

% Get information on reference peaks
ref_widths = these_abundances(1).peak_fwhms/1000;
ref_heights = these_abundances(1).peak_heights;
ref_arss = these_abundances(1).peak_arss;
hs = [];
rhos = [];
legends = {};
for n=2:num_samples
    
    % Get information on mutant peaks
    mut_widths = these_abundances(n).peak_fwhms/1000;
    mut_heights = these_abundances(n).peak_heights;
    mut_arss = these_abundances(n).peak_arss;
    
    ref_is = [];
    mut_is = [];
    
    for k=1:numel(ref_arss)
        index = strmatch(ref_arss{k}, mut_arss, 'exact');
        if numel(index) == 1 && mut_heights(index)>=min_height && ref_heights(k)>=min_height
            ref_is(end+1) = k;
            mut_is(end+1) = index;
        end
    end
    if numel(ref_is) == 0 
        disp(['Error: nothing to plot in ' plot_name '. Moving on...'])
        return % Abort this plot
    end
    hs(n-1) = plot(ref_widths(ref_is), mut_widths(mut_is), 'o','MarkerEdgeColor', colors(n,:),'MarkerFaceColor', 'none', 'markersize', 12, 'linewidth', 2);
    hold on
    
    disp([plot_name ' width vs width sample ' num2str(n) ': ' num2str(numel(ref_is)) ' data points'])
    disp(['reference width:  ' num2str(mean(ref_widths(ref_is))) ' +- ' num2str(std(ref_widths(ref_is)))])
    disp(['mutant width:     ' num2str(mean(mut_widths(mut_is))) ' +- ' num2str(std(mut_widths(mut_is)))])
    disp('')
    
    legends{n-1} = descriptions{n};
    
    % If want to display correlations: Compute spearman rank correlation
    %rhos(n-1) = corr(ref_widths(ref_is)', mut_widths(mut_is)', 'type', 'spearman');
    %legends{n-1} = [descriptions{n},  ': ',  num2str(rhos(n-1), '%.2f')];
    
end
axis square

%xyl = [0 12]; 
%xyticks = [0 5 10];
%xytickslabel = {'0', '5', '10'};

xyl = [0 max_width]; 
if max_width >= 30
 xyticks = 0:10:max_width;
else
 xyticks = 0:5:max_width;
end

%xyticks = [0 25 50];
%xytickslabel = {'0', '25', '50'};

%if all(horzcat(experiments{:}) == '4')
%    xyl = [0 20];
%    xyticks = [0 5 10 15 20];
%    xytickslabel = {'0', '', '10', '', '20'};
%else
%    xyl = [0 30];
%    xyticks = [0 5 10 15 20 25 30];
%    xytickslabel = {'0', '', '10', '', '20', '', '30'};
%end

%set(gca, 'box', 'on', 'linewidth', 2, 'fontsize', 22, 'xlim', xyl, 'ylim', xyl, 'xtick', xyticks, 'ytick', xyticks, 'xticklabel', xytickslabel, 'yticklabel', xytickslabel)
set(gca, 'box', 'on', 'linewidth', 3, 'fontsize', 30, 'xlim', xyl, 'ylim', xyl, 'xtick', xyticks, 'ytick', xyticks)
xlabel([descriptions{1} 'reference peak width (kbp)'])
%if numel(descriptions) == 2
%ylabel([descriptions{2} ' peak width (kbp)'])
%else
ylabel('mutant peak width (kbp)','fontsize', 30)
legend(hs, legends, 'location', 'northoutside', 'fontsize', 12)
%end
line(xyl, xyl, 'color', 'k', 'linestyle', '--', 'linewidth', 3)
title({plot_title,''}, 'fontsize', 30)

% Save plot
plot_file_name = ['results/plots_width_vs_width/width_vs_width_' plot_name];
saveas(gcf,[plot_file_name '.eps'],'epsc');
%print('-dpng','-r300',plot_file_name)
