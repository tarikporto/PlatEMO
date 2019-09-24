classdef F1SYMPART < PROBLEM
%SYM_PART Summary of this function goes here
%   Detailed explanation goes here
    methods
    
        function obj = F1SYMPART()
            if isempty(obj.Global.M)
                obj.Global.M = 2;
            end
            if isempty(obj.Global.D)
                obj.Global.D = 2;
            end
            obj.Global.lower    = ones(1,obj.Global.D);
            obj.Global.upper    = ones(1,obj.Global.D);
            obj.Global.encoding = 'real';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            %[N,D]  = size(PopDec);
            %M      = obj.Global.M;
            a = 0.5;
            b = 0.5;
            c = 1;
            X1 = PopDec(:,1);
            X2 = PopDec(:,2);
            
            t1_hat = sign(X1) .* ceil((abs(X1) - (a + c/2))/(2*a + c));
            t2_hat = sign(X2) .* ceil((abs(X2) - (b/2))/b);

            t1 = sign(t1_hat).*min(abs(t1_hat),1);
            t2 = sign(t2_hat).*min(abs(t2_hat),1);

            PopObj = [(X1 - t1*(c+2*a)) X2 - t2*b];
        end
        %% Sample reference points on Pareto front
        function P = PF(obj,N)
            P = UniformPoint(N,obj.Global.M)/2;
        end
    
    end
end

