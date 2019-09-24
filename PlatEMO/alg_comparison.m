
algorithms = {@NSGAII, {@NSGAIIDSD,0.5}};
algorithms_names = {'NSGAII', 'NSGAIIDSD'};

runs = 30;

problem = {@ZDT1,@ZDT2,@ZDT3,@ZDT4,@ZDT6,...
    @DTLZ1,@DTLZ2,@DTLZ3,@DTLZ4,@DTLZ5,@DTLZ6,@DTLZ7,...
    @UF1,@UF2,@UF3,@UF4,@UF5,@UF6,@UF7, ...
    @WFG1,@WFG2,@WFG3,@WFG4,@WFG5,@WFG6,@WFG7,@WFG8,@WFG9};

files = {'ZDT1_M2_D30', 'ZDT2_M2_D30', 'ZDT3_M2_D30', 'ZDT4_M2_D10', 'ZDT6_M2_D10',...
    'DTLZ1_M3_D7', 'DTLZ2_M3_D12', 'DTLZ3_M3_D12', 'DTLZ4_M3_D12', 'DTLZ5_M3_D12', 'DTLZ6_M3_D12', 'DTLZ7_M3_D22',...
    'UF1_M2_D30', 'UF2_M2_D30', 'UF3_M2_D30', 'UF4_M2_D30', 'UF5_M2_D30', 'UF6_M2_D30', 'UF7_M2_D30', ...
    'WFG1_M3_D12', 'WFG2_M3_D12', 'WFG3_M3_D12', 'WFG4_M3_D12', 'WFG5_M3_D12', 'WFG6_M3_D12', ...
    'WFG7_M3_D12', 'WFG8_M3_D12', 'WFG9_M3_D12'};

problems_names = {'ZDT1','ZDT2','ZDT3','ZDT4','ZDT6',...
    'DTLZ1','DTLZ2','DTLZ3','DTLZ4','DTLZ5','DTLZ6','DTLZ7',...
    'UF1','UF2','UF3','UF4','UF5','UF6','UF7',...
    'WFG1','WFG2','WFG3','WFG4','WFG5','WFG6','WFG7','WFG8','WFG9'};

Ms = {'2','2','2','2','2'...
    '3','3','3','3','3','3','3',...
    '2','2','2','2','2','2','2',...
    '3','3','3','3','3','3','3','3','3'};

Ds = {'30','30','30','10','10',...
    '7','12','12','12','12','12','22',...
    '30','30','30','30','30','30','30',...
    '12','12','12','12','12','12','12','12','12'};

for i = 1:length(algorithms)
    for j = 1:length(problem)
        for n = 1:runs
            main('-algorithm',algorithms{i},'-problem',problem{j}, '-evaluation', 72128, '-save', 1, '-run', n)
        end
    end
end

HV_mean = zeros(length(algorithms),length(problem));
IGD_mean = zeros(length(algorithms),length(problem));
Kruskal_mean = zeros(length(algorithms),length(problem));

for i = 1:length(algorithms)
    for j = 1:length(problem)
        HV_current = zeros(1,runs);
        IGD_current = zeros(1,runs);
        Kruskal_current = zeros(1,runs);
        
        for n = 1:runs
            problem_name = problems_names{j};
            M = str2double(Ms{j});
            D = str2double(Ds{j});
            run_name = int2str(n);

            load(strcat('Data/',algorithms_names{i},'/',algorithms_names{i},'_',problem_name,'_M',Ms{j},'_D',Ds{j},'_',run_name,'.mat'));

            EPF = zeros(100,M);
            PS = zeros(100,D);
            for k = 1:100
                PS(k,:) = result{2}(k).dec;
                EPF(k,:) = result{2}(k).obj;
            end

            TPF = GLOBAL('-problem',problem{j}).problem.PF(10000);
            
            HV_current(n) = HV(EPF,TPF);
            IGD_current(n) = IGD(EPF,TPF);
            Kruskal_current(n) = Kruskal(PS);
            
        end
        HV_mean(i,j) = mean(HV_current);
        IGD_mean(i,j) = mean(IGD_current);
        Kruskal_mean(i,j) = mean(Kruskal_current);
        
    end
end
