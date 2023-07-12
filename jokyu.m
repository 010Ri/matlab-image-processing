%
% 上級課題のプログラム
%

image_h=256;              % 画像の高さ
image_w=256;              % 画像の幅
pixels=image_h*image_w;   % 画素数

gray_level_max= 255; %輝度値(最大値)
gray_level_min= 0; %輝度値(最小値)

input_file_name = 'sample1.dat';
fid=fopen(input_file_name,'r');

i_data = fread(fid,[image_w image_h],'uchar');
i_data=i_data';

fs = fft2(i_data);
fs = fftshift(fs);

dcx=129;
dcy=129;
dc = fs(dcx,dcy);
fs(dcx,dcy)=0;

fs_max = max(abs([real(fs(:)); imag(fs(:))]));
fs_max = 1.01*fs_max;
nfs = fs/fs_max;

% qにビットを割り当てる
q = zeros(256);

% 一番MSEが低くなる組み合わせを見つける
hml = [0, 0, 0];  % [高域, 中域, 低域]の添字を格納する配列
mse_min = 10000;  % MSEの最小値を格納する変数（初期値は適当）
for s = 0:18  % 高域に割り当てるビット数を0〜18まで変化
    % 高域
    q(1:256, 1:256) = 2^s;
    for t = 0:18  % 中域に割り当てるビット数を0〜18まで変化
        % 中域
        if s + t > 18
            continue
        else 
            q(43:213, 43:213) = 2^t;
        end

        for u = 0:18  % 低域に割り当てるビット数を0〜18まで変化
            % 低域
            if s + t + u == 18
                q(85:171, 85:171) = 2^u;
            else
                continue
            end

            qfs = round(nfs.*q);
            qfs = qfs./q;
            qfs = qfs*fs_max;
            qfs(dcx,dcy)=dc;
            
            o_data = ifft2(ifftshift(qfs));
            o_data = real(o_data);
            o_data = uint8(o_data);
            o_data = double(o_data);
            
            % MSEの計算
            sum = 0;
            for k = 1:image_h
                for l = 1:image_w
                    sum = sum + ( i_data(k,l) - o_data(k,l) )^2;
                end
            end
            mse = 1 / (image_h * image_w) * sum;
            if mse < mse_min
                mse_min = mse;
                hml(1) = s;
                hml(2) = t;
                hml(3) = u;
            end
            disp("[" + s + " , " + t + " , " + u + " ] " + " MSE : " + mse);
        end
    end
end
% MSEが最小となる組み合わせを表示
disp("MSEが最小となるビット数の組み合わせは・・・")
disp("高域 : " + hml(1) + " bit, 中域 : " + hml(2) + " bit, 低域 : " + hml(3) + " bit, " + " その時のMSEは : " + mse_min);


%画像データの表示 -- 
q(1:256, 1:256) = 2^hml(1);  % 高域
q(43:213, 43:213) = 2^hml(2);  % 中域
q(85:171, 85:171) = 2^hml(3);  % 低域
qfs = round(nfs.*q);
qfs = qfs./q;
qfs = qfs*fs_max;
qfs(dcx,dcy)=dc;
o_data = ifft2(ifftshift(qfs));
o_data = real(o_data);
o_data = uint8(o_data);
o_data = double(o_data);

figure;
imshow(o_data,[gray_level_min gray_level_max]);
colormap(gray);


