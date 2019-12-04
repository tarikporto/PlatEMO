problem = {@DTLZ1,@DTLZ2,@DTLZ3,@DTLZ4,@DTLZ5,@DTLZ6,@DTLZ7,...
    @WFG1,@WFG2,@WFG3,@WFG4,@WFG5,@WFG6,@WFG7,@WFG8,@WFG9};

files = {'DTLZ1_M3_D7', 'DTLZ2_M3_D12', 'DTLZ3_M3_D12', 'DTLZ4_M3_D12', 'DTLZ5_M3_D12', 'DTLZ6_M3_D12', 'DTLZ7_M3_D22',...
    'WFG1_M3_D12', 'WFG2_M3_D12', 'WFG3_M3_D12', 'WFG4_M3_D12', 'WFG5_M3_D12', 'WFG6_M3_D12', ...
    'WFG7_M3_D12', 'WFG8_M3_D12', 'WFG9_M3_D12'};

problems_names = {'DTLZ1','DTLZ2','DTLZ3','DTLZ4','DTLZ5','DTLZ6','DTLZ7',...
    'WFG1','WFG2','WFG3','WFG4','WFG5','WFG6','WFG7','WFG8','WFG9'};

Ms = {'3','3','3','3','3','3','3',...
    '3','3','3','3','3','3','3','3','3'};

Ds = {'7','12','12','12','12','12','22',...
    '12','12','12','12','12','12','12','12','12'};

runs = 100;
HV_all_runs = zeros(runs,1);
IGD_all_runs = zeros(runs,1);
kruskal_all_runs = zeros(runs,1);
shir_all_runs = zeros(runs,1);

nsp_configs = [0 0.3 0.4 0.5 0.6];

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
            main('-algorithm',{@SPEA2DSD,nsp_config},'-problem',problem{n}, '-evaluation', 60000, '-save', 1)

            load(strcat('Data/SPEA2DSD/SPEA2DSD_',problem_name,'_M',Ms{n},'_D',Ds{n},'_1.mat'));

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
        
        HV_all(:,nsp_config_index) = HV_all_runs;
        IGD_all(:,nsp_config_index) = IGD_all_runs;
        kruskal_all(:,nsp_config_index) = kruskal_all_runs;
        shir_all(:,nsp_config_index) = shir_all_runs;

    end
    
    csvwrite(strcat('CSV/SPEA2_',problem_name,'_hv.csv'), HV_all);
    csvwrite(strcat('CSV/SPEA2_',problem_name,'_igd.csv'), IGD_all);
    csvwrite(strcat('CSV/SPEA2_',problem_name,'_mst.csv'), kruskal_all);
    csvwrite(strcat('CSV/SPEA2_',problem_name,'_shir.csv'), shir_all);
end