function abundances_with_peaks = get_peak_widths(abundances, sample_names)

num_samples = numel(abundances);

% Read in ARSs
f = fopen('./genome/oriDB_confirmed_ARSs.bed');
A = textscan(f,'%s %n %n %s', 'headerlines', 2);
ars_starts = A{2};
ars_stops = A{3};
ars_centers = .5*(ars_starts + ars_stops);
ars_names = A{4};
ars_chr_names = A{1};
num_arss = numel(ars_starts);
ars_chr_nums = zeros(num_arss,1);
for c = 1:16
    chr_name = sprintf('chr%d', c);
    ars_indices = strmatch(chr_name, ars_chr_names, 'exact');
    ars_chr_nums(ars_indices) = c;
end

% Read in CENs
g = fopen('./genome/CEN.bed');
B = textscan(g,'%s %n %n %s', 'headerlines', 1);
cen_starts = B{2};
cen_stops = B{3};
cen_centers = .5*(cen_starts + cen_stops);
cen_names = B{4};
cen_chr_names = B{1};
num_chrs = numel(cen_starts);
cen_chr_nums = (1:num_chrs)';

% Add chromosome ends to features
chr_nums = zeros(num_chrs,1);
for c=1:num_chrs
    chr_ends(2*c-1,1) = 1;
    chr_ends(2*c,1) = max(abundances(1).poss(abundances(1).chrs == c));
    chr_end_chr_nums(2*c+[-1 0],1) = c;
end

% Concatinate to "features"
feature_centers = [ars_centers; chr_ends];
feature_chr_nums = [ars_chr_nums; chr_end_chr_nums];

% Determine chromosome lengths. This is not ideal as is
for c=1:num_chrs
    chr_lengths(c) = max(abundances(1).poss(abundances(1).chrs == c));
end

% Create abundances with peaks
for a = 1:num_samples
    ab = abundances(a);
    ab.peak_chrs = [];
    ab.peak_starts = [];
    ab.peak_stops = [];
    ab.peak_arss = {};
    ab.peak_fwhms = [];
    ab.peak_heights = [];
    ab.peak_centers = [];
    abundances_with_peaks(a) = ab;
end


% Process each ARS
for n = 1:num_arss

    % Determine center of ARS
    this_ars_center = ars_centers(n);
    this_ars_chr = ars_chr_nums(n);
    this_ars_name = ars_names{n};
    
    disp(['Processing peaks at ARS ' this_ars_name '...'])

    % Define window as set of positions between this ARS and any other.
    % Determine upper and lower bounds.
    % Upper bound
    is = (feature_chr_nums == this_ars_chr) & (feature_centers > this_ars_center);
    if any(is)
        upper_bound = this_ars_center + (min(feature_centers(is)) - this_ars_center)/2;
    else
        upper_bound = Inf;
    end
    
    % Lower bound
    is = (feature_chr_nums == this_ars_chr) & (feature_centers < this_ars_center);
    if any(is)
        lower_bound = this_ars_center - (this_ars_center - max(feature_centers(is)))/2;
    else
        lower_bound = 0;
    end
    
    window_width = upper_bound - lower_bound;
    
    % Process each sample
    for a = 1:num_samples
        
        % Get positions and corresponding heights within window about ARS
        indices = (abundances(a).chrs == this_ars_chr) & ...
            (abundances(a).poss < upper_bound) & (abundances(a).poss > lower_bound);
        poss = abundances(a).poss(indices);
        heights = abundances(a).means(indices);
        
        % Determine ARS position
        [x, ars_index] = min(abs(poss - this_ars_center));
        ars_pos = poss(ars_index);
        
        % Determine max_height within window
        [max_height, max_pos] = max(heights);
        
        % Determine where height crosses half height
        lower_cross_pos = max(poss((heights < max_height/2) & (poss <= ars_pos)));
        upper_cross_pos = min(poss((heights < max_height/2) & (poss >= ars_pos)));
        
        % If find cross points within window, save as peak
        if numel(lower_cross_pos) == 1 && numel(upper_cross_pos) == 1 && ...
                this_ars_center > lower_cross_pos && ...
                this_ars_center < upper_cross_pos
            
            % Get indices for upper and lower halfs of window
            upper_indices = (abundances(a).chrs == this_ars_chr) & ...
                (abundances(a).poss <= upper_cross_pos) & (abundances(a).poss > this_ars_center);
            lower_indices = (abundances(a).chrs == this_ars_chr) & ...
                (abundances(a).poss >= lower_cross_pos) & (abundances(a).poss < this_ars_center);
            
            % Determine if any "ignore" positions occur in each half (upper
            % and
            % lower)
            ignore_upper = any(abundances(a).ignore & upper_indices);
            ignore_lower = any(abundances(a).ignore & lower_indices);
            
            % If both the upper half or the lower half is ok, annotate
            % ars
            if ~ignore_upper && ~ignore_lower
                
                % Width is twice min distance to half max
                fwhm = upper_cross_pos-lower_cross_pos;
                
                abundances_with_peaks(a).peak_chrs(end+1) = this_ars_chr;
                abundances_with_peaks(a).peak_starts(end+1) = upper_cross_pos;
                abundances_with_peaks(a).peak_stops(end+1) = lower_cross_pos;
                abundances_with_peaks(a).peak_arss{end+1} = this_ars_name;
                abundances_with_peaks(a).peak_fwhms(end+1) = fwhm;
                abundances_with_peaks(a).peak_heights(end+1) = max_height;
                abundances_with_peaks(a).peak_centers(end+1) = poss(max_pos);
            end
            
        end
    end
end