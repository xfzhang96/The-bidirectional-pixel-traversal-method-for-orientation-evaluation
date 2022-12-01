% 这个文件用于获取图像旋转后的竖直取向度
% This file is used to obtain the V-ORI of the image after rotation

% 该函数（calculate_ori）接收二值化图像作为参数
% This function (calculate_ori) recevices the binarzation image
function orientation = calculate_ori(binary_img)
    % 参数初始化 parameter initalization
    %%----------------------------------------------------------------------------------------------
    x = 0;                                  % x方向数据累计|accumulated data in the x direction
    y = 0;                                  % y方向数据累计|accumulated data in the y direction
    boundary = 0;                           % 记录边界的数量|record the number of boundary
    white = 255;                            % 定义白块数值|define the value of white pixel
    [m,n] = size(binary_img);               % 获取数组大小|obtain the size of binary_image     
    interval = 0;                           % 记录间隔数量|record the number of interval
    interval_num = 2;                       % 可允许的间隔数量,当interval大于等于interval_num时，停止遍历|The number of allowable intervals,When interval is greater than or equal to interval num, stop the traversal
    %%----------------------------------------------------------------------------------------------
   
    % 遍历过程|the process of traverse
    %%----------------------------------------------------------------------------------------------
    for i = 1:m
        for j = 1:n
            if(binary_img(i,j) == white)
                % y方向向上计算
                try
                    for k = i+1:m
                        if(binary_img(k,j) == white)
                            y = y + 1;
                        else
                            interval = interval + 1;
                            if(interval == interval_num)
                                interval = 0;
                                break;
                            end
                        end
                    end
                catch  
                    boundary = boundary +1;     % 搜索到边缘|search to the edge
                end
              
% 由于对称性，可只计算一半，减少计算量，最后得出角度时，再考虑所有方向                
%                 % y方向向下计算
%                 try
%                     for k = i-1:-1:0
%                         if(binary_img(k,j) == white)
%                             y = y + 1;
%                         else
%                             interval = interval + 1;
%                             if(interval == interval_num)
%                                 interval = 0;
%                                 break;
%                             end
%                         end
%                     end
%                 catch
%                     boundary = boundary +1;     % 搜索到边缘|search to the edge
%                 end
                
                % x方向向右计算
                try
                    for l = j+1:n
                        if(binary_img(i,l) == white)
                            x = x + 1;
                        else
                            interval = interval + 1;
                            if(interval == interval_num)
                                interval = 0;
                                break;
                            end
                        end
                    end
                catch
                    boundary = boundary +1;     % 搜索到边缘|search to the edge
                end
                
% 由于对称性，可只计算一半，减少计算量，最后得出角度时，再考虑所有方向                
%                 % x方向向左计算
%                 try
%                     for l = j-1:-1:0
%                         if(binary_img(i,l) == white)
%                             x = x + 1;
%                         else
%                             interval = interval + 1;
%                             if(interval == interval_num)
%                                 interval = 0;
%                                 break;
%                             end
%                         end
%                     end
%                 catch
%                     boundary = boundary +1;     % 搜索到边缘|search to the edge
%                 end
                
                
            end
        end
    end
	%%----------------------------------------------------------------------------------------------

    % 计算竖直取向度|calculate V-ORI
    %%----------------------------------------------------------------------------------------------
    orientation = (1-x/y)*100;
	% fprintf('x/y is %4.4f, boundary is %d. ',x/y,boundary);
    %%----------------------------------------------------------------------------------------------
end

