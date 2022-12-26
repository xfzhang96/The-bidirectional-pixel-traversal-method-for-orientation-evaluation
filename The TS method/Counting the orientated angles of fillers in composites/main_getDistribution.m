% 项目中使用的粒子群优化算法版权声明| Copyright Notice for the Particle swarm Optimization algorithm used in this project
% Copyright (c) 2009-2016, S. Samuel Chen
% 本项目中使用的粒子群优化算法源码来自于SAM的Constrained Particle Swarm Optimization https://github.com/sdnchen/psomatlab
% Using Particle Swarm Optimization algorithm source code in this project from SAM “Constrained Particle Swarm Optimization” https://github.com/sdnchen/psomatlab 

% 为避免优化过程中参数溢出，在Constrained Particle Swarm Optimization项目中pso.m文件中412-418行加入了以下代码
% To avoid parameter overflow during Optimization, the following code was added to lines 412-418 of the pso.m file in the project of Constrained Particle Swarm Optimization 
%     % modified by zxf to aviod overflow
%     % ---------------------------------------------------------------------
%     for i=1:n 
%         state.Population(i,(state.Population(i,:)<LB))=LB(state.Population(i,:)<LB); 
%         state.Population(i,(state.Population(i,:)>UB))=UB(state.Population(i,:)>UB); 
%     end 
%     % ---------------------------------------------------------------------

% 建议：建议修改Constrained Particle Swarm Optimization项目中psooptimset.m文件中117行 options.UseParallel = 'never' 为 options.UseParallel = 'always' 开启并行计算提高速度
% Suggestions: It is recommended to change options.UseParallel = 'never' to options.UseParallel = 'always' at line 117 in the psooptimset.m file 
% in the project of Constrained Particle Swarm Optimization to enable parallel computing to improve speed 


% 使用前请修改本文件以及Weight_fitness.m中filename路径名称
% Before using the file, change the filename path name in this file and the Weight_fitness.m


% 找最优参数  亮度低值--parameters(1)  亮度高值--parameters(2)  二值化阈值--parameters(3)
% find the optimal parameter   Low brightness value--parameters(1)  High brightness value--parameters(2)  threshold for binarization--parameters(3) 

% 图像对比度、二值化阈值会影响竖直取向度曲线，曲线越光滑说明参数稳定性越高，可靠性越高，因此需要对【亮度低值，亮度高值，二值化阈值】进行优化
% Image contrast and binarization threshold will affect the vertical orientation curve. 
% The smoother the curve is, the higher the parameter stability and reliability will be. 
% Therefore, it is necessary to optimize [low brightness value, high brightness value, threshold for binarization] 

% 优化算法获取到的最优参数optimal_parameter仅作参考基准，具体参数仍然需要人工调整
% The optimal_parameter obtained from the optimization algorithm is only used as a reference. The specific parameter still need manaual adjustment.
% 当几张图片对比时，需保证图片对比度亮度等相近，所选参数optimal_parameter相近
% When comparing several images, please ensure that the contrast and brightness of the images are similar and that the selected parameter (optimal_parameter) is similar 
%%-----------------------------------------------------------------------------------------------------------------------------------------------
% [optimal_parameter, fval,exitflag,output,population,scores] = pso(@Weight_fitness,3,[],[],[],[],[0,0.51,10],[0.49,1,80]);
%%-----------------------------------------------------------------------------------------------------------------------------------------------
optimal_parameter = [0.05,0.85,5];
%%-----------------------------------------------------------------------------------------------------------------------------------------------
% 指定图像全路径|assign the full path of image
filename = 'E:\学习资料\研究生\科研\3D磁打印\3D打印实验\orientation algorithm\取向度文章\测试文章\示例图片\512.TIF';
% 根据the TS method 的验证,当颗粒去向角度为水平的时候评估更准确，为提高评估的准确度，需要将图像旋转至水平状态
% According the verfication, when the oriented angle of fillers is tend to be horizontal, the evaluation is more accurate. Hence, the image need to be rotated to be oriented horizontally to improve the accuracy of evalutaion
% The VOM method计算出来的取向角度|the oriented angle calculated by the VOM method
oriented_angle = 83;
% 计算应该旋转的角度|calculate the rotated angle according to the oriented angle
rotated_angle = 180 - oriented_angle;
% 读图片文件| read image
I = imread(filename); 
% 旋转图片|rotate image
I_rotate = imrotate(I,rotated_angle,'bicubic','loose');                         % 获得旋转rotated_angle度后图像矩阵| obtain the image matrix after rotating rotated_angle 

% 计算取向分布|calculate the distribution
angleofpixel = get_angleofpixel(I_rotate,optimal_parameter);

% 计算完后，需要将计算的取向分布转换为旋转前图像对应的取向角度分布|after calculation, the distribution need to be converted the distribution before rotation

























