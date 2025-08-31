function [imagePoints, worldPoints] = prepare_calibration_data(all_image_points, all_world_points)
%PREPARE_CALIBRATION_DATA Prepare data for MATLAB calibration function
% Convert point arrays to cell arrays required by estimateCameraParameters

% Group points by image/frame
unique_frames = unique(all_image_points(:,1)); % assuming first column is frame ID
num_frames = length(unique_frames);

imagePoints = cell(1, num_frames);
worldPoints = cell(1, num_frames);

for i = 1:num_frames
    frame_id = unique_frames(i);
    frame_mask = all_image_points(:,1) == frame_id;
    
    % Extract image points (assuming columns 2-3 are x,y coordinates)
    imagePoints{i} = all_image_points(frame_mask, 2:3);
    
    % Extract world points (assuming columns 2-4 are x,y,z coordinates)
    worldPoints{i} = all_world_points(frame_mask, 2:4);
end

fprintf('   Prepared %d image sets\n', num_frames);
end
