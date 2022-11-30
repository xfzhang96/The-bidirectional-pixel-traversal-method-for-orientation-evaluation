% function [curveofimage,roughness] = Weight_fitness(para2opt)
function roughness = Weight_fitness(para2opt)
%文件位置
% filename = 'E:\学习资料\研究生\科研\3D磁打印\3D打印实验\orientation algorithm\取向度文章\测试文章\测试文章3\(a).jpeg';
% filename = 'E:\学习资料\研究生\科研\3D磁打印\3D打印实验\orientation algorithm\取向度文章\测试文章\示例图片\image_example.tif';
% filename = 'E:\学习资料\研究生\科研\3D磁打印\3D打印实验\orientation algorithm\取向度Matlab代码-优化--计算四个方向\对比\生成的大角度更多\理论\生成随机矩形的导出图.png';
filename = 'C:\Users\43816\Desktop\advanced materials文章评论\20：1.jpg';

curveofimage = get_curveofimage(filename,para2opt);      % [2.8,0.052,0.0001,1,......]  -->  x^0, x^1, x^2, x^3......
roughness = sum((curveofimage-smooth(curveofimage,0.1,"lowess")').^2);

%找最大值
[orientation_max, angle_max] = max(curveofimage);            %记录竖直取向度取向度最大值、最大的旋转角度


fprintf(append(datestr(clock),'：-----  参数：[%6.4f，%6.4f，%6.2f],最大取向度：%6.4f%%，最大取向角度：%4.0f，粗糙度：%6.4f。\n'),para2opt(1),para2opt(2),para2opt(3),orientation_max,angle_max,roughness);

%     写入txt
fileID = fopen('E:\学习资料\研究生\科研\3D磁打印\3D打印实验\orientation algorithm\取向度Matlab代码-优化--计算四个方向\代码\计算取向度\权重函数取常数 1\record.txt','a');
fprintf(fileID,datestr(clock));
fprintf(fileID,'：-----  参数：[%6.4f，%6.4f，%6.2f],最大取向度：%6.4f%%，最大取向角度：%4.0f，',para2opt(1),para2opt(2),para2opt(3),orientation_max,angle_max);
fprintf(fileID,'粗糙度：%6.4f。\n',roughness);
fclose(fileID);

end
