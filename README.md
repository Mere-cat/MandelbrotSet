# **Mandelbrot Set Animation Generator**

408125029 王禮芳

## Execution

依序執行 `mandelbrot.m`, `genImg.m` 以及 `genVideo.m`



## Program Implementation

我將作業寫成三個程式：一是畫 mandelbort set，二是放大、resize 產生至少600張圖片，三是把這些圖片做成影片。

### 1. mandelbort.m

畫出最初始的 mandelbort set 底圖

```matlab
% 0. determine the times of iteration (600) 
maxIter = 700;

% 1. create the complex space from -2 to 2, seperated more than 5000
dx = 0.0007; % step -> seperate -2~2 into 5000 piece, each is 0.0008
x1 = -2;
x2 = 2;

dy = 0.0007;
y1 = -2;
y2 = 2;

x = x1:dx:x2;
y = y1:dy:y2;

[X,Y] = meshgrid(x,y);

c = X + 1i * Y; % the complex plane

% 2. Check the result of iteration
% (if the point is in the -2~2 circle)
z = zeros(size(c)); % store the iteration result
I = zeros(size(c)); % store the times a point survived from the check

for j = 1:maxIter
    z = z.^2 + c; % compute the iteration result for every points in the complex plane
    insider = abs(z) < 2; % insider is the point survived in the j-th iteration
    I(insider) = j; % mark it as the times of iteration it went through
end

imagesc(x,y,I);
colormap hot;
saveas(gcf, "original.png");
writematrix(I, "original.csv");
```

### 2. genImg.m

根據底圖，選定一點不斷放大、存成圖片，存滿總共 600 幀 mandelbort set 的持續放大圖片

```matlab
% set the coordinates
x1 = -2;
dx = 0.005; 
x2 = 2;

dy = 0.005;
y1 = -2;
y2 = 2;

x = x1:dx:x2;
y = y1:dy:y2;

origImg = readmatrix("original.csv");
cenX = 0.48;
cenY = 0.6;

for i = 1:630
    filename = "newfig" + i + ".csv";
    filenameNxt = "newfig" + (i+1) + ".csv";
    outputName = "img" + i + ".png";
    outputNameNxt = "img" + (i+1) + ".png";
    tmpNxt = "reSize/" + outputNameNxt;
    storeName = "result/" + outputNameNxt;

    % 3. zoom in the result graph
    imagesc(x,y,origImg)
    colormap hot
    xlim([(-2*(0.995^i))-tmpx (2*(0.995^i))-tmpx])
    ylim([(-2*(0.995^i))-tmpy (2*(0.995^i))-tmpy])
    axis square
    saveas(gcf, tmpNxt);
    
    % 4. upsample and resize the image
    b = imread(tmpNxt);
    sz = size(b);
    xg = 1:sz(1);
    yg = 1:sz(2);
    F = griddedInterpolant({xg,yg},double(b));

    xq = (0:5/10:sz(1))';
    yq = (0:5/10:sz(2))';
    vq = uint8(F({xq,yq}));
    imshow(vq);
    imresize(vq, [800 800]);
    imwrite(vq, storeName);
end
```

這裡我們建立兩個矩陣，矩陣 z 存放各點迭代後的結果，而 I 存放這個點經歷過的迭代次數：如果一個點中途不合格（迭代後的值超過半徑為二、中心在原點的的圓），那它的值也不會再更新。

### 3. genVideo.m

```matlab

video = VideoWriter('mandelbort.avi'); %create the video object
video.FrameRate = 10;
open(video); %open the file for writing

for ii=1:620 %where N is the number of images
    filename = "result/" + "img" + (ii+1) + ".png";
    I = imread(filename); %read the next image
    %I = imresize(I, [800 800]);
    writeVideo(video,I); %write the image to file
end

close(video); %close the file
```

將上一步產生的一幀幀圖片串起成為影片
