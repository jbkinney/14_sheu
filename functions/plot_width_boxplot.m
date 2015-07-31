function plot_width_boxplot(abundances, specification, fig)

    % Verify information
    assert(strcmp('width_boxplot', specification{1}))

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
    
    these_abundances = abundances(samples);
    for n=1:num_samples
        descriptions{n,1} = these_abundances(n).description;
    end
    
    % Determine min_width and max_height
    these_abundances = abundances(samples);
    for n=1:numel(these_abundances)
        max_widths(n) = these_abundances(n).max_width;
    end
    max_width = max(max_widths);

    % Create figure
    figure(fig)
    clf
    set(gca, 'fontsize', 20, 'box', 'on', 'linewidth', 2)
   
    hs = [];
    %xl = [0 num_samples]; 
    
    for n=1:num_samples
        heights = these_abundances(n).peak_heights;
        min_height = these_abundances(n).min_height;
        indices = heights > min_height;
        fprintf('%d / %d peaks kept for %s \n', sum(indices),numel(indices), descriptions{n})
        widths = these_abundances(n).peak_fwhms/1000;
        T = bplot(widths(indices),n,'horizontal','points','nomean','color','black','width',0.5,'linewidth',1);
        %hs(n) = plot(widths, heights, 'o','color', colors(n,:),'markersize', 8, 'linewidth', 2);
        hold on
        
        % Plot median width
        %mean_height = mean(widths(heights > min_height));
        %plot(mean_height*[1 1], yl, '--', 'color', colors(n,:), 'linewidth', 2)
        
        %disp([plot_name ' w_v_h sample ' num2str(n) ':  ' num2str(numel(widths(heights > min_height))) ' points  ' num2str(mean(widths(heights > min_height))) ' mean_width  ' num2str(std(widths(heights > min_height))) ' std_width'])
    end
    axis square
    %set(gca, 'box', 'on', 'linewidth', 2, 'fontsize', 22, 'xlim', xl, 'xtick', xticks, 'ylim', yl, 'ytick', yticks, 'xticklabel', xtickslabel)
    %plot(xl, min_height*[1 1], '--k');
    %xlabel('peak width (kbp)')
    xlabel({'','peak width (kbp)'})
    %legend(hs, descriptions, 'location', 'northoutside')
    
%      xl = [0 max_width]; 
%      if max_width >= 30
%          xticks = 0:10:max_width;
%      else
%          xticks = 0:5:max_width;
%      end
    
    set(gca, 'ytick', 1:num_samples);
    set(gca, 'yticklabel', descriptions);
    if numel(specification)==3 
        xticks = specification{3};
        xl = [min(xticks), max(xticks)];
        set(gca, 'xlim', xl, 'xtick', xticks);
    end
    %set(gca, 'xlim', xl, 'xtick', xticks)
    set(gca, 'fontsize', 8, 'box', 'off', 'linewidth', 1)
    
    title(plot_title);
    %rotateXLabels(gca,-90)
    
    % Save plot.
    plot_file_name = ['results/plots_width_boxplot/boxplot_' plot_name];
    disp(plot_file_name)
    %saveas(gcf,[plot_file_name '.png'],'png');
    %saveas(gcf,[plot_file_name '.eps'],'epsc');
    print('-dpng','-r900',plot_file_name)