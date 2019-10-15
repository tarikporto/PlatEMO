function cs = cs(P, S, a, b, c)
    
    N = size(P,1);
    Cs = zeros(9,1);
    tiles = [[-1 1]; [0 1]; [1 1]; [-1 0]; [0 0]; [1 0]; [-1 -1]; [0 -1]; [1 -1]];
    x1_offset = 2*a + c;
    x2_offset = b;
    
    %plot(P(:,1), P(:,2), 'o');
    
    for i = 1:N
        p = P(i,:);
        for j = 1:9
            if(Cs(j) == 1) 
                continue;
            end
            
            center = tiles(j,:) .* [x1_offset x2_offset]; 
            
            if( (p(1) < center(1) + a && p(1) > center(1) - a) && (p(2) < center(2) + a && p(2) > center(2) - a) )
                Cs(j) = 1;
                break;
            end
        end
        if(sum(Cs) == 9) 
            break;
        end
    end
    
    cs = sum(Cs);
end

