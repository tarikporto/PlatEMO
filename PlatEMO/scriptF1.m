M = 2;
D = 2;
N = 100;
saved = 300;    
runs = 30;

CS_all_runs = zeros(runs,saved);
HV_all_runs = zeros(runs,1);
IGD_all_runs = zeros(runs,1);

nsp_configs = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];
f_params = [-20 20 0.5 10 9];

for nsp_config_index = 1:length(nsp_configs)
    for r = 1:runs
        
        nsp_config = nsp_configs(nsp_config_index);
        %main('-algorithm', @NSGAII, '-problem', @F1SYMPART, '-N', 100, '-evaluation', 30000, '-save',saved);

        %load(strcat('Data/NSGAII/NSGAII_F1SYMPART_M2_D2_1.mat'));

        problem = GLOBAL('-problem',{@F1SYMPART, f_params}).problem;

        main('-algorithm', {@NSGAIIDSD, nsp_config}, '-problem', {@F1SYMPART, f_params}, '-N', N, '-evaluation', 30000, '-save',saved);

        load(strcat('Data/NSGAIIDSD/NSGAIIDSD_F1SYMPART_M2_D2_1.mat'));

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

    plot(1:saved, CS_means);

    CS_final_mean = mean(CS_all_runs(:,300));
    CS_final_sd = std(CS_all_runs(:,300));
    
    HV_mean = mean(HV_all_runs);
    HV_sd = std(HV_all_runs);
    
    IGD_mean = mean(IGD_all_runs);
    IGD_sd = std(IGD_all_runs);

    title(strcat('NSGAIIDSD with nsp ',str2double(nsp_config),' for F1 - Clusters per generation'));
    saveas(gcf, strcat('Figures/NSGAIIDSD_',str2double(nsp_config),'_f1_clusters_per_generation.png'));
end
