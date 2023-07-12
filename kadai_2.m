%
% 課題2のプログラム
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

%　フーリエスペクトルを計算
fs = fft2(i_data);
% disp(fs);

%エネルギースペクトルを計算
ps = fs.*conj(fs);

%エネルギースペクトルの対数表示
figure;
mesh(log10(fftshift(ps)));
%座標軸を画像と揃える．
axis ij;


