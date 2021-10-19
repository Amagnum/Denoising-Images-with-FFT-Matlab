img1 = imread('cameraman.tif');
ft = fft2(img1);
f_s = fftshift(ft);

figure, imshow(log(1+f_s),[]);

img_test = 35*ones(256,256);

for i = 1:16:size(img_test,2)
    img_test(:,i:i+7) = -35;
end

figure, imshow(img_test);
test_ft = fft2(img_test);
figure, imshow(log(1+fftshift(test_ft)));

img_n = double(img1) + img_test;
figure, imshow(img_n,[]);
ft_n = fft2(img_n);

fs_n = fftshift(ft_n);

figure, imshow(log(1+fs_n),[]);

mag_fs = abs(fs_n);
f_max = max(mag_fs,[], 'all');

disp(f_orig);
fsb = im2bw(mag_fs./(f_max/30),1);

rc = 128;
cc = 128;

for i=1:256
    for j=1:256
        % Skipping the center we do not need to calculate it
        dist = sqrt((rc-i)^2+(cc-j)^2);
        if dist < 15
            fsb(i,j) = 0;
        end

        % Replace the rest of the values by the average in their perticular region
        if fsb(i,j)==1
                meean = mean(fs_n(max(i-2,0):min(i+2,256),max(0,j-2):min(256,j+2)),'all');
                fs_n(i,j) = meean;
        end 
    end
end

figure, imshow(log(1+fsb),[]);
figure, imshow(log(1+fs_n),[]);
figure, imshow(uint8(ifft2(ifftshift(fs_n))));

