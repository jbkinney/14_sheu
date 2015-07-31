function plot_genome_chr4(abundances, specification, fig)
chrom_num = 4;
% Reset figure
figure(fig)
clf

% Read in chromosome information
f = fopen('./genome/chromosome_info.txt');
C = textscan(f, '%n %n %s %s', 'headerlines', 1);
unique_chr_ars_names = C{3};
unique_chr_cen_names = C{4};
chr_nums = C{1};
chr_lengths = C{2};
num_chrs = numel(chr_nums);
chr_names = {};
for n=1:num_chrs
    assert(n == chr_nums(n));
    chr_names{n} = ['Chr.' num2str(n)];
end

% Define colors
ars_color = [.5 .5 .5];
cen_color = [1 .5 0];

% Read in ARSs
f = fopen('./genome/oriDB_confirmed_ARSs.bed');
A = textscan(f,'%s %d %d %s', 'headerlines', 2);
ars_starts = A{2};
ars_stops = A{3};
ars_names = A{4};
ars_chr_names = A{1};

% Read in centromere information
g = fopen('./genome/CEN.bed');
B = textscan(g,'%s %d %d %s', 'headerlines', 1);
cen_starts = B{2};
cen_stops = B{3};
cen_names = B{4};
cen_chr_names = B{1};
cen_indices = (1:num_chrs)';

% Get list of samples. Man this is awkward
sample_names = specification{2};
num_samples = numel(sample_names);
samples = zeros(num_samples,1);
plot_name = '';
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
assert(num_samples >= 1)

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

% Default to colors in abundances
these_abundances = abundances(samples);

% If colors are in specification, use those
if numel(specification) == 3
    assert(numel(specification{3}) == num_samples)
    for n=1:num_samples
        descriptions{n,1} = these_abundances(n).description;
        colors(n,:) = specification{3}{n};
    end
end

% Provide feedback
plot_file_name = ['results/plots_genome_chr4/genome_' plot_name];
disp(['Making plot ' plot_file_name '...'])

% Pick a random abundance instance; they all have the same coordinates
abundance = these_abundances(1);

xl = [0 max(abundance.poss)];
yl = [0 16];
x_offsets = zeros(16,1);

spacing = 1E5;
x_offsets(2) = chr_lengths(1) + spacing;
x_offsets(3) = chr_lengths(2) + chr_lengths(1) + 2*spacing;
x_offsets(6) = chr_lengths(5) + spacing;
x_offsets(9) = chr_lengths(8) + spacing;
x_offsets(11) = chr_lengths(10) + spacing;
x_offsets(17) = chr_lengths(16) + 3*spacing;
y_offsets = -1.5*[1 1 1 2 3 3 4 5 5 6 6 7 8 9 10 11 11];
x_offsets = x_offsets+spacing;

% Plot extent of each ARS
for c=chrom_num
    y_offset = y_offsets(c);
    x_offset = x_offsets(c);
    xticks = x_offset + (0:1E5:chr_lengths(c));
    yticks = y_offset*ones(size(xticks))+1;
    x_extent = x_offset + [0, chr_lengths(c)];
    y_extent = y_offset*[1 1]+1;
    
    % Plot grid lines
    hold on
    %for k=1:numel(xticks)
    %    plot(xticks(k)*[1 1], yticks(k)+[0 1], '-', 'color', [.7 .7 .7])
    %end
    %plot(x_extent, y_extent, '-k')
    %plot(x_extent, y_extent+.25, ':k')
    %plot(x_extent, y_extent+.50, ':k')
    %plot(x_extent, y_extent+.75, ':k')
    %plot(x_extent, y_extent+1, '-k')
    %line(min(x_extent)*[1 1], y_offset+[1 2], 'color', 'k');
    %line(max(x_extent)*[1 1], y_offset+[1 2], 'color', 'k');

    % Plot ARS locations
    chr_name = sprintf('chr%d', c);
    cen_chr_name = chr_names{c};
    ars_indices = strmatch(chr_name, ars_chr_names, 'exact');
    cen_indices = strmatch(cen_chr_name, cen_chr_names, 'exact');
    %disp(cen_chr_name)
    
    for i=ars_indices'
        % Draw box at each ARS
        start = ars_starts(i);
        stop = ars_stops(i);
        pos = mean([start stop]);
        %line(x_offset + pos*[1 1], y_offset+[1 2], 'color', ars_color, 'linewidth', 1)
        line(x_offset + pos*[1 1], y_offset+[.8 .9], 'color', ars_color, 'linewidth', 2)
        
        % Dislpay ARS name
        %text('position', [x_offset + (start+stop)/2, y_offset+2], 'string', ars_names{i}, 'fontsize', 10, 'horizontalalignment', 'center');
        % Why aren't these fuckers aligning properly!!!???
    end
    
    for i=cen_indices'
        % Draw box at each ARS
        start = cen_starts(i);
        stop = cen_stops(i);
        pos = mean([start stop]);
        line(x_offset + pos*[1 1], y_offset+[.7 .95], 'color', cen_color, 'linewidth', 2)
    end 
    
    % Mark masked regions
    masked_regions = abundance.masked_regions;
    num_masked_regions = size(masked_regions,1);
    for i=1:num_masked_regions
        chrom = masked_regions(i,1);
        start = masked_regions(i,2);
        stop = masked_regions(i,3);
        if chrom == c
            line(x_extent(1)+[start,stop], y_offset*[1,1] + 1, 'color', 'c', 'linewidth', 2)
        end
    end
    
     % Add annotation
    if c ~= 17
        %text(x_offset-spacing/3, y_offset+1.5, [num2str(c)], 'fontsize', 14, 'horizontalalignment', 'center')
        text(x_offset-spacing/3, y_offset+1.0, [num2str(c)], 'fontsize', 16, 'horizontalalignment', 'center')
    else
        text(x_offset-spacing/3, y_offset+1.5, 'MT', 'fontsize', 16, 'horizontalalignment', 'center')
    end
    
end

handles = [];
for a = 1:num_samples
    abundance = these_abundances(a);
    for c = chrom_num
        y_offset = y_offsets(c);
        x_offset = x_offsets(c);

        indices = (abundance.chrs == c); 
        means = abundance.means(indices);
        means(means > 1) = 1;
        poss = abundance.poss(indices);
        plot_indices = (abundance.ignore(indices) == 0);
        
        % Plot abundance ratios
        line_width = 2;
        h = plot(poss(plot_indices)+x_offset, means(plot_indices)*.9+y_offset+1, '.', 'color', colors(a,:), 'markersize', 2, 'linewidth', line_width);
        
        % Plote extent of peak widths
        if false
        for k=1:numel(abundance.peak_starts)
            if abundance.peak_chrs(k) == c
                plot(x_offset+[abundance.peak_starts(k),abundance.peak_stops(k)], y_offset + 1 + .5*abundance.peak_heights(k)*[1 1], ...
                    '-', 'color', colors(a,:), 'markersize', 2, 'linewidth', line_width);
                plot(x_offset+abundance.peak_centers(k)*[1 1], y_offset+1+[0, abundance.peak_heights(k)], ...
                    '-', 'color', colors(a,:), 'markersize', 2, 'linewidth', line_width);
            end
        end
        end
    end
    handels(a) = h;
    set(gca, 'ylim', 1.5*[-11 1])
    set(gca, 'xtick', [], 'ytick', [], 'box', 'on')
    drawnow;
end
legend(handels, descriptions, 4, 'fontsize', 16)
title(plot_title, 'fontsize', 30)

% Save plot.
%saveas(gcf,[plot_file_name '.eps'],'epsc');
print('-dpng','-r300',plot_file_name)