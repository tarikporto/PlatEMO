problem = {...%@DTLZ1,@DTLZ2,@DTLZ3,@DTLZ4,@DTLZ5,@DTLZ6,@DTLZ7,...
    @WFG1,@WFG2,@WFG3,@WFG4,@WFG5,@WFG6,@WFG7,@WFG8,@WFG9};

files = {...%'DTLZ1_M3_D7', 'DTLZ2_M3_D12', 'DTLZ3_M3_D12', 'DTLZ4_M3_D12', 'DTLZ5_M3_D12', 'DTLZ6_M3_D12', 'DTLZ7_M3_D22',...
    'WFG1_M3_D12', 'WFG2_M3_D12', 'WFG3_M3_D12', 'WFG4_M3_D12', 'WFG5_M3_D12', 'WFG6_M3_D12', ...
    'WFG7_M3_D12', 'WFG8_M3_D12', 'WFG9_M3_D12'};

problems_names = {...%'DTLZ1','DTLZ2','DTLZ3','DTLZ4','DTLZ5','DTLZ6','DTLZ7',...
    'WFG1','WFG2','WFG3','WFG4','WFG5','WFG6','WFG7','WFG8','WFG9'};

Ms = {...%'3','3','3','3','3','3','3',...
    '3','3','3','3','3','3','3','3','3'};

Ds = {...%'7','12','12','12','12','12','22',...
    '12','12','12','12','12','12','12','12','12'};

runs = 50;
evals = 10000;
HV_all_runs = zeros(runs,1);
IGD_all_runs = zeros(runs,1);
kruskal_all_runs = zeros(runs,1);
shir_all_runs = zeros(runs,1);

nsp_configs = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];

HV_mean = zeros(length(nsp_configs),1);
HV_sd = zeros(length(nsp_configs),1);
HV_all = zeros(runs,length(nsp_configs));
IGD_mean = zeros(length(nsp_configs),1);
IGD_sd = zeros(length(nsp_configs),1);
IGD_all = zeros(runs,length(nsp_configs));

kruskal_mean = zeros(length(nsp_configs),1);
kruskal_sd = zeros(length(nsp_configs),1);
kruskal_all = zeros(runs,length(nsp_configs));
shir_mean = zeros(length(nsp_configs),1);
shir_sd = zeros(length(nsp_configs),1);
shir_all = zeros(runs,length(nsp_configs));

for n = 1:length(problem)
    
    problem_name = problems_names{n};
    M = str2double(Ms{n});
    D = str2double(Ds{n});
    
    for nsp_config_index = 1:length(nsp_configs)
        
        nsp_config = nsp_configs(nsp_config_index);

        for r = 1:runs
            main('-algorithm',{@NSGAIIDSD,nsp_config},'-problem',problem{n}, '-evaluation', evals, '-save', 1)

            load(strcat('Data/NSGAIIDSD/NSGAIIDSD_',problem_name,'_M',Ms{n},'_D',Ds{n},'_1.mat'));

            EPF = zeros(100,M);
            PS = zeros(100,D);
            for i = 1:100
                PS(i,:) = result{2}(i).dec;
                EPF(i,:) = result{2}(i).obj;
            end

            TPF = GLOBAL('-problem',problem{n}).problem.PF(100);
            
            [HV_all_runs(r,1),~] = HV(EPF, TPF);
            IGD_all_runs(r,1) = IGD(EPF, TPF);
            kruskal_all_runs(r,1) = Kruskal(PS);
            shir_all_runs(r,1) = Shir(PS);
            
        end
        
        HV_mean(nsp_config_index,1) = mean(HV_all_runs);
        HV_sd(nsp_config_index,1) = std(HV_all_runs);
        HV_all(:,nsp_config_index) = HV_all_runs;

        IGD_mean(nsp_config_index,1) = mean(IGD_all_runs);
        IGD_sd(nsp_config_index,1) = std(IGD_all_runs);
        IGD_all(:,nsp_config_index) = IGD_all_runs;
        
        kruskal_mean(nsp_config_index,1) = mean(kruskal_all_runs);
        kruskal_sd(nsp_config_index,1) = std(kruskal_all_runs);
        kruskal_all(:,nsp_config_index) = kruskal_all_runs;
        
        shir_mean(nsp_config_index,1) = mean(shir_all_runs);
        shir_sd(nsp_config_index,1) = std(shir_all_runs);
        shir_all(:,nsp_config_index) = shir_all_runs;

    end
    
    boxplot(HV_all);
    title(strcat('Hypervolume por delta - ',problem_name));
    xlabel('delta');
    ylabel('Hypervolume');
    xticklabels({'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
    saveas(gcf, strcat('Figures/NSGAIIDSD_',problem_name, '_hv_per_delta.png'));

    boxplot(IGD_all);
    title(strcat('IGD por delta - ',problem_name));
    xlabel('delta');
    ylabel('IGD');
    xticklabels({'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
    saveas(gcf, strcat('Figures/NSGAIIDSD_',problem_name, '_igd_per_delta.png'));
    
    boxplot(kruskal_all);
    title(strcat('MST por delta - ',problem_name));
    xlabel('delta');
    ylabel('MST');
    xticklabels({'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
    saveas(gcf, strcat('Figures/NSGAIIDSD_',problem_name, '_mst_per_delta.png'));
    
    boxplot(shir_all);
    title(strcat('Densidade Shir por delta - ',problem_name));
    xlabel('delta');
    ylabel('Densidade Shir');
    xticklabels({'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
    saveas(gcf, strcat('Figures/NSGAIIDSD_',problem_name, '_dshir_per_delta.png'));
end
