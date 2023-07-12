%
% 与えられた画像データを読み込み，画面に表示するプログラム
%
%

image_h=256;              % 画像の高さ
image_w=256;              % 画像の幅
pixels=image_h*image_w;   % 画素数

gray_level_max= 255; %輝度値(最大値)
gray_level_min= 0; %輝度値(最小値)

input_file_name = 'sample1.dat';


%画像データの読み込み
fid=fopen(input_file_name,'r');

i_data = fread(fid,[image_w image_h],'uchar');

%縦横が逆転しているので，転置を取る．
i_data=i_data';

%画像データの表示 -- 原画像の表示
figure;
imshow(i_data,[gray_level_min gray_level_max]);
colormap(gray);
title('Title');
