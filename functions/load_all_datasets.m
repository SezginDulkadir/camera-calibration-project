function [all_image_points, all_world_points, dataset_info] = load_all_datasets(dataset_files)
%LOAD_ALL_DATASETS Load calibration data from multiple .mat files
% Input: dataset_files - cell array of file paths
% Output: combined image points, world points, and dataset info

all_image_points = [];
all_world_points = [];
dataset_info = struct();

for i = 1:length(dataset_files)
    if exist(dataset_files{i}, 'file')
        fprintf('   Loading %s...\n', dataset_files{i});
        data = load(dataset_files{i});
        
        % Extract points (adjust field names as needed)
        if isfield(data, 'image_points') && isfield(data, 'world_points')
            all_image_points = [all_image_points; data.image_points];
            all_world_points = [all_world_points; data.world_points];
        else
            fprintf('   Warning: Expected fields not found in %s\n', dataset_files{i});
        end
        
dataset_info(i).filename = dataset_files{i};
dataset_info(i).points_count = size(data.image_points, 1);
    else
        fprintf('   Warning: File not found: %s\n', dataset_files{i});
    end
end

fprintf('   Total datasets loaded: %d\n', length(dataset_info));
end
