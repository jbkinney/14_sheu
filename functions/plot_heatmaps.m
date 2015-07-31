clear all
close all
close all hidden

disp('*** Running plot_heatmaps.m ***')

% Read in widths file
contents = importdata('result_peak_widths.txt');
raw_data = contents.data;
sample_names = contents.textdata(1,2:end);
ars_names = contents.textdata(2:end,1)';
num_rows = size(raw_data,1);
num_cols = size(raw_data,2);
assert(num_rows == numel(ars_names));
assert(num_cols == numel(sample_names));

% Remove ARSs with too many missing valies
ars_frac_nan = sum(isnan(raw_data),2)/num_cols;
sample_frac_nan = sum(isnan(raw_data),1)/num_rows;
row_indices = ars_frac_nan < .3;
col_indices = sample_frac_nan < .6;
filtered_data = raw_data(row_indices,col_indices);
filtered_ars_names = ars_names(row_indices);
filtered_sample_names = sample_names(col_indices);
num_filtered_rows = size(filtered_data,1);
num_filtered_cols = size(filtered_data,2);

% Order experiments and arss by median peak width
median_ars_widths = zeros(num_filtered_rows,1);
for m = 1:num_filtered_rows
    row = filtered_data(m,:);
    median_ars_widths(m) = median(row(~isnan(row)));
end

median_sample_widths = zeros(num_filtered_cols,1);
for n = 1:num_filtered_cols
    col = filtered_data(:,n);
    median_sample_widths(n) = median(col(~isnan(col)));
end

% Add a small random number to avoid tied ranks
median_ars_widths = median_ars_widths + rand(num_filtered_rows,1)*1E-6;
median_sample_widths = median_sample_widths + rand(num_filtered_cols,1)*1E-6;

[xxx, row_indices] = sort(median_ars_widths);
[xxx, col_indices] = sort(median_sample_widths);
sorted_data = filtered_data(row_indices,col_indices);
sorted_ars_names = filtered_ars_names(row_indices);
sorted_sample_names = filtered_sample_names(col_indices);


% No, resort based on sample C8
%col_index = strmatch('C8',sorted_sample_names);
%[xxx, row_indices] = sort(sorted_data(:,col_index));
%sorted_data = sorted_data(row_indices,:);
%sorted_ars_names = sorted_ars_names(row_indices);


figure()
subplot(131)
imagesc(raw_data)
subplot(132)
imagesc(filtered_data)
subplot(133)
imagesc(sorted_data)

% Create heatmap from sorted data
data = log10(sorted_data/1000)';
color_range = max(data(:));
data(isnan(data)) = -50;
cm = jet(100);
cm(1,:) = [1 1 1];
hm = HeatMap(data,...
    'RowLabels', sorted_sample_names, ...
    'ColumnLabels', sorted_ars_names, ...
    'Displayrange', color_range, ...
    'Colormap', cm);

% Create clustergram
cgo = clustergram(data, ...
    'RowLabels', sorted_sample_names, ...
    'ColumnLabels', sorted_ars_names, ...
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
heatmap_ax.FontSize = 6;

% Save clustergram
print(cffighnd,'clustergram','-dpng')
