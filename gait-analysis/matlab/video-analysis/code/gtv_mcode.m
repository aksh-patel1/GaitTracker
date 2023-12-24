% Load the video file (adjust the file path as needed)
videoFile = 'gtv.mp4'; % Specify the path to your video file
vidObj = VideoReader(videoFile);

% Initialize variables
path = [];

% Define the blue-cyan color range in HSV
lower_blue_cyan = [0.4, 0.3, 0.3]; % Adjust these values based on your ribbon's color
upper_blue_cyan = [0.6, 1.0, 1.0];

% Read each frame and process it
while hasFrame(vidObj)
    frame = readFrame(vidObj);

    % Convert the frame to HSV color space
    hsv_frame = rgb2hsv(frame);

    % Create a binary mask for blue-cyan color
    mask = (hsv_frame(:,:,1) >= lower_blue_cyan(1)) & (hsv_frame(:,:,1) <= upper_blue_cyan(1)) & ...
           (hsv_frame(:,:,2) >= lower_blue_cyan(2)) & (hsv_frame(:,:,2) <= upper_blue_cyan(2)) & ...
           (hsv_frame(:,:,3) >= lower_blue_cyan(3)) & (hsv_frame(:,:,3) <= upper_blue_cyan(3));

    % Find connected components in the mask
    cc = bwconncomp(mask);

    if cc.NumObjects > 0
        % Calculate the centroid of the largest blue-cyan region
        stats = regionprops(cc, 'Centroid');
        centroids = cat(1, stats.Centroid);
        blue_cyan_coords = round(centroids(1,:));

        % Store the coordinates
        path = [path; blue_cyan_coords];

        % Draw the path on the frame
        %frame = insertShape(frame, 'Line', path, 'Color', 'red', 'LineWidth', 2);
    end

    % Display the frame with the traced path
    %imshow(frame);
    %drawnow;
end

% Display the traced path
figure;
plot(path(:, 1), path(:, 2), 'bo', 'LineWidth', 2);
title('Traced Path of Blue-Cyan Ribbon');
xlabel('X Coordinate');
ylabel('Y Coordinate');

% Release the video object
clear vidObj;
