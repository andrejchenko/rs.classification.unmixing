function testPixIndClass = checkTestPixIndClass(x_coor,y_coor,z, testPixIndClass,numClasses)
    if(z==1) % up right
        % x_coor + 1
        % y_coor - 1
        remRows =[];
        for i=1:numClasses
            for j = 1: size(testPixIndClass{i},1)
                x_test = testPixIndClass{i}(j,1);
                y_test = testPixIndClass{i}(j,2);
                
                if(x_coor + 1 == x_test) && (y_coor - 1 == y_test)
                    remRows = [remRows;j];
                    %testPixIndClass{i}(j,:)=[];
                end
            end
            for z=1:size(remRows,1)
                testPixIndClass{i}(remRows(z),:)=[];
                remRows =[];
            end
        end
    end
    
    if(z==2) % right
        % x_coor + 1
        % y_coor
        remRows =[];
        for i=1:numClasses
            for j = 1: size(testPixIndClass{i},1)
                x_test = testPixIndClass{i}(j,1);
                y_test = testPixIndClass{i}(j,2);
                
                if(x_coor + 1 == x_test) && (y_coor == y_test)
                   remRows = [remRows;j];
                end
            end
            for z=1:size(remRows,1)
                testPixIndClass{i}(remRows(z),:)=[];
                remRows =[];
            end
        end
    end
    
    if(z==3) % low right
        % x_coor + 1
        % y_coor + 1
        remRows =[];
        for i=1:numClasses
            for j = 1: size(testPixIndClass{i},1)
                x_test = testPixIndClass{i}(j,1);
                y_test = testPixIndClass{i}(j,2);
                
                if(x_coor + 1 == x_test) && (y_coor + 1 == y_test)
                     remRows = [remRows;j];
                end
            end
            for z=1:size(remRows,1)
                testPixIndClass{i}(remRows(z),:)=[];
                remRows =[];
            end
        end
    end
    
    if(z==4) % bottom
        % x_coor
        % y_coor + 1
        remRows =[];
        for i=1:numClasses
            for j = 1: size(testPixIndClass{i},1)
                x_test = testPixIndClass{i}(j,1);
                y_test = testPixIndClass{i}(j,2);
                
                if(x_coor == x_test) && (y_coor + 1 == y_test)
                   remRows = [remRows;j];
                end
            end
            for z=1:size(remRows,1)
                testPixIndClass{i}(remRows(z),:)=[];
                remRows =[];
            end
        end
    end
    
    if(z==5) % low left
        % x_coor -1 
        % y_coor + 1
        remRows =[];
        for i=1:numClasses
            for j = 1: size(testPixIndClass{i},1)
                x_test = testPixIndClass{i}(j,1);
                y_test = testPixIndClass{i}(j,2);
                
                if(x_coor - 1 == x_test) && (y_coor + 1 == y_test)
                    remRows = [remRows;j];
                end
            end
            for z=1:size(remRows,1)
                testPixIndClass{i}(remRows(z),:)=[];
                remRows =[];
            end
        end
    end
    
    if(z==6) % left
        % x_coor -1 
        % y_coor
        remRows =[];
        for i=1:numClasses
            for j = 1: size(testPixIndClass{i},1)
                x_test = testPixIndClass{i}(j,1);
                y_test = testPixIndClass{i}(j,2);
                
                if(x_coor - 1 == x_test) && (y_coor == y_test)
                    remRows = [remRows;j];
                end
            end
             for z=1:size(remRows,1)
                testPixIndClass{i}(remRows(z),:)=[];
                remRows =[];
            end
        end
    end
    
    if(z==7) % up left
        % x_coor -1 
        % y_coor -1 
        remRows =[];
        for i=1:numClasses
            for j = 1: size(testPixIndClass{i},1)
                x_test = testPixIndClass{i}(j,1);
                y_test = testPixIndClass{i}(j,2);
                
                if(x_coor - 1 == x_test) && (y_coor - 1 == y_test)
                    remRows = [remRows;j];
                end
            end
            for z=1:size(remRows,1)
                testPixIndClass{i}(remRows(z),:)=[];
                remRows =[];
            end
        end
    end
    
    if(z==8) % top
        % x_coor 
        % y_coor - 1 
         remRows =[];
        for i=1:numClasses
            for j = 1: size(testPixIndClass{i},1)
                x_test = testPixIndClass{i}(j,1);
                y_test = testPixIndClass{i}(j,2);
                
                if(x_coor == x_test) && (y_coor - 1 == y_test)
                    remRows = [remRows;j];
                end
            end
            for z=1:size(remRows,1)
                testPixIndClass{i}(remRows(z),:)=[];
                remRows =[];
            end
        end
    end
end
