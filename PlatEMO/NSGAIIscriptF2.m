M = 2;
D = 2;
N = 100;
saved = 300;
runs = 30;

CS_all_runs = zeros(runs,saved);
HV_all_runs = zeros(runs,1);
IGD_all_runs = zeros(runs,1);

nsp_configs = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
f_params = [-30 30 0.5 4 6 pi/4];

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

        problem = GLOBAL('-problem',{@F2SYMPART, f_params}).problem;

        main('-algorithm', {@NSGAIIDSD, nsp_config}, '-problem', {@F2SYMPART, f_params}, '-N', N, '-evaluation', 30000, '-save',saved);
        
        load(strcat('Data/NSGAIIDSD/NSGAIIDSD_F2SYMPART_M2_D2_1.mat'));

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
        
        %final_cs = problem.CS(PS);

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
    
    if(nsp_config == 0.0)
        CS_nsp_00 = CS_means;
    end
    
    if(nsp_config == 0.5)
        CS_nsp_05 = CS_means;
    end
    
    if(nsp_config == 1)
        CS_nsp_10 = CS_means;
    end
    
    plot(1:saved, CS_means);
    title('Subconjuntos por geração');
    ylabel('número de subconjuntos');
    xlabel('geração');
    saveas(gcf, strcat('Figures/NSGAIIDSD_f2_',strrep(num2str(nsp_config,'%1.1f'),'.',''),'_clusters_per_generation.png'));

end

boxplot(CS_final_all);
title('Subconjuntos por delta - F2');
xlabel('delta');
ylabel('número de subconjuntos');
xticklabels({'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
saveas(gcf, 'Figures/NSGAIIDSD_f2_clusters_per_delta.png');

boxplot(HV_all);
title('Hypervolume por delta - F2');
xlabel('delta');
ylabel('Hypervolume');
xticklabels({'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
saveas(gcf, 'Figures/NSGAIIDSD_f2_hv_per_delta.png');

boxplot(IGD_all);
title('IGD por delta - F2');
xlabel('delta');
ylabel('IGD');
xticklabels({'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
saveas(gcf, 'Figures/NSGAIIDSD_f2_igd_per_delta.png');

plot(1:saved, CS_nsp_00, 'blue');
hold on
plot(1:saved, CS_nsp_05, 'red');
hold on
plot(1:saved, CS_nsp_10, 'black');
title('Subconjuntos por geração');
ylabel('número de subconjuntos');
xlabel('geração');
lgd = legend('delta = 0.0','delta = 0.5','delta = 1.0');
lgd.Location = 'southwest';
saveas(gcf, strcat('Figures/NSGAIIDSD_f2_resumo_clusters_per_generation.png'));
hold off