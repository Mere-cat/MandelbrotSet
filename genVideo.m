
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