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