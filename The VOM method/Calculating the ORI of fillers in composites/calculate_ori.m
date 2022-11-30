
function orientation = calculate_ori(binary_img)

    %参数初始化
    x = 0;                                  % x方向数据累计
    y = 0;                                  % y方向数据累计
    boundary = 0;                           % 边界为0的数量
    white = 255;                            % 记录白块数值
    [m,n] = size(binary_img);               % 计算数组大小     
    interval = 0;                           % 记录间隔数量
    interval_num = 2;                       % 当interval大于等于interval_num时，停止遍历
%     weight_function_result = 0;           % 权重函数计算结果
    num = 0;
    for i = 1:m
        for j = 1:n
            if(binary_img(i,j) == white)
                % y方向向上计算
                try
                    for k = i+1:m
                        if(binary_img(k,j) == white)
                            % weight_function_result = weight_function_par * bsxfun(@power,num,[0:length(weight_function_par)-1])';%计算时间过长
                            y = y + 1;
                            num = num + 1;
                        else
                            interval = interval + 1;
                            if(interval == interval_num)
                                num = 0;
                                interval = 0;
                                break;
                            end
                        end
                    end
                catch ME
                    boundary = boundary +1;
                end
              
% 由于对称性，可只计算一半，减少计算量，最后得出角度时，再考虑所有方向                
%                 % y方向向下计算
%                 try
%                     for k = i-1:-1:0
%                         if(binary_img(k,j) == white)
%                             % weight_function_result = weight_function_par * bsxfun(@power,num,[0:length(weight_function_par)-1])';%计算时间过长
%                             y = y + 1;
%                             num = num + 1;
%                         else
%                             interval = interval + 1;
%                             if(interval == interval_num)
%                                 num = 0;
%                                 interval = 0;
%                                 break;
%                             end
%                         end
%                     end
%                 catch ME
%                     boundary = boundary +1;
%                 end
                
                % x方向向右计算
                try
                    for l = j+1:n
                        if(binary_img(i,l) == white)
                            % weight_function_result = weight_function_par * bsxfun(@power, num,[0:length(weight_function_par)-1])';%计算时间过长
                            x = x + 1;
                            num = num + 1;
                        else
                            interval = interval + 1;
                            if(interval == interval_num)
                                num = 0;
                                interval = 0;
                                break;
                            end
                        end
                    end
                catch ME
                    boundary = boundary +1;
                end
                
% 由于对称性，可只计算一半，减少计算量，最后得出角度时，再考虑所有方向                
%                 % x方向向左计算
%                 try
%                     for l = j-1:-1:0
%                         if(binary_img(i,l) == white)
%                             % weight_function_result = weight_function_par * bsxfun(@power, num,[0:length(weight_function_par)-1])';%计算时间过长
%                             x = x + 1;
%                             num = num + 1;
%                         else
%                             interval = interval + 1;
%                             if(interval == interval_num)
%                                 num = 0;
%                                 interval = 0;
%                                 break;
%                             end
%                         end
%                     end
%                 catch ME
%                     boundary = boundary +1;
%                 end
                
                
            end
        end
    end
    orientation = (1-x/y)*100;
%     fprintf('x/y is %4.4f, boundary is %d. ',x/y,boundary);
end

