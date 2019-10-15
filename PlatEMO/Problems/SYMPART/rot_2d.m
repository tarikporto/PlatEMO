function X = rot_2d(X, w)

    rot = [cos(w) -sin(w);
            sin(w) cos(w)];
        
    rotX = rot * X'; 
    
    X = rotX';
end

