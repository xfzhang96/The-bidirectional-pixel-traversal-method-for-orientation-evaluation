%图像处理函数，接收旋转后的图像信息作为参数。
function binary_img = Binary_method(img,para2opt)
    %参数初始化
%     origin_img = img;             % 保留原始矩阵

    img = imadjust(img,[para2opt(1), para2opt(2)],[]);% 提高对比度
    img = im2gray(img);
    img = im2double(img);           % 将图像转换成为灰度double类型的图像
    [m,n]=size(img);                % 得到图像大小行m，列n
    log_margin = zeros(m,n);        % 初始化log_margin矩阵
    smooth = zeros(m,n);            % 初始化smooth矩阵
    
    
    
    % 先滤波一次
    img = imfilter(img,fspecial('average',[3,3]),'replicate');
%     figure; 
%     imshow(img);
%     title('先滤波一次');
    
    
    %边缘提取
    for i=3:m-2
        for j=3:n-2		% 计算区域从图像(3,3)开始，到(m-2,n-2)结束
            % LoG算子粗提取图像边缘
            log_margin(i,j) = -img(i-2,j)-img(i-1,j-1)-2*img(i-1,j)-img(i-1,j+1)-img(i,j+2)-2*img(i,j-1)+16*img(i,j)-2*img(i,j+1)-img(i,j+2)-img(i+1,j-1)-2*img(i+1,j)-img(i+1,j+1)-img(i+2,j);
        end
    end
%     figure;
%     imshow(log_margin);
%     title('LoG算子提取图像边缘');

    
    %如果不提取边缘，直接用于下面滤波和二值化
    % log_margin = img; 

    % 均值滤波处理
    for i=2:m-1
        for j=2:n-1
            % LoG算子粗提取边缘后，进行均值滤波去除噪声（3x3范围）
            smooth(i,j) = (log_margin(i-1,j-1)+log_margin(i-1,j)+log_margin(i-1,j+1)+log_margin(i,j-1)+log_margin(i,j)+log_margin(i,j+1)+log_margin(i+1,j-1)+log_margin(i+1,j)+log_margin(i+1,j+1))/9;
        end
    end
%     figure;
%     imshow(smooth);
%     title('均值滤波处理后');
%    这个就是均值滤波，和上面的一样 smooth = log_margin; smooth = imfilter(smooth,fspecial('average',[3,3]),'replicate');
    
            

    % 二值化处理
    binary_img = im2uint8(smooth);  % 将均值滤波后的图像转换为uint8类型图像，即图像色彩范围[0,255]
    for i=1:m
        for j=1:n
            if binary_img(i,j)>para2opt(3)  % 设置二值化的阈值为 para2opt(3)
                binary_img(i,j) = 255;  % 超过阈值的设为白点
            else
                binary_img(i,j) = 0;    %小于阈值的设为黑点
            end
        end
    end
%     figure;
%     imshow(binary_img);
%     title('滤波后，二值化处理后');

end
