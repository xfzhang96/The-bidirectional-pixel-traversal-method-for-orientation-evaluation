filename = 'E:\学习资料\研究生\科研\3D磁打印\3D打印实验\orientation algorithm\取向度文章\测试文章\测试文章4\(a).jpeg';
I = imread(filename);
I = im2gray(I);
I = im2double(I);           % 将图像转换成为灰度double类型的图像
I_ord = I(1:440,1:600);     % 记录规整后的图像
[m,n] = size(I_ord);        
avenum_x = 20;               % 纵向分的数量
avenum_y = 20;               % 横向分的数量
img = zeros(m/avenum_x,n/avenum_y,avenum_x,avenum_y);   % 用于记录分出的图像块
ori_dir = zeros(2,avenum_x,avenum_y);                   % 1代表取向度 2代表取向方向
para2opt = [0,1,30];                                    % 计算取向度的参数
for i = 1:1:avenum_x
    for j = 1:1:avenum_y
        img(:,:,i,j) = I_ord((i-1)*(m/avenum_x)+1:i*(m/avenum_x),(j-1)*(n/avenum_y)+1:j*(n/avenum_y));
    end
end

figure;[ha, ~] = tight_subplot(avenum_x,avenum_y,[0.001,0.001],[0,0],[0,0]); % 绘制没有gap的subplot

% 把每个图块依次展现出来
for i = 1:1:avenum_x
    for j = 1:1:avenum_y
        axes(ha((i-1)*avenum_y+j)); %#ok<LAXES>
        imshow(img(:,:,i,j));    
    end
end

% 计算每个图块取向度和方向
for i = 1:1:avenum_x
    for j = 1:1:avenum_y
        curveofimage = get_curveofimage(img(:,:,i,j),para2opt);
        [ori_dir(1,i,j),ori_dir(2,i,j)] = max(curveofimage);
    end
end

% figure;[ha, pos] = tight_subplot(avenum_x,avenum_y,[0.0001,0.0001],[0,0],[0,0]); % 绘制没有gap的subplot
for i = 1:1:avenum_x
    for j = 1:1:avenum_y
        if((0<=tand(ori_dir(2,i,j))) && (tand(ori_dir(2,i,j))<(n/avenum_y)/(m/avenum_x)))
            ar = annotation('arrow',[(j-0.5)/avenum_y-m*tand(ori_dir(2,i,j))/(2*avenum_x*n),(j-0.5)/avenum_y+m*tand(ori_dir(2,i,j))/(2*avenum_x*n)],[1-i/avenum_x,1-(i-1)/avenum_x]);
            ar.Color = 'red';
            ar.LineWidth = 2*ori_dir(1,i,j)/100;
            ar.HeadWidth = 10*ori_dir(1,i,j)/100;
        elseif((n/avenum_y)/(m/avenum_x)<=tand(ori_dir(2,i,j)))
            ar = annotation('arrow',[(j-1)/avenum_y,j/avenum_y],[(1-(i-0.5)/avenum_x-n/(2*avenum_y*tand(ori_dir(2,i,j))*m)),(1-(i-0.5)/avenum_x+n/(2*avenum_y*tand(ori_dir(2,i,j))*m))]);
            ar.Color = 'red';
            ar.LineWidth = 2*ori_dir(1,i,j)/100;
            ar.HeadWidth = 10*ori_dir(1,i,j)/100;
        elseif(tand(ori_dir(2,i,j))<-(n/avenum_y)/(m/avenum_x))
            ar = annotation('arrow',[(j-1)/avenum_y,j/avenum_y],[(1-(i-0.5)/avenum_x-n/(2*avenum_y*tand(ori_dir(2,i,j))*m)),(1-(i-0.5)/avenum_x+n/(2*avenum_y*tand(ori_dir(2,i,j))*m))]);
            ar.Color = 'red';
            ar.LineWidth = 2*ori_dir(1,i,j)/100;
            ar.HeadWidth = 10*ori_dir(1,i,j)/100;
        elseif((-(n/avenum_y)/(m/avenum_x)<=tand(ori_dir(2,i,j))) && (tand(ori_dir(2,i,j))<0))
            ar = annotation('arrow',[(j-0.5)/avenum_y+m*tand(ori_dir(2,i,j))/(2*avenum_x*n),(j-0.5)/avenum_y-m*tand(ori_dir(2,i,j))/(2*avenum_x*n)],[1-(i-1)/avenum_x,1-i/avenum_x]);
            ar.Color = 'red';
            ar.LineWidth = 2*ori_dir(1,i,j)/100;
            ar.HeadWidth = 10*ori_dir(1,i,j)/100;
        end
    end
end






