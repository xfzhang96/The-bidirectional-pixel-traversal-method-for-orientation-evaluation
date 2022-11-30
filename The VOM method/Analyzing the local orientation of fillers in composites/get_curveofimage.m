function curveofimage = get_curveofimage (I,para2opt)
    %定义变量
    angle = 180;                                %旋转角度范围
    orientation = zeros(1,180);                 %每个角度计算出的竖直取向度数组

    
    %对每一张图片步进旋转180度计算其取向度，获得取向度曲线
    for i = 1:1:angle 
        I_rotate = imrotate(I,i,'bicubic','loose');                         %获得旋转i度后图像矩阵
        I_rotate_bin = Binary_method(I_rotate,para2opt);                    %获得二值化后图像矩阵
  
        % 由于图像识别稍有缺陷，需要对其进行修复
        % 方法为：将三面都为白块的黑块变成白块，将三面都为黑块的白块变为黑块
%         I_rotate_bin = repair_image(I_rotate_bin,255);
     
        orientation(i) = calculate_ori(I_rotate_bin); %计算取向度
               
        %输出每次旋转后计算的结果
%         fprintf('No.%1.0f: 取向度 is %4.4f%%\n',i,orientation(i));
        
    end
    
%     delete(gcp('nocreate'));
    
    %找最大值
%     [orientation_max, angle_max] = max(orientation);            %记录竖直取向度取向度最大值、最大的旋转角度

%     fprintf(datestr(clock));
%     fprintf(append(datestr(clock),'：-----  参数：[%6.4f，%6.4f，%6.2f],最大取向度：%6.4f%%，最大取向角度：%4.0f\n'),para2opt(1),para2opt(2),para2opt(3),orientation_max,angle_max);
    
% %     展示结果
%     I_rotate_max = imrotate(I,angle_max,'bicubic','loose');     %记录竖直取向度最大的旋转后的原图像
%     img_Enc = imadjust(I_rotate_max,[para2opt(1), para2opt(2)],[]);% 记录提高对比度后图片
%     I_rotate_bin_max = Binary_method(I_rotate_max,para2opt);    %记录竖直取向度最大的旋转后二值化后的图像
%     
%     % 由于图像识别稍有缺陷，需要对其进行修复
%     % 方法为：将三面都为白块的黑块变成白块，将三面都为黑块的白块变为黑块
%     I_rotate_bin_max = repair_image(I_rotate_bin_max,255);
%     
%     figure;imshow(I_rotate_max);title('原图');
%     figure;imshow(img_Enc);title('修改对比度后');
%     figure;imshow(I_rotate_bin_max);title('二值化后');
%     
%     figure;plot(orientation);

    curveofimage = orientation;
end

