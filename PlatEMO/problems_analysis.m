% Script

% ZDT (1, 2, 3, 4 e 6); DTLZ (1 a 7); UF (1 a 7); WFG (1 a 9)

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

for n = 1:length(problem)
    main('-algorithm',@NSGAII,'-problem',problem{n}, '-evaluation', 72128, '-save', 1)
end

for n = 1:length(problem)
    problem_name = problems_names{n};
    M = str2double(Ms{n});
    D = str2double(Ds{n});
    
    load(strcat('Data/NSGAII/NSGAII_',problem_name,'_M',Ms{n},'_D',Ds{n},'_1.mat'));
    
    EPF = zeros(100,M);
    PS = zeros(100,D);
    for i = 1:100
        PS(i,:) = result{2}(i).dec;
        EPF(i,:) = result{2}(i).obj;
    end
    
    TPF = GLOBAL('-problem',@F1SYMPART).problem.PF(100);
    
    % gera EPF e TPF e salva como png
    if M == 2
        plot(EPF(:,1),EPF(:,2), 'o');
        title(strcat(problem_name, ' EPF'));
        saveas(gcf, strcat('Figures/',problem_name,'_EPF.png'));
        close
        
        plot(TPF(:,1),TPF(:,2), 'o');
        title(strcat(problem_name, ' TPF'));
        saveas(gcf, strcat('Figures/',problem_name,'_TPF.png'));
        close
    elseif M == 3
        plot3(EPF(:,1),EPF(:,2),EPF(:,3), 'o');
        title(strcat(problem_name, ' EPF'));
        grid on
        saveas(gcf, strcat('Figures/',problem_name,'_EPF.png'));
        close
        
        plot3(TPF(:,1),TPF(:,2), TPF(:,3), '.');
        title(strcat(problem_name, ' TPF'));
        saveas(gcf, strcat('Figures/',problem_name,'_TPF.png'));
        close
    end
    
    % gera hclust e salva como png
    Y = pdist(PS);
    Z = linkage(Y);
    dendrogram(Z);
    title(strcat(problem_name, ' PS dendrogram'));
    saveas(gcf, strcat('Figures/',problem_name,'_dendrogram.png'));
    close
end

