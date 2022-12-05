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
%%-----------------------------------------------------------------------------------------------------------------------------------------------
% [optimal_parameter, fval,exitflag,output,population,scores] = pso(@Weight_fitness,3,[],[],[],[],[0,0.51,10],[0.49,1,80]);
%%-----------------------------------------------------------------------------------------------------------------------------------------------
optimal_parameter = [0,1,30];

%%-----------------------------------------------------------------------------------------------------------------------------------------------
% 指定图像全路径|assign the full path of image
filename = 'E:\学习资料\研究生\科研\3D磁打印\3D打印实验\orientation algorithm\取向度文章\测试文章\示例图片\image_example.tif';
% 读图片文件| read image
I = imread(filename);                                                   

% 使用最佳参数计算取向度和取向角度|use the optimal parameter calculate the ORI and oriented angle
% 获取竖直取向度曲线|obtain the curve of V-ORI
curveofimage = get_curveofimage(I,optimal_parameter,'yes');
% 计算曲线粗糙度作为优化目标|calculate the roughness of curve as the optimal object
roughness = sum((curveofimage-smooth(curveofimage,0.1,"lowess")').^2);

% 记录结果|record the results
%%............................................................................................
% 找竖直取向度曲线中的最大值作为图像取向度|find the maximum of V-ORI as the ORI
[orientation_max, angle_max] = max(curveofimage);
fprintf(append(datestr(clock),'：Parameter：[%6.4f,%6.4f,%6.2f]; ORI: %6.4f%%; oriented angle:%4.0f; roughness:%6.4f.\n'),optimal_parameter(1),optimal_parameter(2),optimal_parameter(3),orientation_max,angle_max,roughness);
%%............................................................................................
%%-----------------------------------------------------------------------------------------------------------------------------------------------
