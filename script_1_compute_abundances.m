clear all
close all
disp('*** Running script_1_compute_abundances.m ***')

%% Set directories and files
addpath './functions'
addpath './specifications'
abundance_file_name = 'results/abundances.mat';
heights_file_name = 'data/heights_all.txt';
shred_file_name = 'data/heights_shred.txt';

%% Set analysis parameters

lb_shred_read_map = 60;
ub_shred_read_map = 62;

%% Read in chromosome information
f = fopen('./genome/chromosome_info.txt');
C = textscan(f, '%n %n %s %s', 'headerlines', 1);
unique_chr_ars_names = C{3};
unique_chr_cen_names = C{4};
unique_chr_mask_names = unique_chr_cen_names;
chr_nums = C{1};
chr_lengths = C{2};
num_chrs = numel(chr_nums);
chr_names = {};
for n=1:num_chrs
    assert(n == chr_nums(n));
    chr_names{n} = ['Chr.' num2str(n)];
end

%% Create mask based on shredded genome
f = fopen(shred_file_name);
C = textscan(f, '%n %n %n', 'headerlines', 1);
mask_chrs = C{1};
mask_poss = C{2};
heights = C{3};

% Call uncertain positions via oddeties in # reads mapped
uncertain_poss = (heights > ub_shred_read_map) | (heights < lb_shred_read_map);

%% Load heights

% Load informations in heights.txt
disp('Loading height file size...')
data = dlmread(heights_file_name, '\t', 1, 0);
num_cols = size(data,2);
num_poss = size(data,1);

% Load sample names
disp('Loading height file information...')
f = fopen(heights_file_name);
C = textscan(f,repmat('%s ',1,num_cols),1);
sample_names = {};
sample_cols = (1:(num_cols))';
for n=3:num_cols
    sample_names(n-2) = C{n}(1);
end
fclose(f);
num_experiments = numel(sample_names);  

% Partition data according to meaning
chroms = data(:,1);
poss = data(:,2);
heights = data(:,3:end);
num_reads = sum(heights);
read_length = poss(2)-poss(1);

%
% Run set_annotations -> variable 'annotations'
%

% Compute abundances
disp('Computing final scaled abundances...')
disp('Number of reads at unit height')

run('set_annotations.m') % sets the variable 'annotations'
num_experiments = size(annotations,1);

for n=1:num_experiments

    annotation = annotations(n,:);
    
    % Record name
    experiment_name = annotation{1};
    fprintf('Processing experiment: %s... ',experiment_name);
    abundance.name = experiment_name;
    
    % Get sample name
    parts = strsplit(experiment_name,'_');
    sample_name = parts{1};
    
    % Find index corresponding to sample
    sample_index=find(ismember(sample_names,sample_name));
    abundance.sample = sample_names{sample_index}; 
    
    % Get length to mask on ends
    bp_from_end_to_mask = annotation{5}*1000;
    abundance.bp_from_end_to_mask = bp_from_end_to_mask;
    
    % Create arrays to store mask
    masked_regions = [];
    
    % Mask rDNA region manually
    c = 12;
    start = floor(450000);
    stop = ceil(500000);
    masked_regions = [c, start, stop];
    
    % Mask ends of chromosomes if requested
    if bp_from_end_to_mask > 0
        for c=1:num_chrs
            chr_length = chr_lengths(c);
            masked_regions = cat(1,masked_regions,[c, 1, bp_from_end_to_mask]);
            masked_regions = cat(1,masked_regions,[c, chr_length-bp_from_end_to_mask+1, chr_length]);
        end
    end
    abundance.masked_regions = masked_regions;
    num_masked_regions = size(masked_regions,1);
    
    mask_by_chr = {};
    for c=1:num_chrs
        % Mask equals uncertain_poss on chromosome
        mask = uncertain_poss(mask_chrs == c); 
        length = numel(mask);
        
        % Mask each specified region on chromosome
        for r=1:num_masked_regions
            if masked_regions(r,1) == c
                start = 1 + floor(masked_regions(r,2)/read_length);
                stop = floor(masked_regions(r,3)/read_length);
                mask(start:stop) = 1;
            end
        end
    
        num_masked_poss = sum(mask);
        %disp(['chromosome ' num2str(c) ' ' num2str(100*num_masked_poss/length) '% positions masked'])
        mask_by_chr{c} = mask;
    end
    
    
    % Define window size (will be experiment dependent)
    bp_window_size = annotation{2}*1000;
    abundance.bp_window_size = bp_window_size;
    
    entry_window_size = floor(bp_window_size/read_length);

    % Compute smoothed heights for each sample on each chromosome
    %disp('Computing smoothed heights on each chromosome...')
    smoothed_heights_by_chrom = {};
    smoothed_masked_heights_by_chrom = {};
    for chrom = 1:num_chrs

        % Get indices that will be valid after smoothing
        raw_indices = find(chroms==chrom);
        ok_indices = entry_window_size:numel(raw_indices);

        % Get heights along chromosome
        raw_heights = heights(raw_indices,sample_index);
        raw_poss = poss(raw_indices);

        % Set smoothing window
        window = ones(1,entry_window_size)/entry_window_size;
        
        % Compute smoothed heights without mask
        smooth_heights_without_mask_raw = filter(window, 1, raw_heights);
        smooth_heights_without_mask = smooth_heights_without_mask_raw(ok_indices); 

        % Compute smoothed heights with mask
        smooth_heights_with_mask_raw = filter(window, 1, raw_heights.*(1-mask_by_chr{chrom}));
        smooth_heights_with_mask = smooth_heights_with_mask_raw(ok_indices);

        % Get valid positions (centered on each window)
        chrom_poss{chrom} = raw_poss(ok_indices)-bp_window_size/2;

        % Organize smoothed heights by chromosome
        smoothed_heights_by_chrom{chrom} = smooth_heights_without_mask(:); %/num_reads(n);
        smoothed_masked_heights_by_chrom{chrom} = smooth_heights_with_mask(:); %/num_reads(n);
    end
    
    
    abundance.means = [];
    abundance.poss = [];
    abundance.chrs = [];
    abundance.stds = [];
    abundance.masked_means = [];
    abundance.num_reads = 0;
    for chrom = 1:num_chrs
        
        chrom_len = max(chrom_poss{chrom});
        num_poss = numel(chrom_poss{chrom});
        abundance.stds(end+1:end+num_poss) = 0;
        abundance.means(end+1:end+num_poss) = smoothed_heights_by_chrom{chrom};
        abundance.masked_means(end+1:end+num_poss) = smoothed_masked_heights_by_chrom{chrom};
        abundance.poss(end+1:end+num_poss) = chrom_poss{chrom};
        abundance.chrs(end+1:end+num_poss) = chrom;
        
    end
    
    % Get max height in non-masked region, set equla to 99.5'th percentile
    max_height = quantile_jbk(abundance.masked_means, .995); %
    
    % Need this transformation for plotting. 
    abundance.means = abundance.means/max_height;
    abundance.masked_means = abundance.masked_means/max_height; 
    abundance.unit_height = max_height;
    %disp([num2str(round(max_height*entry_window_size))]);

    
    % Dont' include positions that lie outside interval [0,1]
    ok_indices = abundance.means <= Inf; % <= 1;
    abundance.stds = abundance.stds(ok_indices);
    abundance.means = abundance.means(ok_indices);
    abundance.masked_means = abundance.masked_means(ok_indices);
    abundance.poss = abundance.poss(ok_indices);
    abundance.chrs = abundance.chrs(ok_indices);
    abundance.num_reads = num_reads(sample_index);
    
    % Print nubmer of reads
    fprintf('%d total reads.\n', abundance.num_reads);
    
    % Ignore positions in which masked_means is less than 80% of means
    abundance.ignore = abundance.masked_means < 0.8*abundance.means; 
    
    % Add abundance struct to abundances array
    abundances(n) = abundance;
end

% Get peaks
disp('Computing peak widths...')
abundances_with_peaks = get_peak_widths(abundances, sample_names);

% Save abundances with peak information
disp(['Saving results in ' abundance_file_name])
save(abundance_file_name, 'abundances_with_peaks')

% Save peak data information
disp('Saving peak data information')

% Read in ARSs
f = fopen('./genome/oriDB_confirmed_ARSs.bed');
A = textscan(f,'%s %n %n %s', 'headerlines', 2);
ars_names = A{4}';
num_arss = numel(ars_names);
fclose(f);

% Load abundances
num_samples = numel(abundances_with_peaks);
sample_names = {};

% Fill matrix with peak widths
peak_widths_mat = nan(num_samples,num_arss);
peak_heights_mat = nan(num_samples,num_arss);
for sample_index = 1:num_samples

    % Get sample information
    a = abundances_with_peaks(sample_index);
    fprintf('%s:%d ARSs\n',a.name, numel(a.peak_arss))
    sample_names{sample_index} = a.name;

    % For each ars found in sample
    num_arss = numel(a.peak_arss);
    for n=1:num_arss
        
        % Find corresponding ars index
        ars_name = a.peak_arss{n};
        ars_index = strmatch(ars_name, ars_names);
        
        % Fill correpsonding cell in peak_widths_mat
        peak_widths_mat(sample_index,ars_index) = a.peak_fwhms(n);
        peak_heights_mat(sample_index,ars_index) = a.peak_heights(n);
    end

end

% Open file for writing
peak_widths_file_name = './results/result_peak_widths.txt';
peak_heights_file_name = './results/result_peak_heights.txt';
f = fopen(peak_widths_file_name,'w');
g = fopen(peak_heights_file_name,'w');

header_line = sprintf('%10s','ARS_name');
for m=1:num_samples
    header_line = [header_line sprintf('%10s',sample_names{m})];
end
fprintf(f,[header_line,'\n']);
fprintf(g,[header_line,'\n']);

for n=1:num_arss
    widths_line = sprintf('%10s',ars_names{n});
    heights_line = sprintf('%10s',ars_names{n});
    for m=1:num_samples
        widths_line = [widths_line sprintf('%10d',peak_widths_mat(m,n))];
        heights_line = [heights_line sprintf('%10.3f',peak_heights_mat(m,n))];
    end
    fprintf(f,[widths_line,'\n']);
    fprintf(g,[heights_line,'\n']);
end

disp(['Done writing ' peak_widths_file_name  ' and ' peak_heights_file_name '!'])


disp('*** Done! ***')
