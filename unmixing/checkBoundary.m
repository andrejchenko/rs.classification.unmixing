function inside = checkBoundary(x_coor,y_coor,size1, size2)
inside = [0 0 0 0 0 0 0 0];

    if(x_coor + 1 <= size1)&&(y_coor - 1 <= size2)&&(x_coor + 1 >= 1)&&(y_coor - 1 >= 1) % up right corner
        inside(1) = 1;
    end

    if(x_coor + 1 <= size1)&&(y_coor <= size2)&&(x_coor + 1 >= 1)&&(y_coor >= 1) % right
        inside(2) = 1;
    end
    
    if(x_coor + 1 <= size1)&&(y_coor + 1<= size2)&&(x_coor + 1 >= 1)&&(y_coor +1 >= 1) % low right corner
        inside(3) = 1;
    end
    
    if(x_coor <= size1)&&(y_coor + 1<= size2)&&(x_coor >= 1)&&(y_coor +1 >= 1) % bottom
        inside(4) = 1;
    end
    
    if(x_coor-1<= size1)&&(y_coor + 1<= size2)&&(x_coor-1 >= 1)&&(y_coor +1 >= 1) % low left
        inside(5) = 1;
    end
    
    if(x_coor-1<= size1)&&(y_coor<= size2)&&(x_coor-1 >= 1)&&(y_coor >= 1) % left
        inside(6) = 1;
    end
    
    if(x_coor-1<= size1)&&(y_coor-1<= size2)&&(x_coor-1 >= 1)&&(y_coor-1 >= 1) % up left
        inside(7) = 1;
    end
   
    if(x_coor<= size1)&&(y_coor-1<= size2)&&(x_coor >= 1)&&(y_coor-1 >= 1) % top
        inside(8) = 1;
    end
end