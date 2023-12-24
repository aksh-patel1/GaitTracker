clear
% % Use a simple threshold to detect peaks (you may need to adjust the threshold)
% threshold = max(distances) * 0.9;
% peaks = distances > threshold;
load('blue_cyan_ribbon_tracker.mat')
distances = sqrt(sum((path - path(1, :)).^2, 2)); % Calculate Euclidean distance for each point to the starting point
% Get indices of peaks
% peak_indices = find(peaks);
peak_indices = 1:47:length(path);
% Extract individual cycles
cycles = cell(1, length(peak_indices)-1);
for i = 1:length(peak_indices)-1
    cycles{i} = path(peak_indices(i):peak_indices(i+1)-1, :);
end

% Plot individual cycles on an X-Y plot

for i = 1:length(cycles)
    figure(1)
    hold on;
    plot(cycles{i}(:, 1), cycles{i}(:, 2),'.k','MarkerSize',1);
    X(:,i)=cycles{i}(:, 1);
    Y(:,i)=cycles{i}(:, 2);
end
title('Individual Cycles');
xlabel('X Coordinate');
ylabel('Y Coordinate');
hold off

%% Detrend Data
figure(2)
for i=1:length(cycles)
    Xd(:,i)=filloutliers(smoothdata(X(:,i),'gaussian'),'nearest','mean');
    Yd(:,i)=filloutliers(smoothdata(Y(:,i),'gaussian'),'nearest','mean');
    plot(Xd(:,i),Yd(:,i),'.k','MarkerSize',3);
    hold on
end
% Compute the average cycle
avg_cycle(:,1) = mean(Xd(:,10:20), 2);
avg_cycle(:,2) = mean(Yd(:,10:20), 2);
% Plot the average cycle on an X-Y plot
figure(2)
hold on
plot(avg_cycle(:, 1), avg_cycle(:, 2),'ob','MarkerSize',8);
title('Average Cycle');
xlabel('X Coordinate');
ylabel('Y Coordinate');
