function plot_width_vs_height(abundances, specification, fig) 

    % Verify information
    assert(strcmp('width_vs_height', specification{1}))

    % Get list of samples. Man this is awkward
    sample_names = specification{2};
    num_samples = numel(sample_names);
    samples = zeros(num_samples,1);
    descriptions = {};
    colors = zeros(num_samples,3);
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
    assert(numel(specification{3}) == num_samples)
    for n=1:num_samples
        descriptions{n,1} = these_abundances(n).description;
        colors(n,:) = specification{3}{n};
    end
    
    % Create figure
    figure(fig)
    clf
    set(gca, 'fontsize', 16, 'box', 'on', 'linewidth', 2)
   
    hs = [];
    %xl = [0 15]; xticks = [0 2 4 6 8 10 12 14];
    
    
%    xl = [0 12]; 
%    xticks = [0 5 10];
%    xtickslabel = {'0', '5', '10'};
    
     xl = [0 max_width]; 
     if max_width >= 30
         xticks = 0:10:max_width;
     else
         xticks = 0:5:max_width;
     end
     %xticks = [0 25 50];
     %xtickslabel = {'0', '25', '50'};
    
    yl = [0 1.2];
    yticks = [];
    %plot(window_size*[1 1]/1000, yl, '--k')
    %hold on
    for n=1:num_samples
        heights = these_abundances(n).peak_heights;
        widths = these_abundances(n).peak_fwhms/1000;
        hs(n) = plot(widths, heights, 'o','MarkerEdgeColor', colors(n,:),'MarkerFaceColor', 'none', 'markersize', 12, 'linewidth', 2);
        hold on
        
        % Plot median width        
        mean_height = mean(widths(heights > min_height));
        plot(mean_height*[1 1], yl, '--', 'color', colors(n,:), 'linewidth', 3)
        
        disp([plot_name ' w_v_h sample ' num2str(n) ':  ' num2str(numel(widths(heights > min_height))) ' points  ' num2str(mean(widths(heights > min_height))) ' mean_width  ' num2str(std(widths(heights > min_height))) ' std_width'])
    end
    axis square
    %set(gca, 'box', 'on', 'linewidth', 2, 'fontsize', 22, 'xlim', xl, 'xtick', xticks, 'ylim', yl, 'ytick', yticks, 'xticklabel', xtickslabel)
    set(gca, 'box', 'on', 'linewidth', 3, 'fontsize', 30, 'xlim', xl, 'ylim', yl, 'xtick', xticks, 'ytick', yticks)
    plot(xl, min_height*[1 1], '--k', 'linewidth', 3);
    xlabel({' ', 'peak width (kbp)'}, 'fontsize', 30)
    ylabel({'relative peak height',' '}, 'fontsize', 30)
    legend(hs, descriptions, 'location', 'northoutside', 'fontsize', 12)
    title({plot_title,''}, 'fontsize', 30)
    
    % Save plot.
    plot_file_name = ['results/plots_height_vs_width/height_vs_width_' plot_name];
    disp(plot_file_name)
    %saveas(gcf,[plot_file_name '.eps'],'epsc');
    print('-dpng','-r300',plot_file_name)