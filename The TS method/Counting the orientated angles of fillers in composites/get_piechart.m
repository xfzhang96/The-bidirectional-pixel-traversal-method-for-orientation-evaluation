
% 读取--旋转--二值化
filename = "E:\学习资料\研究生\科研\3D磁打印\3D打印实验\orientation algorithm\取向度文章\测试文章\取向度分布算法验证（修改了生成的范围大小，使得图像更清晰）\生成的大角度更多\生成随机矩形的导出图.png";           % 需要计算的文件名
para2opt = [0.1,0.9,10];
angle_max = 0;                                                    % 记录求得的竖直取向度最大的旋转角度
I = imread(filename);                                               % 读图片文件
I_rotate_max = imrotate(I,angle_max,'bicubic','loose');             % 将初始图像旋转至竖直排列
I_rotate_max_bin = Binary_method(I_rotate_max,para2opt);            % 将旋转后的图像转为二值化图像

% 定义变量
white = 255;                                                        % 记录白块数值
[m,n] = size(I_rotate_max_bin);                                     % 获取矩阵长宽
all_block_num_P = 0;                                                % 记录先横再纵涉及到的格子数量，用于选择计算方式
all_block_num_N = 0;                                                % 记录先纵再横涉及到的格子数量，用于选择计算方式
global continuous_threshold;                                        % 定义全局变量
continuous_threshold = 40;                                           % 用于记录连续阈值，当超过该值则认为其垂直或水平
ori_matrix = -ones(m,n);                                            % 初始化就取向角度矩阵，用于记录单个白块的取向方向，初始化为-1，黑块位置无需修改始终为-1
ori_matrix_average = -ones(m,n);                                    % 记录平均后的取向角度矩阵
cal_direction_matrix = zeros(m,n);                                  % 用于记录白块方向（1左上右下，2左下右上，0无方向即黑色）
                                                                    % 与方法二不同，该记录仅仅为了将90度范围转化为180范围，而方法二是逻辑需求。

% 输出图
figure; imshow(I_rotate_max); figure; imshow(I_rotate_max_bin);

% 由于图像识别稍有缺陷，需要对其进行修复
% 方法为：将三面都为白块的黑块变成白块，将三面都为黑块的白块变为黑块
I_rotate_max_bin = repair_image(I_rotate_max_bin,white);
figure; imshow(I_rotate_max_bin);


% 需要计算每一个白块的取向度并统计
% 计算时，先横再纵和先纵再恒两个方向都要计算，然后用涉及到格子最多的方向的计算结果作为该像素点的取向
% 然后利用数组记录下该像素点的计算方式，1代表先横再纵，-1代表先纵再横，完成所有计算后利用这个矩阵对每个像素点进行平均
for i = 1:m
    fprintf('i = %1.0f\n',i);

    for j = 1:n
        
        if(I_rotate_max_bin(i,j) == white)
            % 先横再纵
            [continuous_block_x,left_continuous_num,right_continuous_num] = get_continuous_block_x(I_rotate_max_bin,i,j,white);
            H_block_num_P = continuous_block_x;                                                                 % 计算横向连续的白块数量
            [Z_block_num_P,cal_direction_1] = get_Z_continuous_block_of_H(I_rotate_max_bin,i,j,white);          % 统计横向连续的白块的各个白块对应的纵向的连续白块的数量
                                                                                                                % cal_direction_1为方向
            all_block_num_P = H_block_num_P + Z_block_num_P;                                                    % 记录先横再纵涉及到的格子数量
            
            % 先纵再横
            [continuous_block_y,up_continuous_num,down_continuous_num] = get_continuous_block_y(I_rotate_max_bin,i,j,white); 
            Z_block_num_N = continuous_block_y;                                                                 % 计算纵向连续的白块数量
            [H_block_num_N,cal_direction_2] = get_H_continuous_block_of_Z(I_rotate_max_bin,i,j,white);          % 统计纵向连续的白块的各个白块对应的横向的连续白块的数量
                                                                                                                % cal_direction_2为方向
            all_block_num_N = Z_block_num_N + H_block_num_N;                                                    % 记录先纵再横涉及到的格子数量
                                                                                        
            % 记录角度
            if(all_block_num_P >= all_block_num_N)
                if(all_block_num_P > 0)         %通过改变最小值可以略微消去一些不规律的影响,这里没有作改变
                    ori_matrix(i,j) = 90 - atand((H_block_num_P^2-H_block_num_P)/(Z_block_num_P-H_block_num_P));
                    cal_direction_matrix(i,j) = cal_direction_1;
                end
            else
                if(all_block_num_N > 0)
                    ori_matrix(i,j) = 90 - atand((H_block_num_N-Z_block_num_N)/(Z_block_num_N^2-Z_block_num_N));
                    cal_direction_matrix(i,j) = cal_direction_2;
                end
            end
            
            %把水平和垂直加进去替换
            if(cal_direction_matrix(i,j) == 3)
                ori_matrix(i,j) = 90;
            elseif(cal_direction_matrix(i,j) == 4)
                ori_matrix(i,j) = 0;
            end

        end
    end
end


ori_matrix(1,1) = 90;                                                       % 为了固定colormap不变，固定保持最高值
figure;imagesc(ori_matrix);                                                 % 绘制取向角度图像
rgbmap('white','blue','green','yellow','red');                              % 定义colormap
map = [0 0 0; colormap];                                                    % 将背景黑色加入colormap加以区分
colormap(map);                                                              % 更新colormap
colorbar;

%做统计前，需要将0-90度转化为0-180度
for i = 1:m
    for j = 1:n
        if(cal_direction_matrix(i,j) == 1)
            ori_matrix(i,j) = 180 - ori_matrix(i,j);
        elseif(cal_direction_matrix(i,j) == 2)
            ori_matrix(i,j) = ori_matrix(i,j);
        elseif(cal_direction_matrix(i,j) == 3)
            ori_matrix(i,j) = 90;
        elseif(cal_direction_matrix(i,j) == 4)
            ori_matrix(i,j) = 0;
        elseif(cal_direction_matrix(i,j) == 0)
        else
            fprintf('wrong!!!!!!');
        end
    end
end

ori_matrix(1,1) = -1;                                                       % 变回来
[statistical_diagram, edges] = histcounts(ori_matrix,[-1:1:180]);            % 对不同角度分布进行统计
statistical_diagram(:,1) = [];                                              % 删除第一列 “-1”的数据
edges(:,1) = [];                                                            % 删除第一列 “-1”的数据
figure;plot(statistical_diagram);                                           % 绘制统计图



% 连续块数量搜索函数，包括x,y方向
%===================================================================================================================================================================
% x方向搜索
function [continuous_block_x,left_continuous_num,right_continuous_num] = get_continuous_block_x(binary_img,s_i,s_j,white)
    right_continuous_num = 0;                                       % 记录右边连续的数量
    left_continuous_num = 0;                                        % 记录左边连续的数量
    boundary = 0;                                                   % 记录边界数量
    [m,n] = size(binary_img);
% 向右搜索
    try
        for k = s_j:1:n
            if(binary_img(s_i,k) == white)
                right_continuous_num = right_continuous_num + 1;
            else
                break;
            end
        end
    catch ME
        boundary = boundary + 1;
    end 
% 向左搜索
    try
        for k = s_j:-1:1
            if(binary_img(s_i,k) == white)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
                left_continuous_num = left_continuous_num + 1;
            else
                break;
            end
        end
    catch ME
        boundary = boundary + 1;
    end
    
    continuous_block_x = right_continuous_num + left_continuous_num - 1; % 总计该白块对应的x方向的连续白块数量
end
%===================================================================================================================================================================

% y方向搜索
%===================================================================================================================================================================
function [continuous_block_y,up_continuous_num,down_continuous_num] = get_continuous_block_y(binary_img,s_i,s_j,white)
    up_continuous_num = 0;                                      % 记录上边连续的数量
    down_continuous_num = 0;                                    % 记录下边连续的数量
    boundary = 0;                                               % 记录边界数量
    [m,n] = size(binary_img);
% 向下搜索
    try
        for k = s_i:1:m
            if(binary_img(k,s_j) == white)
                down_continuous_num = down_continuous_num + 1;
            else
                break;
            end
        end
    catch ME
        boundary = boundary + 1;
    end 
% 向上搜索
    try
        for k = s_i:-1:1
            if(binary_img(k,s_j) == white)
                up_continuous_num = up_continuous_num + 1;
            else
                break;
            end
        end
    catch ME
        boundary = boundary + 1;
    end
    
    continuous_block_y = down_continuous_num + up_continuous_num - 1; % 总计该白块对应的x方向的连续白块数量
end
%===================================================================================================================================================================

% 统计横向连续的白块的各个白块对应的纵向的连续白块的数量
%-------------------------------------------------------------------------------------------------------------------------------------------------------------------
function [Z_block_num_P,cal_direction] = get_Z_continuous_block_of_H(binary_img,s_i,s_j,white)
    global continuous_threshold;                                        % 使用全局变量
    Z_block_num_P = 0;
    boundary = 0;
    [m,n] = size(binary_img);
    left_up_continuous_num = 0;                 %左边向上总数量
    left_down_continuous_num = 0;               %左边向下总数量
    right_up_continuous_num = 0;                %右边向上总数量
    right_down_continuous_num = 0;              %右边向下总数量
    
    %---------计算横向连续的白块右边各个白块对应的纵向的连续白块数量
    try
        for k = s_j+1:1:n
            if(binary_img(s_i,k) == white)
                [continuous_block_y,up_continuous_num,down_continuous_num] = get_continuous_block_y(binary_img,s_i,k,white);
                Z_block_num_P = Z_block_num_P +  continuous_block_y;   % 统计横向连续白块的各个纵向的连续的数量
                right_up_continuous_num = right_up_continuous_num + up_continuous_num;
                right_down_continuous_num = right_down_continuous_num + down_continuous_num;
            else
                break
            end
        end
    catch ME
        boundary = boundary + 1;
    end 
    %---------计算横向连续的白块左边各个白块对应的纵向的连续白块数量
    try
        for k = s_j-1:-1:1
            if(binary_img(s_i,k) == white)
                [continuous_block_y,up_continuous_num,down_continuous_num] = get_continuous_block_y(binary_img,s_i,k,white);
                Z_block_num_P = Z_block_num_P + continuous_block_y;    % 统计横向连续白块的各个纵向的连续的数量
                left_up_continuous_num = left_up_continuous_num + up_continuous_num;
                left_down_continuous_num = left_down_continuous_num + down_continuous_num;
            else
                break
            end
        end
    catch ME
        boundary = boundary + 1;
    end 
    %---------统计(i,j)处纵向的连续数量
    [continuous_block_y,up_continuous_num,down_continuous_num] = get_continuous_block_y(binary_img,s_i,s_j,white);
    Z_block_num_P = Z_block_num_P + continuous_block_y;
    
    left_up_continuous_num = left_up_continuous_num + up_continuous_num;                 
    left_down_continuous_num = left_down_continuous_num + down_continuous_num;               
    right_up_continuous_num = right_up_continuous_num + up_continuous_num;                
    right_down_continuous_num = right_down_continuous_num + down_continuous_num; 
    
    
    %做判断确定方向（1左上右下，2左下右上，3代表垂直，4代表水平，0无方向即黑色）
    if(left_up_continuous_num + right_down_continuous_num > left_down_continuous_num + right_up_continuous_num)
        cal_direction = 1;
    else
        cal_direction = 2;
    end
    
    %用于判断是否大于连续阈值，大于连续阈值则定义为垂直
    if(up_continuous_num + down_continuous_num > continuous_threshold)
        cal_direction = 3;
    end
  
end
%-------------------------------------------------------------------------------------------------------------------------------------------------------------------

% 统计纵向连续的白块的各个白块对应的横向的连续白块的数量
%-------------------------------------------------------------------------------------------------------------------------------------------------------------------
function [H_block_num_N,cal_direction] = get_H_continuous_block_of_Z(binary_img,s_i,s_j,white)
    global continuous_threshold;                                        % 使用全局变量
    H_block_num_N = 0;
    boundary = 0;
    [m,n] = size(binary_img);
    up_left_continuous_num = 0;                     %上边向左总数量
    up_right_continuous_num = 0;                    %上边向右总数量
    down_left_continuous_num = 0;                   %下边向左总数量
    down_right_continuous_num = 0;                     %下边向右总数量
    
    %---------计算纵向连续的白块下边各个白块对应的横向的连续白块数量
    try
        for k = s_i+1:1:m
            if(binary_img(k,s_j) == white)
                [continuous_block_x,left_continuous_num,right_continuous_num] = get_continuous_block_x(binary_img,k,s_j,white);
                H_block_num_N = H_block_num_N + continuous_block_x;    % 统计纵向连续的白块的各个白块对应的横向的连续白块的数量
                down_left_continuous_num = down_left_continuous_num + left_continuous_num;
                down_right_continuous_num = down_right_continuous_num + right_continuous_num;
            else
                break
            end
        end
    catch ME
        boundary = boundary + 1;
    end 
    %---------计算纵向连续的白块上边各个白块对应的横向的连续白块数量
    try
        for k = s_i-1:-1:1
            if(binary_img(k,s_j) == white)
                [continuous_block_x,left_continuous_num,right_continuous_num] = get_continuous_block_x(binary_img,k,s_j,white);
                H_block_num_N = H_block_num_N + continuous_block_x;    % 统计纵向连续的白块的各个白块对应的横向的连续白块的数量
                up_left_continuous_num = up_left_continuous_num + left_continuous_num;
                up_right_continuous_num = up_right_continuous_num + right_continuous_num;
            else
                break
            end
        end
    catch ME
        boundary = boundary + 1;
    end 
    %---------统计(i,j)处横向的连续数量
    [continuous_block_x,left_continuous_num,right_continuous_num] = get_continuous_block_x(binary_img,s_i,s_j,white);
    H_block_num_N = H_block_num_N + continuous_block_x;
    
    up_left_continuous_num = up_left_continuous_num + left_continuous_num;                     %上边向左总数量
    up_right_continuous_num = up_right_continuous_num + right_continuous_num;                    %上边向右总数量
    down_left_continuous_num = down_left_continuous_num + left_continuous_num;                   %下边向左总数量
    down_right_continuous_num = down_right_continuous_num + right_continuous_num;                     %下边向右总数量
    
    
    %做判断确定方向（1左上右下，2左下右上，3代表垂直，4代表水平，0无方向即黑色）
    if(up_left_continuous_num + down_right_continuous_num > up_right_continuous_num + down_left_continuous_num)
        cal_direction = 1;
    else
        cal_direction = 2;
    end
    
    %用于判断是否大于连续阈值，大于连续阈值则定义为水平
    if(left_continuous_num + right_continuous_num > continuous_threshold)
        cal_direction = 4;
    end
    
end
%-------------------------------------------------------------------------------------------------------------------------------------------------------------------


