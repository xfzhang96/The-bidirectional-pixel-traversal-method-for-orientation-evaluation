function get_angleofpixel = get_angleofpixel(I,optimal_parameter)
    % 参数初始化 parameter initalization
    %%----------------------------------------------------------------------------------------------
    I_bin = Binary_method(I,optimal_parameter);                         % 获得二值化后图像矩阵| obtian the binarzation matrix

    white = 255;                                                        % 定义白块数值|define the value of white pixel
    [m,n] = size(I_bin);                                                % 获取数组大小|obtain the size of binary_image
    all_block_num_P = 0;                                                % 记录方案Ⅰ（先横再纵）涉及到的像素格子总数量，用于选择计算方式|Record the number of pixels involved in scheme Ⅰ(horizontal-->vertical), for the selection of calculation method 
    all_block_num_N = 0;                                                % 记录方案Ⅱ（先纵再横）涉及到的像素格子总数量，用于选择计算方式|Record the number of pixels involved in scheme Ⅰ(vertical-->horizontal), for the selection of calculation method
    global continuous_threshold;                                        % 定义全局变量|define the global variable
    continuous_threshold = 40;                                          % 连续阈值，当超过连续白色像素格子数量超过该值则认为其垂直或水平状态|Continuous threshold. When the number of continuous white pixels  exceeds this value, it is considered to be vertical or horizontal 
    ori_matrix = -ones(m,n);                                            % 取向角度矩阵，用于记录白色像素块的取向角度（注：该角度根据反正切计算，计算的是取向方向与竖直方向的夹角），黑色像素块无需修改始终为-1
                                                                        % matrix for oriented angles of pixel.(note:the oriented angles are calculated based on the tangent, which are the angles between oriented direction and vertical direction)
                                                                        % The black pixels have no need to change the value of ori_matrix
    cal_direction_matrix = zeros(m,n);                                  % 用于记录所涉及的所有白块的整体方向（1：左上右下，2：左下右上，3:垂直，4：水平，0：无方向即黑色）,用于将0-90度转换为与横向正方向的夹角0-180度
                                                                        % It is used to record the overall orientation of all the white blocks involved (1: left up-->right down, 2: left down --> right up，3: vertical, 4:horizontal, 0: no direction meaning black pixel)
                                                                        % cal_direction_matrix is used to convert 0°-90°in an angle of 0°-180°degrees, which is the angle between oriented direction and positive horizontal direction
    %%----------------------------------------------------------------------------------------------

    figure;imshow(I_bin);                                               % 展示二值化后图像|show the binarized image

    % 以下步骤可以用于优化二值化图像，但其实影响很小，可以省略
    % The following steps can be used to optimize the I_bin, but in fact, the effect is small. this process can be omitted
    I_bin = repair_image(I_bin,white);
    figure; imshow(I_bin);                                              % 展示优化后的二值化后图像|show the binarized image after optimization


    % 计算每一个白色像素块的取向角度并统计|calcultae the oriented angle of every white pixel and count. 
    % 计算包括两个方案Ⅰ（先横再纵）和方案Ⅱ（先纵再横），然后用涉及到像素格子最多的方案的计算结果作为该白色像素块的取向角度
    % The calculation includes two schemes I (horizontal-->vertical) and II (vertical-->horizontal). The calculation result of the scheme, which involves the more pixel blocks, is used as the oriented angle of the white pixel 
    % 计算过程|process of calculation
    %%----------------------------------------------------------------------------------------------
    for i = 1:m
        fprintf('i = %1.0f\n',i);                                       % 打印行数|print the number of lines
        for j = 1:n
            if(I_bin(i,j) == white)
                % 方案一（先横再纵）|scheme Ⅰ(vertical-->horizontal)
                [continuous_block_x,~,~] = get_continuous_block_x(I_bin,i,j,white);                                         % 计算目标白色像素块横向连续的白色像素块数量|calculates the number of horizontally continuous white pixels of the target white pixel block
                H_block_num_P = continuous_block_x;                                                                         
                [Z_block_num_P,cal_direction_1] = get_Z_continuous_block_of_H(I_bin,i,j,white);                             % 统计横向连续的白色像素块的各个白块对应的纵向的连续白色像素块的数量|Count the number of vertically continuous white pixel blocks of every white block in horizontally continuous white pixel blocks
                                                                                                                            % cal_direction_1用来记录整体方向|cal_direction_1 is used to record the whole direction of all white pixels
                all_block_num_P = H_block_num_P + Z_block_num_P;                                                            % 记录方案Ⅰ涉及到的白色像素格子总数量|record the total number of white pixels involved in scheme I

                % 方案二（先纵再横）|scheme Ⅱ(horizontal-->vertical)
                [continuous_block_y,~,~] = get_continuous_block_y(I_bin,i,j,white);                                         % 计算目标白色像素块横向连续的白色像素块数量|calculates the number of vertically continuous white pixels of the target white pixel block
                Z_block_num_N = continuous_block_y;                                                                         
                [H_block_num_N,cal_direction_2] = get_H_continuous_block_of_Z(I_bin,i,j,white);                             % 统计横向连续的白色像素块的各个白块对应的纵向的连续白色像素块的数量|Count the number of horizontally continuous white pixel blocks of every white block in vertically continuous white pixel blocks
                                                                                                                            % cal_direction_1用来记录整体方向|cal_direction_1 is used to record the whole direction of all white pixels
                all_block_num_N = Z_block_num_N + H_block_num_N;                                                            % 记录方案Ⅱ涉及到的白色像素格子总数量|record the total number of white pixels involved in scheme Ⅱ

                % 方案选择与角度记录|select scheme and record angles
                if(all_block_num_P >= all_block_num_N)
                    if(all_block_num_P > 0)         % 通过改变最小值（0）可以略微消去一些不规律的影响,这里没有作改变|Some irregular effects can be slightly eliminated by changing the minimum value (0), which is not used here 
                        ori_matrix(i,j) = 90 - atand((H_block_num_P^2-H_block_num_P)/(Z_block_num_P-H_block_num_P));
                        cal_direction_matrix(i,j) = cal_direction_1;
                    end
                else
                    if(all_block_num_N > 0)         % 通过改变最小值（0）可以略微消去一些不规律的影响,这里没有作改变|Some irregular effects can be slightly eliminated by changing the minimum value (0), which is not used here 
                        ori_matrix(i,j) = 90 - atand((H_block_num_N-Z_block_num_N)/(Z_block_num_N^2-Z_block_num_N));
                        cal_direction_matrix(i,j) = cal_direction_2;
                    end
                end

                % 把水平和垂直加进去|add the vertical direction (90°) and horizontal direction(0°) 
                if(cal_direction_matrix(i,j) == 3)
                    ori_matrix(i,j) = 90;
                elseif(cal_direction_matrix(i,j) == 4)
                    ori_matrix(i,j) = 0;
                end

            end
        end
    end
    %%----------------------------------------------------------------------------------------------


    % 根据与垂直方向的接近度，赋予不同的颜色|give different colors depending on how close the oriented directions of white pixels are to the vertical direction
    %%----------------------------------------------------------------------------------------------
    ori_matrix(1,1) = 90;                                                       % 为了固定colormap不变，保证每次最高值一致|To fix the colormap, make sure the maximum value is the same every time 
    figure;imagesc(ori_matrix);                                                 % 绘制取向角度图像|draw the image oforiented angle
    rgbmap('white','blue','green','yellow','red');                              % 定义colormap|define colormap
    map = [0 0 0; colormap];                                                    % 将背景黑色加入colormap加以区分|add the background (black) to the colormap to distinguish
    colormap(map);                                                              % 更新colormap|update colormap
    colorbar;                                                                   % 显示图例|display legend
    %%----------------------------------------------------------------------------------------------

    % 将0°-90°转化为0°-180°（取向方向与横向正方向的夹角）|Convert 0°-90° to 0°-180° (the Angle between the oriented direction and the positive horizontal direction) 
    %%----------------------------------------------------------------------------------------------
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
    %%----------------------------------------------------------------------------------------------

    % 统计角度|count angles of all pixel
    %%----------------------------------------------------------------------------------------------
    ori_matrix(1,1) = -1;                                                       % 变回来
    [statistical_diagram, edges] = histcounts(ori_matrix,[-1:1:180]);           % 对不同角度分布进行统计
    statistical_diagram(:,1) = [];                                              % 删除第一列 “-1”的数据
    edges(:,1) = [];                                                            % 删除第一列 “-1”的数据
    figure;plot(statistical_diagram);                                           % 绘制统计图
    %%----------------------------------------------------------------------------------------------



    % 连续块数量搜索函数，包括横向和纵向方向|function for searching continuous block numbers, including horizontal and vertical directions
    % 横向方向搜索|horizontal direction search
    %===================================================================================================================================================================
    function [continuous_block_x,left_continuous_num,right_continuous_num] = get_continuous_block_x(binary_img,s_i,s_j,white)
        right_continuous_num = 0;                                               % 记录右边连续的数量|record the number of continuous numbers on the right
        left_continuous_num = 0;                                                % 记录左边连续的数量|record the number of continuous numbers on the left
        boundary = 0;                                                           % 记录边界数量|record the number of boundaries
        [m,n] = size(binary_img);
        % 向右搜索|search towards the right
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
        % 向左搜索|search towards the left
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

        continuous_block_x = right_continuous_num + left_continuous_num - 1;    % 计算目标白色像素块对应的横向方向的连续白色像素块数量|Calculate the number of continuous white pixel blocks in the horizontal direction of the target white pixel block 
    end
    %===================================================================================================================================================================

    % 纵向方向搜索|vertical direction search
    %===================================================================================================================================================================
    function [continuous_block_y,up_continuous_num,down_continuous_num] = get_continuous_block_y(binary_img,s_i,s_j,white)
        up_continuous_num = 0;                                                  % 记录上边连续的数量|record the number of continuous numbers on the up
        down_continuous_num = 0;                                                % 记录下边连续的数量|record the number of continuous numbers on the down
        boundary = 0;                                                           % 记录边界数量|record the number of boundaries
        [m,n] = size(binary_img);
        % 向下搜索|search towards the down
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
        % 向上搜索|search towards the up
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

        continuous_block_y = down_continuous_num + up_continuous_num - 1; % 计算目标白色像素块对应的纵向方向的连续白色像素块数量|Calculate the number of continuous white pixel blocks in the vertical direction of the target white pixel block 
    end
    %===================================================================================================================================================================

    
    % 横向连续块中每个像素块的纵向连续块数量搜索函数|Search function for the number of vertical continuous white pixels of each white pixel in the horizontal continuous white pixels 
    %===================================================================================================================================================================
    function [Z_block_num_P,cal_direction] = get_Z_continuous_block_of_H(binary_img,s_i,s_j,white)
        global continuous_threshold;                                            % 使用全局变量|use global variable
        Z_block_num_P = 0;                                                      % 纵向涉及的白色像素块数量|the number of white pixels involved in vertical direction
        boundary = 0;
        [m,n] = size(binary_img);
        left_up_continuous_num = 0;                                             % 左边向上总数量|the number of white pixels up on the left side
        left_down_continuous_num = 0;                                           % 左边向下总数量|the number of white pixels down on the left side
        right_up_continuous_num = 0;                                            % 右边向上总数量|the number of white pixels up the right side
        right_down_continuous_num = 0;                                          % 右边向下总数量|the number of white pixels down the right side

        % 计算横向连续的白块右边各个白块对应的纵向的连续白块数量|calculate the number of vertical continuous white pixels of each white pixel in horizontal continuous white pixels in the right of targeted white pixel
        try
            for k = s_j+1:1:n
                if(binary_img(s_i,k) == white)
                    [continuous_block_y,up_continuous_num,down_continuous_num] = get_continuous_block_y(binary_img,s_i,k,white);
                    Z_block_num_P = Z_block_num_P + continuous_block_y;        
                    right_up_continuous_num = right_up_continuous_num + up_continuous_num;
                    right_down_continuous_num = right_down_continuous_num + down_continuous_num;
                else
                    break
                end
            end
        catch ME
            boundary = boundary + 1;
        end
        % 计算横向连续的白块左边各个白块对应的纵向的连续白块数量|calculate the number of vertical continuous white pixels of each white pixel in horizontal continuous white pixels in the left of targeted white pixel
        try
            for k = s_j-1:-1:1
                if(binary_img(s_i,k) == white)
                    [continuous_block_y,up_continuous_num,down_continuous_num] = get_continuous_block_y(binary_img,s_i,k,white);
                    Z_block_num_P = Z_block_num_P + continuous_block_y; 
                    left_up_continuous_num = left_up_continuous_num + up_continuous_num;
                    left_down_continuous_num = left_down_continuous_num + down_continuous_num;
                else
                    break
                end
            end
        catch ME
            boundary = boundary + 1;
        end 
        % 统计(s_i,s_j)处纵向的连续数量|count the number of continuous white pixels of targeted (s_i, s_j) in the vertical direction
        [continuous_block_y,up_continuous_num,down_continuous_num] = get_continuous_block_y(binary_img,s_i,s_j,white);
        Z_block_num_P = Z_block_num_P + continuous_block_y;

        left_up_continuous_num = left_up_continuous_num + up_continuous_num;                 
        left_down_continuous_num = left_down_continuous_num + down_continuous_num;               
        right_up_continuous_num = right_up_continuous_num + up_continuous_num;                
        right_down_continuous_num = right_down_continuous_num + down_continuous_num; 


        % 整体方向判断（1：左上右下，2：左下右上，3:垂直，4：水平，0：无方向即黑色）|judgment of whole direction of all involved white pixels(1: left up-->right down, 2: left down --> right up，3: vertical, 4:horizontal, 0: no direction meaning black pixel)
        if(left_up_continuous_num + right_down_continuous_num > left_down_continuous_num + right_up_continuous_num)
            cal_direction = 1;
        else
            cal_direction = 2;
        end

        % 当大于连续阈值，则该白色像素定义为垂直|When greater than the continuous threshold, the white pixel is defined as vertical
        if(up_continuous_num + down_continuous_num > continuous_threshold)
            cal_direction = 3;
        end

    end
    %===================================================================================================================================================================

    % 纵向连续块中每个像素块的横向连续块数量搜索函数|Search function for the number of horizontal continuous white pixels of each white pixel in the vertical continuous white pixels 
    %===================================================================================================================================================================
    function [H_block_num_N,cal_direction] = get_H_continuous_block_of_Z(binary_img,s_i,s_j,white)
        global continuous_threshold;                                            % 使用全局变量|use global variable
        H_block_num_N = 0;                                                      % 横向涉及的白色像素块数量|the number of white pixels involved in horizontal direction
        boundary = 0;
        [m,n] = size(binary_img);
        up_left_continuous_num = 0;                                             % 上边向左总数量|the number of white pixels left on the up side
        up_right_continuous_num = 0;                                            % 上边向右总数量|the number of white pixels right on the up side
        down_left_continuous_num = 0;                                           % 下边向左总数量|the number of white pixels left on the down side
        down_right_continuous_num = 0;                                          % 下边向右总数量|the number of white pixels right on the down side

        % 计算纵向连续的白块下边各个白块对应的横向的连续白块数量|calculate the number of horizontal continuous white pixels of each white pixel in vertical continuous white pixels in the down of targeted white pixel
        try
            for k = s_i+1:1:m
                if(binary_img(k,s_j) == white)
                    [continuous_block_x,left_continuous_num,right_continuous_num] = get_continuous_block_x(binary_img,k,s_j,white);
                    H_block_num_N = H_block_num_N + continuous_block_x; 
                    down_left_continuous_num = down_left_continuous_num + left_continuous_num;
                    down_right_continuous_num = down_right_continuous_num + right_continuous_num;
                else
                    break
                end
            end
        catch ME
            boundary = boundary + 1;
        end 
        % 计算纵向连续的白块上边各个白块对应的横向的连续白块数量|calculate the number of horizontal continuous white pixels of each white pixel in vertical continuous white pixels in the up of targeted white pixel
        try
            for k = s_i-1:-1:1
                if(binary_img(k,s_j) == white)
                    [continuous_block_x,left_continuous_num,right_continuous_num] = get_continuous_block_x(binary_img,k,s_j,white);
                    H_block_num_N = H_block_num_N + continuous_block_x;
                    up_left_continuous_num = up_left_continuous_num + left_continuous_num;
                    up_right_continuous_num = up_right_continuous_num + right_continuous_num;
                else
                    break
                end
            end
        catch ME
            boundary = boundary + 1;
        end 
        % 统计(s_i,s_j)处横向的连续数量|count the number of continuous white pixels of targeted (s_i, s_j) in the horizontal direction
        [continuous_block_x,left_continuous_num,right_continuous_num] = get_continuous_block_x(binary_img,s_i,s_j,white);
        H_block_num_N = H_block_num_N + continuous_block_x;

        up_left_continuous_num = up_left_continuous_num + left_continuous_num;                    
        up_right_continuous_num = up_right_continuous_num + right_continuous_num;                  
        down_left_continuous_num = down_left_continuous_num + left_continuous_num;                   
        down_right_continuous_num = down_right_continuous_num + right_continuous_num;                


        % 整体方向判断（1：左上右下，2：左下右上，3:垂直，4：水平，0：无方向即黑色）|judgment of whole direction of all involved white pixels(1: left up-->right down, 2: left down --> right up，3: vertical, 4:horizontal, 0: no direction meaning black pixel)
        if(up_left_continuous_num + down_right_continuous_num > up_right_continuous_num + down_left_continuous_num)
            cal_direction = 1;
        else
            cal_direction = 2;
        end

        % 当大于连续阈值，则该白色像素定义为水平|When greater than the continuous threshold, the white pixel is defined as vertical
        if(left_continuous_num + right_continuous_num > continuous_threshold)
            cal_direction = 4;
        end

    end
    %===================================================================================================================================================================
end

