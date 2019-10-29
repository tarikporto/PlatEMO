function F2 = F2_sym_part(X, a, b, c, w)
    
    %plot(X(:,1),X(:,2),'o');
    rotX = rot_2d(X, w);
    %plot(rotX(:,1),rotX(:,2),'o');

    F2 = F1_sym_part(rotX, a, b, c);
end

