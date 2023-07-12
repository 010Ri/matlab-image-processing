%
% 課題4のプログラム
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
disp(fs);

% fsをfftshiftで再配置
shift_fs = fftshift(fs);

% 重みをつける
w = zeros(256);
% disp(w);
w(32:224, 32:224) = 1;
% w(64:192, 64:192) = 1;
% w(96:160, 96:160) = 1;
% w(112:144, 112:144) = 1;
% disp(w);

w_fs = w .* shift_fs;  % 要素同士の計算
% w_fs = w * shift_fs;  % こっちはだめ
% disp(w_fs)

% 配置を戻す
i_shift_fs = ifftshift(w_fs);

% 逆フーリエ変換
ifs = ifft2(i_shift_fs);
% disp(ifs);

% 複素数の実部をとる
o_data = real(ifs);

% 小数点を四捨五入
o_data = uint8(ifs);


%画像データの表示 -- 低域通過フィルタをかけた画像の表示
figure;
imshow(o_data,[gray_level_min gray_level_max]);
colormap(gray);
% title('Title');

