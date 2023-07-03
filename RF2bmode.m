clear;
clc;
load AScan20230614_211826
nerveroot_RF = AScan20230614_211826(1:14,:);
saveimage(nerveroot_RF,'nerveroot_example.jpg')
clear


function saveimage(nerveroot_RF,save_name)
for i =1:14
    x = nerveroot_RF(i,:);
    low = abs(min(min(x))-127.5);
    high = abs(max(max(x))-127.5);
    if low>high
        x(find(x<127.5-high))=127.5-high;
    else
        x(find(x>127.5+low))=127.5+low;
    end
    x = double(x);
    x = (x-127.5)/127.5;
    nerveroot(i,:) = x;
end
plot(nerveroot(9,:))
image_RF = 20*log10(abs(hilbert(nerveroot)));
image_RF = bilinear(image_RF,[140,500]);
imagesc(image_RF,[-40 0])

set(gcf,'Units','centimeters','Position',[16 16 20 4.8])
set(gca,'XTick',[])
set(gca,'YTick',[])
set(gca,'position',[0,0,1,1])
saveas(gca,save_name)
end

function output_img = bilinear(input_img,scale_size)
img = input_img;
[h,w] = size(img);
scale_w = scale_size(2);
scale_h = scale_size(1);
output_img = zeros(scale_h,scale_w);
for i = 1:scale_h
    for j = 1:scale_w
        x = i*h/scale_h;
        y = j*w/scale_w;
        u = x - floor(x);
        v = y - floor(y);
        if x < 1
            x = 1;
        end
        if y < 1
            y = 1;
        end
        
        output_img(i,j) = img(floor(x),floor(y))*(1-u)*(1-v)+...
            img(floor(x),ceil(y)) * (1-u) *v+...
            img(ceil(x),floor(y))* u * (1-v)+...
            img(ceil(x),ceil(y)) * u *v;
    end
end


end