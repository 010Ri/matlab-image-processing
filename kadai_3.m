%
% 課題3のプログラム
%


image_h=256;              % 画像の高さ
image_w=256;              % 画像の幅
pixels=image_h*image_w;   % 画素数

gray_level_max= 255; %輝度値(最大値)
gray_level_min= 0; %輝度値(最小値)

input_file_name = 'sample2.dat';


%画像データの読み込み
fid=fopen(input_file_name,'r');

i_data = fread(fid,[image_w image_h],'uchar');

%縦横が逆転しているので，転置を取る．
i_data=i_data';


% プログラム(4)
tic
    i_data_temp=[i_data,i_data];
    i_data_temp=[i_data_temp;i_data_temp];
    %i_data_temp は，i_data を並べて作成した
    %大きさ 2 image_h × 2image_w の行列
    for k = 0:image_h-1
        for l = 0:image_w-1
            i_data_temp2 = i_data_temp(1+k:image_h+k,1+l:image_w+l);
            %i_data(1:image_h,1:image_w) から k,l ずれた画像
            temp = i_data.*i_data_temp2;
            ac(k+1,l+1) = mean(temp(:));
        end
    end
toc
% disp(ac);


% プログラム(5)
tic
    ac2 = ifft2(ps);
    ac2 = real(ac2)/(image_h*image_w);
toc
% disp(ac2);



%　プログラム(4), (5)の両者が一致しているか確認
dif = ac - ac2;
% disp(dif);

% plot(ac2);