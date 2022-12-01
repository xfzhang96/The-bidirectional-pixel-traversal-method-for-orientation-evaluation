% 这个文件用于构造优化目标函数
% This file is used to build the function for optimization

% 该函数（Weight_fitness）接收【亮度低值，亮度高值，二值化阈值】作为参数
% This function (Weight_fitness) recevices [low brightness, high brightness, threshold for binarization] as parameters
function roughness = Weight_fitness(para2opt)
    % 指定图像全路径|assign the full path of image
    filename = 'E:\学习资料\研究生\科研\3D磁打印\3D打印实验\orientation algorithm\取向度文章\测试文章\测试文章4\(a).jpeg';
    % 读图片文件| read image
    I = imread(filename); 
    % 获取竖直取向度曲线|obtain the curve of V-ORI
    curveofimage = get_curveofimage(I,para2opt,'no');
    % 计算曲线粗糙度作为优化目标|calculate the roughness of curve as the optimal object
    roughness = sum((curveofimage-smooth(curveofimage,0.1,"lowess")').^2);
    
    % 记录结果|record the results
    %%--------------------------------------------------------------------------------
    % 找竖直取向度曲线中的最大值作为图像取向度|find the maximum of V-ORI as the ORI
    [orientation_max, angle_max] = max(curveofimage);
    fprintf(append(datestr(clock),'：Parameter：[%6.4f,%6.4f,%6.2f]; ORI: %6.4f%%; oriented angle:%4.0f; roughness:%6.4f.\n'),para2opt(1),para2opt(2),para2opt(3),orientation_max,angle_max,roughness);
    %%--------------------------------------------------------------------------------

end
