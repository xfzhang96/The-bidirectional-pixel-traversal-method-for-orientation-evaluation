% 这个文件用于修复二值化图像
% This file is used to repair the binarized image

% 该函数（repair_image）接收二值化图像作为参数
% This function (repair_image) recevices the binarized image
function I_bin_new = repair_image(I_bin,white)
    [m,n] = size(I_bin);
    change_num = 0;                                 % 记录改变了的数量
    boundary = 0;                                   % 记录边界数量
    repair_times = 0;                               % 记录优化次数
    repair_flag = 1;                                % 是否循环标志
    
    while(repair_flag == 1)
        repair_times = repair_times + 1;
        % 孤立的单个白块变黑块|change the isolated white pixel to black pixel
        for i = 1:1:m
            for j = 1:1:n
                try
                    if(I_bin(i,j) == white)
                        white2black_flag = (I_bin(i-1,j)~=white) + (I_bin(i+1,j)~=white) + (I_bin(i,j+1)~=white) + (I_bin(i,j-1)~=white);
                        if(white2black_flag >= 3)
                            I_bin(i,j) = 0;
                            change_num = change_num + 1;
                        end
                    end
                catch ME
                    boundary = boundary + 1;
                end
            end
        end
        
        % 孤立的单个白块变黑块|change the isolated black pixel to white pixel
        for i = 1:1:m
            for j = 1:1:n
                try
                    if(I_bin(i,j) == 0)
                        black2white_flag = (I_bin(i-1,j)==white) + (I_bin(i+1,j)==white) + (I_bin(i,j+1)==white) + (I_bin(i,j-1)==white);
                        if(black2white_flag >= 3)
                            I_bin(i,j) = white;
                            change_num = change_num + 1;
                        end
                    end
                catch ME
                    boundary = boundary + 1;
                end
            end
        end
        
        % 四个白块，若周围都是黑块则将四个白块变黑块|Four white pixels. If surrounding pixels are black pixel,turn four white pixels to black pixels
        for i = 1:1:m
            for j = 1:1:n
                try
                    if(I_bin(i,j) == white)
                        if(I_bin(i+1,j) == white && ...               
                                I_bin(i,j+1) == white && ...           
                                I_bin(i+1,j+1) == white && ...         
                                I_bin(i-1,j) ~= white &&...             
                                I_bin(i-1,j+1) ~= white &&...          
                                I_bin(i,j+2) ~= white &&...             
                                I_bin(i+1,j+2) ~= white &&...           
                                I_bin(i+2,j+1) ~= white &&...            
                                I_bin(i+2,j) ~= white &&...            
                                I_bin(i,j-1) ~= white &&...               
                                I_bin(i+1,j-1) ~= white)              
                            I_bin(i,j) = 0;
                            I_bin(i+1,j) = 0;
                            I_bin(i,j+1) = 0;
                            I_bin(i+1,j+1) = 0;
                            change_num = change_num + 4;
                        end
                    end
                catch ME
                    boundary = boundary + 1;
                end
            end
        end
        
        % 四个黑块，若周围都是白块则将四个黑块变白块|Four black pixels. If surrounding pixels are white pixel,turn four black pixels to white pixels
        for i = 1:1:m
            for j = 1:1:n
                try
                    if(I_bin(i,j) ~= white)
                        if(I_bin(i+1,j) ~= white && ...                  
                                I_bin(i,j+1) ~= white && ...           
                                I_bin(i+1,j+1) ~= white && ...            
                                I_bin(i-1,j) == white &&...             
                                I_bin(i-1,j+1) == white &&...           
                                I_bin(i,j+2) == white &&...             
                                I_bin(i+1,j+2) == white &&...           
                                I_bin(i+2,j+1) == white &&...           
                                I_bin(i+2,j) == white &&...              
                                I_bin(i,j-1) == white &&...              
                                I_bin(i+1,j-1) == white)                  
                            I_bin(i,j) = white;
                            I_bin(i+1,j) = white;
                            I_bin(i,j+1) = white;
                            I_bin(i+1,j+1) = white;
                            change_num = change_num + 4;
                        end
                    end
                catch ME
                    boundary = boundary + 1;
                end
            end
        end
        
        fprintf('NO.%1.0f optimization：changed number is：%4.0f\n',repair_times,change_num);
        if(change_num == 0)
            break;
        else
            change_num = 0;
        end
    end
    I_bin_new = I_bin;
end
