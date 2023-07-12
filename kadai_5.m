%
% 課題5のプログラム
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

%fftshift でスペクトル配置を修正
fs = fftshift(fs);

%直流成分は fs(129,129) に存在
dcx=129;
dcy=129;
%直流成分は非常に値が大きいので，別に処理する．
dc = fs(dcx,dcy);
fs(dcx,dcy)=0;

%規格化 - フーリエスペクトルの最大値を 1 未満にする
fs_max = max(abs([real(fs(:)); imag(fs(:))]));
fs_max = 1.01*fs_max;
nfs = fs/fs_max;

% qにビットを割り当てる
q = zeros(256);

% 高域
q(1:256, 1:256) = 2^4;
% q(1:256, 1:256) = 2^8;

% 中域
q(43:213, 43:213) = 2^6;

% 低域
q(85:171, 85:171) = 2^8;
% q(85:171, 85:171) = 2^4;

% disp(q);


%ビット数を制限 - 左シフトして小数点以下を四捨五入する
qfs = round(nfs.*q);

%この処理で qfs の各要素は log2(q)+1（符号ビット）にビット数が制限される．
%このフーリエスペクトルを表す qfs のデータ量を減らすことによって画像を圧縮する．
%圧縮処理はここまで．

%以降は，圧縮後のデータ (qfs) から画像を再生し，原画像 (i_data)と比較するための処理．
% いかに少ないビット数の qfs で高画質の再生画像を得るかがポイント．
%右シフトしてさらに fs_max を乗じて qfs を元に戻す
qfs = qfs./q;
qfs = qfs*fs_max;

%退避していた直流成分を戻す
qfs(dcx,dcy)=dc;

%逆フーリエ変換
o_data = ifft2(ifftshift(qfs));

%実部のみを取り出す．
o_data = real(o_data);

%0～255 の 8 ビット（256 階調）に変換
o_data = uint8(o_data);

%o_data -> 再生画像
%MSE を算出する場合は，さらに double 型に変換する必要がある．
o_data = double(o_data);


%画像データの表示 -- 
figure;
imshow(o_data,[gray_level_min gray_level_max]);
colormap(gray);
% title('Title');

