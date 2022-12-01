% 这个文件用于获取输入图像旋转0°-179°后的竖直取向度
% This file is used to obtain the V-ORI of the input image after rotated from 0° to 179° 

% 该函数（get_curveofimage）接收图像数组和优化后的参数作为参数
% This function (get_curveofimage) recevices the name of image and optimizded parameters
function curveofimage = get_curveofimage_local (I,para2opt,showOrNot)
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
        I_rotate_bin = Binary_method(I_rotate,para2opt);                    % 获得二值化后图像矩阵| obtian the binarzation matrix
        orientation(i+1) = calculate_ori(I_rotate_bin);                     % 计算取向度| calculate the V-ORI
        % fprintf('No.%1.0f: 取向度 is %4.4f%%\n',i,orientation(i));           % 输出每次旋转后计算的结果| Output the results after each rotation 
    end
    %%----------------------------------------------------------------------------------------------
    
    % 是否展示旋转后结果|whether the results or not
    %%----------------------------------------------------------------------------------------------
    if(showOrNot == "yes")
        % 数据处理| data processing
        %%.................................................................................
        [~, angle_max] = max(orientation);                                      % 记录竖直取向度取向度最大值、最大的旋转角度
        % 展示结果| show results
        I_rotate_max = imrotate(I,angle_max,'bicubic','loose');                 % 记录竖直取向度最大的旋转后的原图像|Record the original image after rotation with the maximum V-ORI
        I_rotate_bin_max = Binary_method(I_rotate_max,para2opt);                % 记录竖直取向度最大的旋转后二值化后的图像|Record the binarzation image after rotation with the maximum V-ORI
        figure;imshow(I_rotate_max);title('initial image');
        figure;imshow(I_rotate_bin_max);title('binarzation image');
        figure;plot(orientation);                                               % 展示竖直取向度曲线|show the curve of V-ORI
        %%................................................................................. 
    elseif(showOrNot == "no")
    else
        fprintf('Wrong!');
    end
     %%----------------------------------------------------------------------------------------------

    curveofimage = orientation;
end

