% 项目中使用的tight_subplot函数版权声明| Copyright Notice for the tight_subplot function used in this project
% Copyright (c) 2016, Pekka Kumpulainen
% 本项目中使用的tight_subplot函数源码来自于Pekka Kumpulainen https://www.mathworks.com/matlabcentral/fileexchange/27991-tight_subplot-nh-nw-gap-marg_h-marg_w
% The tight_subplot function used in this project is sourced from Pekka Kumpulainen https://www.mathworks.com/matlabcentral/fileexchange/27991-tight_subplot-nh-nw-gap-marg_h-marg_w

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
% 为了保证整除，请自行结合等分数量和图像数组大小改变I_ordered大小
% To ensure divisible, please change the I_ordered size according to the number of bisections and the image array size 


% 找最优参数  亮度低值--para2opt(1)  亮度高值--para2opt(2)  二值化阈值--para2opt(3)
% find the optimal parameter   Low brightness value--para2opt(1)  High brightness value--para2opt(2)  threshold for binarization--para2opt(3) 

% 图像对比度、二值化阈值会影响竖直取向度曲线，曲线越光滑说明参数稳定性越高，可靠性越高，因此需要对【亮度低值，亮度高值，二值化阈值】进行优化
% Image contrast and binarization threshold will affect the vertical orientation curve. 
% The smoother the curve is, the higher the parameter stability and reliability will be. 
% Therefore, it is necessary to optimize [low brightness value, high brightness value, threshold for binarization] 
%%-----------------------------------------------------------------------------------------------------------------------------------------------
[optimal_parameter, fval,exitflag,output,population,scores] = pso(@Weight_fitness,3,[],[],[],[],[0,0.51,10],[0.49,1,80]);
%%-----------------------------------------------------------------------------------------------------------------------------------------------

% 参数初始化 parameter initalization
%%-----------------------------------------------------------------------------------------------------------------------------------------------
% 指定图像全路径|assign the full path of image
filename = 'E:\学习资料\研究生\科研\3D磁打印\3D打印实验\orientation algorithm\取向度文章\测试文章\测试文章4\(a).jpeg';
% 读图片文件| read image
I = imread(filename);
I = im2gray(I);                                         % 将图像转为灰度图| convert the image to grayscale
I = im2double(I);                                       % 将图像转double类型| convert the image to double type
% 需要根据不同的图修改|need modify according to different images
% .................................................................
I_ordered = I(1:440,1:600);                             % 记录规整后的图像| record the ordered image
avenum_x = 20;                                          % 纵向等分的数量| the number of image block in vertical direction
avenum_y = 20;                                          % 横向等分的数量| the number of image block in horizontal direction
% .................................................................
[m,n] = size(I_ordered);   
img = zeros(m/avenum_x,n/avenum_y,avenum_x,avenum_y);   % 用于记录分出的图像块| used to record the image blocks which has been extracted
ori_dir = zeros(2,avenum_x,avenum_y);                   % 三维数组，ori_dir(1,::)代表取向度 ori_dir(2,::)代表取向方向 | Three-dimensional array, ori_dir(1,::) represents the ORI and ori_dir(1,::) represents the oriented angle
%%-----------------------------------------------------------------------------------------------------------------------------------------------

% 提取图像块|extract image blocks
%%-----------------------------------------------------------------------------------------------------------------------------------------------
for i = 1:1:avenum_x
    for j = 1:1:avenum_y
        img(:,:,i,j) = I_ordered((i-1)*(m/avenum_x)+1:i*(m/avenum_x),(j-1)*(n/avenum_y)+1:j*(n/avenum_y));
    end
end
%%-----------------------------------------------------------------------------------------------------------------------------------------------
figure;[handle_subplot, ~] = tight_subplot(avenum_x,avenum_y,[0.001,0.001],[0,0],[0,0]); % 绘制没有gap的subplot|Plot subplots without gap 

% 展现所有图像块|show all imgae blocks
%%-----------------------------------------------------------------------------------------------------------------------------------------------
for i = 1:1:avenum_x
    for j = 1:1:avenum_y
        axes(handle_subplot((i-1)*avenum_y+j)); %#ok<LAXES>
        imshow(img(:,:,i,j));    
    end
end
%%-----------------------------------------------------------------------------------------------------------------------------------------------

% 计算每个图块取向度和方向|calculate the ORI and oriented angles of all image blocks
%%-----------------------------------------------------------------------------------------------------------------------------------------------
for i = 1:1:avenum_x
    for j = 1:1:avenum_y
        curveofimage = get_curveofimage(img(:,:,i,j),optimal_parameter,"no");
        [ori_dir(1,i,j),ori_dir(2,i,j)] = max(curveofimage);
    end
end
%%-----------------------------------------------------------------------------------------------------------------------------------------------

%%-----------------------------------------------------------------------------------------------------------------------------------------------
% 绘制箭头|draw arrows
plotarrow(m,n,avenum_x,avenum_y,ori_dir);
% 绘制空图框|draw an empty picture box
figure;[handle_subplot, ~] = tight_subplot(avenum_x,avenum_y,[0.0001,0.0001],[0,0],[0,0]); % 绘制没有gap的subplot
% 绘制箭头|draw arrows
plotarrow(m,n,avenum_x,avenum_y,ori_dir);
%%-----------------------------------------------------------------------------------------------------------------------------------------------



% 该函数用于根据取向角度和取向度在每个图像块上绘制相应的箭头
% this function the corresponding arrows in all image blocks according to the ORI and oriented angles
function plotarrow = plotarrow(m,n,avenum_x,avenum_y,ori_dir) %#ok<STOUT>
    for i = 1:1:avenum_x
        for j = 1:1:avenum_y
            if((0<=tand(ori_dir(2,i,j))) && (tand(ori_dir(2,i,j))<=(m/avenum_x)/(n/avenum_y)))
                ar = annotation('arrow',[(j-1)/avenum_y,j/avenum_y],[(1-(i-0.5)/avenum_x-tand(ori_dir(2,i,j))*n/(2*avenum_y*m)),(1-(i-0.5)/avenum_x+tand(ori_dir(2,i,j))*n/(2*avenum_y*m))]);
                ar.Color = 'red';
                ar.LineWidth = 2*ori_dir(1,i,j)/100;
                ar.HeadWidth = 10*ori_dir(1,i,j)/100;
            elseif(tand(ori_dir(2,i,j))>(m/avenum_x)/(n/avenum_y))
                ar = annotation('arrow',[(j-0.5)/avenum_y-m/(2*avenum_x*n*tand(ori_dir(2,i,j))),(j-0.5)/avenum_y+m/(2*avenum_x*n*tand(ori_dir(2,i,j)))],[1-i/avenum_x,1-(i-1)/avenum_x]);
                ar.Color = 'red';
                ar.LineWidth = 2*ori_dir(1,i,j)/100;
                ar.HeadWidth = 10*ori_dir(1,i,j)/100;
            elseif(tand(ori_dir(2,i,j))<-(m/avenum_x)/(n/avenum_y))
                ar = annotation('arrow',[(j-0.5)/avenum_y+m/(2*avenum_x*n*tand(ori_dir(2,i,j))),(j-0.5)/avenum_y-m/(2*avenum_x*n*tand(ori_dir(2,i,j)))],[1-(i-1)/avenum_x,1-i/avenum_x]);
                ar.Color = 'red';
                ar.LineWidth = 2*ori_dir(1,i,j)/100;
                ar.HeadWidth = 10*ori_dir(1,i,j)/100;
            elseif((-(m/avenum_x)/(n/avenum_y)<=tand(ori_dir(2,i,j))) && (tand(ori_dir(2,i,j))<0))
                ar = annotation('arrow',[(j-1)/avenum_y,j/avenum_y],[(1-(i-0.5)/avenum_x-tand(ori_dir(2,i,j))*n/(2*avenum_y*m)),(1-(i-0.5)/avenum_x+tand(ori_dir(2,i,j))*n/(2*avenum_y*m))]);
                ar.Color = 'red';
                ar.LineWidth = 2*ori_dir(1,i,j)/100;
                ar.HeadWidth = 10*ori_dir(1,i,j)/100;
            end
        end
    end
end








