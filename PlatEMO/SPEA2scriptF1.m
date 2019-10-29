M = 2;
D = 2;
N = 100;
saved = 300;    
runs = 30;

CS_all_runs = zeros(runs,saved);
HV_all_runs = zeros(runs,1);
IGD_all_runs = zeros(runs,1);

nsp_configs = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
f_params = [-30 30 0.5 4 6];

CS_final_mean = zeros(length(nsp_configs),1);
CS_final_sd = zeros(length(nsp_configs),1);
CS_final_all = zeros(runs,length(nsp_configs));
HV_mean = zeros(length(nsp_configs),1);
HV_sd = zeros(length(nsp_configs),1);
HV_all = zeros(runs,length(nsp_configs));
IGD_mean = zeros(length(nsp_configs),1);
IGD_sd = zeros(length(nsp_configs),1);
IGD_all = zeros(runs,length(nsp_configs));

for nsp_config_index = 1:length(nsp_configs)
    for r = 1:runs
        
        nsp_config = nsp_configs(nsp_config_index);
        %main('-algorithm', @NSGAII, '-problem', @F1SYMPART, '-N', 100, '-evaluation', 30000, '-save',saved);

        %load(strcat('Data/NSGAII/NSGAII_F1SYMPART_M2_D2_1.mat'));

        problem = GLOBAL('-problem',{@F1SYMPART, f_params}).problem;

        main('-algorithm', {@SPEA2DSD, nsp_config}, '-problem', {@F1SYMPART, f_params}, '-N', N, '-evaluation', 30000, '-save',saved);

        load(strcat('Data/SPEA2DSD/SPEA2DSD_F1SYMPART_M2_D2_1.mat'));

        final_population = result{saved,2};

        CS = zeros(1,saved);
        for i = 1:saved
            cur_population = result{i,2};
            cur_decs = zeros(N,D);
            for j = 1:N
                cur_decs(j,:) = cur_population(j).dec;
            end

            CS(i) = problem.CS(cur_decs);
        end

        TPF = problem.PF(N);
        EPF = zeros(100,M);
        PS = zeros(100,D);

        for i = 1:N
            PS(i,:) = final_population(i).dec;
            EPF(i,:) = final_population(i).obj;
        end

        CS_all_runs(r,:) = CS;
        
        [HV_all_runs(r,1),~] = HV(EPF, TPF);
        IGD_all_runs(r,1) = IGD(EPF, TPF);
        
        %plot(EPF(:,1),EPF(:,2), 'o');
        %plot(TPF(:,1),TPF(:,2), 'o');
        %plot(PS(:,1), PS(:,2), 'o');
    end

    CS_means = mean(CS_all_runs,1);

    CS_final_mean(nsp_config_index,1) = mean(CS_all_runs(:,300));
    CS_final_sd(nsp_config_index,1) = std(CS_all_runs(:,300));
    CS_final_all(:,nsp_config_index) = CS_all_runs(:,300);
    
    HV_mean(nsp_config_index,1) = mean(HV_all_runs);
    HV_sd(nsp_config_index,1) = std(HV_all_runs);
    HV_all(:,nsp_config_index) = HV_all_runs;
    
    IGD_mean(nsp_config_index,1) = mean(IGD_all_runs);
    IGD_sd(nsp_config_index,1) = std(IGD_all_runs);
    IGD_all(:,nsp_config_index) = IGD_all_runs;

    plot(1:saved, CS_means);
    title('Subconjuntos por geração');
    ylabel('número de subconjuntos');
    xlabel('geração');
    saveas(gcf, strcat('Figures/SPEA2DSD_f1_',num2str(nsp_config,'%1.1f'),'_clusters_per_generation.png'));
end

boxplot(CS_final_all);
title('Subconjuntos por delta - F1');
xlabel('?');
ylabel('número de subconjuntos');
xticklabels({'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
saveas(gcf, 'Figures/SPEA2DSD_f1_clusters_per_delta.png');

boxplot(HV_all);
title('Hypervolume por delta - F1');
xlabel('?');
ylabel('Hypervolume');
xticklabels({'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
saveas(gcf, 'Figures/SPEA2DSD_f1_hv_per_delta.png');

boxplot(IGD_all);
title('IGD por delta - F1');
xlabel('?');
ylabel('IGD');
xticklabels({'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
saveas(gcf, 'Figures/SPEA2DSD_f1_igd_per_delta.png');