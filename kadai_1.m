%
% 課題1のプログラム
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

%　フーリエスペクトルを計算
fs = fft2(i_data);
% disp(fs);

% 逆フーリエ変換
ifs = ifft2(fs);
% disp(ifs);

% 複素数の実部をとる
o_data = real(ifs);

% 小数点を四捨五入
o_data = round(ifs);

dif = i_data - o_data;
disp(dif);


%画像データの表示 -- 原画像の表示
figure;
imshow(o_data,[gray_level_min gray_level_max]);
colormap(gray);
title('Title');


