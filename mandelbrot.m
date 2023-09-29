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