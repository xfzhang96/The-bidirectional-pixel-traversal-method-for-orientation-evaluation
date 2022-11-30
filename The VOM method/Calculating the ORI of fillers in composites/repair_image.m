function I_rotate_max_bin_new = repair_image(I_rotate_max_bin,white)   %输入 旋转-识别-二值化 后得到的二值化图像矩阵
    [m,n] = size(I_rotate_max_bin);
    % 记录改变了的数量
    change_num = 0;
    % 记录边界数量
    boundary = 0;
    % 记录优化次数
    repair_times = 0;
    % 是否循环标志
    repair_flag = 1;
    
    
    while(repair_flag == 1)
        repair_times = repair_times + 1;
        
        % 单个白块变黑块
        for i = 1:1:m
            for j = 1:1:n
                try
                    if(I_rotate_max_bin(i,j) == white)
                        white2black_flag = (I_rotate_max_bin(i-1,j)~=white) + (I_rotate_max_bin(i+1,j)~=white) + (I_rotate_max_bin(i,j+1)~=white) + (I_rotate_max_bin(i,j-1)~=white);
                        if(white2black_flag >= 3)
                            I_rotate_max_bin(i,j) = 0;
                            change_num = change_num + 1;
                        end
                    end
                catch ME
                    boundary = boundary + 1;
                end
            end
        end
        
        % 单个黑块变白块
        for i = 1:1:m
            for j = 1:1:n
                try
                    if(I_rotate_max_bin(i,j) == 0)
                        black2white_flag = (I_rotate_max_bin(i-1,j)==white) + (I_rotate_max_bin(i+1,j)==white) + (I_rotate_max_bin(i,j+1)==white) + (I_rotate_max_bin(i,j-1)==white);
                        if(black2white_flag >= 3)
                            I_rotate_max_bin(i,j) = white;
                            change_num = change_num + 1;
                        end
                    end
                catch ME
                    boundary = boundary + 1;
                end
            end
        end
        
        % 四个周围都是黑块的白块变黑块
        for i = 1:1:m
            for j = 1:1:n
                try
                    if(I_rotate_max_bin(i,j) == white)
                        if(I_rotate_max_bin(i+1,j) == white && ...                   % 下边为白色
                                I_rotate_max_bin(i,j+1) == white && ...              % 右边为白色
                                I_rotate_max_bin(i+1,j+1) == white && ...            % 右下为白色
                                I_rotate_max_bin(i-1,j) ~= white &&...               % 上边为黑色
                                I_rotate_max_bin(i-1,j+1) ~= white &&...             % 右边上边为黑色
                                I_rotate_max_bin(i,j+2) ~= white &&...               % 右边右边为黑色
                                I_rotate_max_bin(i+1,j+2) ~= white &&...             % 右下右边为黑色
                                I_rotate_max_bin(i+2,j+1) ~= white &&...             % 右下下边为黑色
                                I_rotate_max_bin(i+2,j) ~= white &&...               % 下边下边为黑色
                                I_rotate_max_bin(i,j-1) ~= white &&...               % 左边为黑色
                                I_rotate_max_bin(i+1,j-1) ~= white)                  % 下边左边为黑色
                            I_rotate_max_bin(i,j) = 0;
                            I_rotate_max_bin(i+1,j) = 0;
                            I_rotate_max_bin(i,j+1) = 0;
                            I_rotate_max_bin(i+1,j+1) = 0;
                            change_num = change_num + 4;
                        end
                    end
                catch ME
                    boundary = boundary + 1;
                end
            end
        end
        
        % 四个周围都是白块的黑块变白块
        for i = 1:1:m
            for j = 1:1:n
                try
                    if(I_rotate_max_bin(i,j) ~= white)
                        if(I_rotate_max_bin(i+1,j) ~= white && ...                   % 下边为黑色
                                I_rotate_max_bin(i,j+1) ~= white && ...              % 右边为黑色
                                I_rotate_max_bin(i+1,j+1) ~= white && ...            % 右下为黑色
                                I_rotate_max_bin(i-1,j) == white &&...               % 上边为白色
                                I_rotate_max_bin(i-1,j+1) == white &&...             % 右边上边为白色
                                I_rotate_max_bin(i,j+2) == white &&...               % 右边右边为白色
                                I_rotate_max_bin(i+1,j+2) == white &&...             % 右下右边为白色
                                I_rotate_max_bin(i+2,j+1) == white &&...             % 右下下边为白色
                                I_rotate_max_bin(i+2,j) == white &&...               % 下边下边为白色
                                I_rotate_max_bin(i,j-1) == white &&...               % 左边为白色
                                I_rotate_max_bin(i+1,j-1) == white)                  % 下边左边为白色
                            I_rotate_max_bin(i,j) = white;
                            I_rotate_max_bin(i+1,j) = white;
                            I_rotate_max_bin(i,j+1) = white;
                            I_rotate_max_bin(i+1,j+1) = white;
                            change_num = change_num + 4;
                        end
                    end
                catch ME
                    boundary = boundary + 1;
                end
            end
        end
        
%         fprintf('第%1.0f次优化：变化的数量为：%4.0f\n',repair_times,change_num);
        if(change_num == 0)
            break;
        else
            change_num = 0;
        end
    end
    
    I_rotate_max_bin_new = I_rotate_max_bin;
end
