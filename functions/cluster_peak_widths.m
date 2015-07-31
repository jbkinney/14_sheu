clear all
close all
close all hidden

disp('*** Running cluster_peak_widths.m ***')

% Read in ARSs
f = fopen('./oriDB_confirmed_ARSs.bed');
A = textscan(f,'%s %n %n %s', 'headerlines', 2);
ars_names = A{4}';
num_arss = numel(ars_names);

% Load abundances
load abundances.mat;
abundances_with_peaks;
num_samples = numel(abundances_with_peaks);
sample_names = {};

% Fill matrix with peak widths
peak_widths_mat = zeros(num_samples,num_arss);
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
        
    end

end

% Should save heatmap. 

% Get rid of ARSs that have missing data in more than 30% of samples
cols_to_keep = sum(peak_widths_mat == 0,1) < num_samples*0.30;
new_peak_widths_mat = peak_widths_mat(:,cols_to_keep);
new_ars_names = ars_names(cols_to_keep);
new_num_arss = numel(new_ars_names);

% Get rid of samples that have missing data for more than 30% of remaining ARSs
rows_to_keep = sum(new_peak_widths_mat == 0,2) < new_num_arss*0.10;
newnew_peak_widths_mat = new_peak_widths_mat(rows_to_keep,:);
new_sample_names = sample_names(rows_to_keep);
num_samples = numel(new_sample_names);

% Create clustergram
data = log10(newnew_peak_widths_mat/1000);
color_range = max(data(:));
data(data == -Inf) = -50;
cm = jet(100);
cm(1,:) = [1 1 1];
cgo = clustergram(data, ...
    'RowLabels', new_sample_names, ...
    'ColumnLabels', new_ars_names, ...
    'RowPDist', @mydist, ...
    'ColumnPDist', @mydist, ...
    'Displayrange', color_range, ...
    'Colormap', cm);

% Convert clustergram to figure
set(0,'ShowHiddenHandles','on');
allhnds = get(0,'Children');
cgfigidx = strmatch('Clustergram',get(allhnds,'Tag'));
cffighnd = allhnds(cgfigidx);
set(0,'showhiddenHandles','off');

% Set figure position
set(cffighnd,'position',[611         249        1851         883])

% Create clustergram-compatible colorbar
% Yes, this is some cryptic stack overflow voodoo
cbButton = findall(cffighnd,'tag','HMInsertColorbar');
ccb = get(cbButton,'ClickedCallback');
set(cbButton,'State','on');
ccb{1}(cbButton,[],ccb{2});

% Change legend on colorbar
colorbar_ax = cffighnd.Children(4);
colorbar_ax.Ticks = log10([0.1, 0.2, 0.5, 1.0, 2.0, 5.0, 10, 20]);
colorbar_ax.TickLabels = {'0.1','0.2','0.5','1', '2','5','10', '20'};
colorbar_ax.FontSize = 12;
colorbar_ax.Label.String = 'Peak width (kb)';

% Change fontsize on axes
heatmap_ax = cffighnd.Children(5);
heatmap_ax.FontSize = 6

% Save clustergram
print(cffighnd,'clustergram','-dpng')
