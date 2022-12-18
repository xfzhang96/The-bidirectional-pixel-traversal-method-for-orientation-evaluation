% 这个文件用于获取输入图像旋转0°-179°后的竖直取向度
% This file is used to obtain the V-ORI of the input image after rotated from 0° to 179° 

% 该函数（get_curveofimage）接收图像数组和优化后的参数作为参数
% This function (get_curveofimage) recevices the name of image and optimizded parameters
function curveofimage = get_curveofimage (I,parameters,showOrNot)
    % 参数初始化 parameter initalization
    %%----------------------------------------------------------------------------------------------
    angle = 179;                                                            % 旋转角度范围(0-angle)| rotated angle range (0-angle)
    orientation = zeros(1,180);                                             % 竖直取向度数组| matrix for the V-ORI
    %%----------------------------------------------------------------------------------------------
    
    % 图像处理| picture processing
    %%----------------------------------------------------------------------------------------------
    % 对图像步进旋转180次计算其竖直取向度，获得取向度曲线| stepping rotating 180 times to calculate the V-ORI, obatin the orientation curve
    for i = 0:1:angle 
        I_rotate = imrotate(I,i,'bicubic','loose');                         % 获得旋转i度后图像矩阵| obtain the image matrix after rotating i degree
        I_rotate_bin = Binary_method(I_rotate,parameters);                  % 获得二值化后图像矩阵| obtian the binarzation matrix
        orientation(i+1) = calculate_ori(I_rotate_bin);                     % 计算取向度| calculate the V-ORI
        % fprintf('No.%1.0f: 取向度 is %4.4f%%\n',i,orientation(i));        % 输出每次旋转后计算的结果| Output the results after each rotation 
    end
    %%----------------------------------------------------------------------------------------------

          
    % 角度更新| update angle
    %%----------------------------------------------------------------------------------------------
    % 注意：根据函数imrotate的定义以及竖直取向度的定义，此处的旋转角度为将图像 I 围绕其中心点逆时针方向旋转一定角度
    % 因此orientation数组对应的下标所对代表的角度(rotated angle)为评估的取向方向和竖直向上方向的角度，
    % 为便于理解，需要将其转换评估方向为与水平向右方向的夹角(transformed angle)
    % Note: According to the definition of function imrotate and the definition of V-ORI,
    % the rotated angle here is to rotate image I counterclockwise around its center point for a certain angle.
    % Therefore, the rotated angle represented by the subscript of orintation array is angle of the evaluated direction and vertical direction.
    % To facilitate understanding, the rotated angle needs to be transformed into a transformed angle, which is the angle of the evaluated direction and horizontal direction. 
    curveofimage = zeros(1,180);                                            % 该数组下标代表tranformed angle|the subscript represent the tranformed angle in this array
    for i = 1:1:90
        curveofimage(i) = orientation(90-i+1);
    end
    for i = 91:1:180
        curveofimage(i) = orientation(270-i+1);
    end
    %%----------------------------------------------------------------------------------------------
    
    % 是否展示旋转后结果|whether the results or not
    %%----------------------------------------------------------------------------------------------
    if(showOrNot == "yes")
        % 数据处理| data processing
        %%.................................................................................
        [~, angle_max_sub] = max(curveofimage);                                  % 记录竖直取向度最大值的下标|record the subscript with the maximal ORI
        % 展示结果| show results
        I_rotate_max = imrotate(I,angle_max_sub,'bicubic','loose');                 % 记录竖直取向度最大的旋转后的原图像|Record the original image after rotation with the maximum V-ORI
        I_rotate_bin_max = Binary_method(I_rotate_max,parameters);              % 记录竖直取向度最大的旋转后二值化后的图像|Record the binarzation image after rotation with the maximum V-ORI
        figure;imshow(I_rotate_max);title('initial image');
        figure;imshow(I_rotate_bin_max);title('binarzation image');
        figure;plot(curveofimage);                                               % 展示竖直取向度曲线|show the curve of V-ORI
        %%................................................................................. 
    elseif(showOrNot == "no")
    else
        fprintf('Wrong!');
    end
     %%----------------------------------------------------------------------------------------------
end

