function [newImg] = homomorphicFilter(X,f_low,f_high,sigma)
% --------------------- 
% 作者：水木剑锋 
% 来源：CSDN 
% 原文：https://blog.csdn.net/sinat_34035510/article/details/51337266 
% 版权声明：本文为博主原创文章，转载请附上博文链接！


% f_high = 1.0;
% f_low = 0.8;
% sigma = 1.414

I = rgb2hsv(X);
H=I(:,:,1);
S=I(:,:,2);
V=I(:,:,3);

%?构造一个高斯滤波器

% f_high = 1.0;
% f_low = 0.8;

%?得到一个高斯低通滤波器
gauss_low_filter = fspecial('gaussian', [3 3], sigma);
matsize = size(gauss_low_filter);

%?由于同态滤波是要滤出高频部分,
%?所以得把这个低通滤波器转换成一个高通滤波器.
%?f_high?和?f_low?是控制这个高通滤波器形态的参数.
gauss_high_filter = zeros(matsize);
gauss_high_filter(ceil(matsize(1,1)/2) , ceil(matsize(1,2)/2)) = 1.0;
gauss_high_filter = f_high*gauss_high_filter - (f_high-f_low)*gauss_low_filter;

%?利用对数变换将入射光和反射光部分分开
log_img = log(double(V)+eps);

%?将高斯高通滤波器与对数转换后的图象卷积
high_log_part = imfilter(log_img, gauss_high_filter, 'symmetric', 'conv');

%?由于被处理的图象是经过对数变换的,再用幂变换将图象恢复过来
high_part = exp(high_log_part);
minv = min(min(high_part));
maxv = max(max(high_part));

%?得到的结果图象
temp=(high_part-minv)/(maxv-minv);
S=adapthisteq(S)*2.1;
HSV3(:,:,1)=H;%保留H不变，开始合成
HSV3(:,:,2)=S;
HSV3(:,:,3)=temp;
rgb2=hsv2rgb(HSV3);%转换回RGB空间

newImg = rgb2;

end
