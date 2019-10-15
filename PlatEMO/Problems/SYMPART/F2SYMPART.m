classdef F2SYMPART < PROBLEM
%SYM_PART Summary of this function goes here
%   Detailed explanation goes here
    properties(Access = private)
        L;
        U;
        a;
        b;
        c;
        w;
    end
    methods
    
        function obj = F2SYMPART()
            if isempty(obj.Global.M)
                obj.Global.M = 2;
            end
            if isempty(obj.Global.D)
                obj.Global.D = 2;
            end
            
            params = obj.Global.ParameterSet([0.2 5 5 45]);
            
            obj.L = params(1);
            obj.U = params(2);
            obj.a = params(3);
            obj.b = params(4);
            obj.c = params(5);
            obj.w = params(6);
            
            obj.Global.lower    = ones(1,obj.Global.D)*obj.L;
            obj.Global.upper    = ones(1,obj.Global.D)*obj.U;
            obj.Global.encoding = 'real';
        end
        %% Calculate objective values
        function PopObj = CalObj(obj,PopDec)
            %[N,D]  = size(PopDec);
            %M      = obj.Global.M;
            PopObj = F2_sym_part(PopDec, obj.a, obj.b, obj.c, obj.w);
        end
        %% Sample reference points on Pareto front
        function P = PF(obj,N)
            M = obj.Global.M;
            step = 1/(N+2);
            P = zeros([N M]);
            v = step;
            for i = 1:N
                P(i,:) = [4*obj.a^2*v^2 4*obj.a^2*(1-v)^2];
                v = v + step;
            end
        end
        function CS = CS(obj, PopDec)
            %plot(PopDec(:,1), PopDec(:,2), 'o');
            %popRotated = rot_2d(PopDec, obj.w);
            %plot(popRotated(:,1), popRotated(:,2), 'o');
            CS = cs(rot_2d(PopDec, obj.w), [], obj.a, obj.b, obj.c);
        end
    end
end

