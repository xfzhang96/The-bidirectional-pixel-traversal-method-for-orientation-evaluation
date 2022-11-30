filename = 'E:\学习资料\研究生\科研\3D磁打印\3D打印实验\orientation algorithm\取向度文章\测试文章\测试文章4\(a).jpeg';
I = imread(filename);
I = im2gray(I);
I = im2double(I);           % 将图像转换成为灰度double类型的图像
I_ord = I(1:440,1:600);     % 记录规整后的图像
[m,n] = size(I_ord);        
avenum_x = 4;               % 横向分的数量
avenum_y = 4;               % 纵向分的数量
img = zeros(m/avenum_x,n/avenum_y,avenum_x,avenum_y);   % 用于记录分出的图像块
oir_dir = zeros(2,avenum_x,avenum_y);                   % 1代表取向度 2代表取向方向
para2opt = [0,1,30];                                    % 计算取向度的参数
for i = 1:1:avenum_x
    for j = 1:1:avenum_y
        img(:,:,i,j) = I_ord((i-1)*(m/avenum_x)+1:i*(m/avenum_x),(j-1)*(n/avenum_y)+1:j*(n/avenum_y));
    end
end

figure;[ha, pos] = tight_subplot(avenum_x,avenum_y,[0.0001,0.0001],[0,0],[0,0]); % 绘制没有gap的subplot

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
        [curveofimage,roughness] = get_curvefimage(para2opt);
        [ori_dir(1,i,j),ori_dir(2,i,j)] = max(curveofimage);
    end
end





