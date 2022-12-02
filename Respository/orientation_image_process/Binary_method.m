% 这个文件用于将图像转换为二值化图像
% This file is used to convert the image to the binarized image

% 该函数（Binary_method）接收旋转后的图像信息和优化后的参数作为参数
% This function (Binary_method) recevices the rotated image and optimized parameters
function binary_img = Binary_method(img,para2opt)
    % 参数初始化 parameter initalization
    %%----------------------------------------------------------------------------------------------
    img = imadjust(img,[para2opt(1), para2opt(2)],[]);              % 改变图像对比度| change the contrast of image
    img = im2gray(img);                                             % 将图像转为灰度图| convert the image to grayscale
    img = im2double(img);                                           % 将图像转double类型| convert the image to double type
    [m,n]=size(img);                                                % 获取图像大小（行:m, 列:n）| obtain the size of image(row:m, cloumn:n)
    log_margin = zeros(m,n);                                        % 初始化log_margin| init log_margin
    %%----------------------------------------------------------------------------------------------

    
    % 图像处理| picture processing
    %%----------------------------------------------------------------------------------------------
    %%......................................................................
    % 第一次滤波降低干扰信号影响| The first filtering for reducing the impact of interference signals
    img = imfilter(img,fspecial('average',[3,3]),'replicate');
    % figure;imshow(img);title('The first filtering');
    %%......................................................................
    
    %%......................................................................
    % 用log算子进行边缘提取| Edge extraction with log operator
    for i=3:m-2
        for j=3:n-2                         % 计算区域从图像(3,3)开始，到(m-2,n-2)结束| The calculation area starts with images (3,3) and ends with images (m-2,n-2)
            log_margin(i,j) = -img(i-2,j)-img(i-1,j-1)-2*img(i-1,j)-img(i-1,j+1)-img(i,j+2)-2*img(i,j-1)+16*img(i,j)-2*img(i,j+1)-img(i,j+2)-img(i+1,j-1)-2*img(i+1,j)-img(i+1,j+1)-img(i+2,j);
        end
    end
    %  figure;imshow(log_margin);title('Edge extraction with log operator');
    %%......................................................................

    %%......................................................................
    % 第二次滤波| The second filtering
    smooth = imfilter(log_margin,fspecial('average',[3,3]),'replicate');
    % figure;imshow(smooth);title('The second filtering');
    %%......................................................................
    
    %%......................................................................   
    % 二值化处理| binarization processing
    binary_img = im2uint8(smooth);          % 将均值滤波后的图像转换为uint8类型图像，即图像色彩范围[0,255]| This image is converted to uint8 type image which is image color range [0,255] 
    for i=1:m
        for j=1:n
            if binary_img(i,j)>para2opt(3)  % 设置二值化的阈值为 para2opt(3)| Set the threshold for binarization to para2opt(3)
                binary_img(i,j) = 255;      % 超过阈值的设为白块|set the pixel to be white when exceeds the threshold
            else
                binary_img(i,j) = 0;        % 未超过阈值的设为黑块|set the pixel to be black when not exceeds the threshold
            end
        end
    end
    % figure;imshow(binary_img);title('binarization image');
    %%......................................................................   
    %%----------------------------------------------------------------------------------------------

end
