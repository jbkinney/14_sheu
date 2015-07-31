clear all
close all

%%  Set analysis parameters
run_test_analysis = true; % true -> test analysis, false -> full analysis

%% Set directories and files
addpath './functions'
addpath './specifications'

%% Run analysis
disp('*** Running script_run_analysis.m ***')
if run_test_analysis
    % This is to test functions
    run set_plot_specifications_test
    all_specifications = [plot_specifications_test];
else
    % Get all plot specificaitons
    run set_plot_specifications_width_vs_height 
    run set_plot_specifications_width_vs_width
    run set_plot_specifications_width_boxplot
    run set_plot_specifications_genome

    all_specifications = [
        plot_specifications_width_vs_height;
        plot_specifications_width_vs_width;
        plot_specificaitons_width_boxplot;
        plot_specifications_genome
    ];
end

% Load abundances
load results/abundances.mat;
old_abundances = abundances_with_peaks;
clear abundances_with_peaks

% Load annotations
run set_annotations

% Get names of samples in abundance structures
abundances_names = {old_abundances.name};
end_masks = [old_abundances.bp_from_end_to_mask];

% Assign abundance values (with peaks) to annotations
fprintf('name, window_size, num_reads, num_peaks_before_filter, num_peaks_after_filter, mean_width_after_filter, std_width_after_filter\n')
for m=1:size(annotations,1)

    sample_name = annotations{m,1};
    window_size = 1000*annotations{m,2};
    min_height = annotations{m,3};
    max_width = annotations{m,4};
    bp_from_end_to_mask = annotations{m,5}*1000;
    
    % Find proper abundance info
    n = find(strcmp(sample_name, abundances_names) & ...
    (bp_from_end_to_mask == end_masks));
    a = old_abundances(n);
    
    a.description = annotations{m,6};
    a.window_size = window_size;
    a.min_height = min_height;
    a.max_width = max_width;
    
    % new abundances sturct arraywill contain all abundances_with_peaks 
    % info, as well as annotations
    abundances(n) = a;  
    
    % display abundance information
    widths = a.peak_fwhms;
    
     % Only record peaks with sufficiently large peak height
    heights = a.peak_heights;
    indices = heights >= min_height;
    
    % sample name \t mean width (kb) \t rmsd width (kb) \t num peaks
    
    % Print results
    % (a) name
    % (b) number of mapped reads
    % (c) number of peaks before filtering
    % (d) number of peaks after filtering
    % (e) mean peak width in kb after filtering
    % (f) std peak width in kb after filtering
    % (g) strain name
    name = a.name;
    num_reads = a.num_reads;
    num_peaks_before_filter = numel(widths);
    num_peaks_after_filter = numel(widths(indices));
    mean_width_after_filter = mean(widths(indices))/1000;
    std_width_after_filter = std(widths(indices))/1000;
    strain_name = a.description;
    
    if true
        fprintf('%s,\t%i,\t%i,\t%i,\t%i,\t%2.1f,\t%2.1f\t%s\n', ...
            name, num_reads, window_size, ...
            num_peaks_before_filter, num_peaks_after_filter, ...
            mean_width_after_filter, std_width_after_filter, ...
            strain_name);
    end
end

% Make all width_vs_height plots
if true
    fig_width_vs_height = figure('position', [1000, 381, 500, 800], 'paperpositionmode', 'auto');
    for n=1:numel(all_specifications)
        specification = all_specifications{n};
        if strcmp(specification{1},'width_vs_height')
            plot_width_vs_height(abundances, specification, fig_width_vs_height);
        end
    end
    close(fig_width_vs_height)
end

% Make all width_vs_width plots
if true
    fig_width_vs_width = figure('position', [1538, 381, 500, 800], 'paperpositionmode', 'auto');
    for n=1:numel(all_specifications)
        specification = all_specifications{n};
        if strcmp(specification{1},'width_vs_width')
            plot_width_vs_width(abundances, specification, fig_width_vs_width);
        end
    end
    close(fig_width_vs_width)
end

% Make all width_boxplot plots
if true
    for n=1:numel(all_specifications)
        specification = all_specifications{n};
        if strcmp(specification{1},'width_boxplot')
            num_samples = numel(specification{2});
            specification{2} = fliplr(specification{2});
            height = 50 + 18*num_samples;
            fig_boxplot = figure('position', [1000  381  500   height],'paperpositionmode','auto');
            plot_width_boxplot(abundances, specification, fig_boxplot);
            close(fig_boxplot)
        end
    end
end

% Plot profiles for chromosome 4
if true
    fig_genome = figure('position',[1, 1, 1432, 1161], 'paperpositionmode', 'auto');
    for n=1:numel(all_specifications)
        specification = all_specifications{n};
        if strcmp(specification{1},'genome')
            plot_genome_chr4(abundances, specification, fig_genome);
        end
    end
    close(fig_genome)
end

% Plot whole genome profiles
if true
    fig_genome = figure('position',[1, 1, 1432, 1161], 'paperpositionmode', 'auto');
    for n=1:numel(all_specifications)
        specification = all_specifications{n};
        if strcmp(specification{1},'genome')
            plot_genome(abundances, specification, fig_genome);
        end
    end
    close(fig_genome)
end

disp('*** Done! ***')