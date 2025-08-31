%% Multi-Dataset Camera Calibration - Main Script
% Author: SezginDulkadir
% Date: 2025-08-31
% Description: Kamera kalibrasyonu için 4 farklı dataset kullanarak
%              dairesel hareket mekanizması verilerini analiz eder

clear; clc; close all;

%% Configuration
fprintf('=== Multi-Dataset Camera Calibration ===\n');
fprintf('Date: %s\n', datestr(now));

% Dataset paths
dataset_files = {
    'data/s1_calibration_data.mat',
    'data/s4_calibration_data.mat', 
    'data/s5_calibration_data.mat',
    'data/s6_calibration_data.mat'
};

% Image size (adjust according to your camera)
imageSize = [480, 640]; % [height, width] - Update this!

%% Step 1: Load all datasets
fprintf('\n1. Loading datasets...\n');
try
    [all_image_points, all_world_points, dataset_info] = load_all_datasets(dataset_files);
    fprintf('   ✓ Successfully loaded %d datasets\n', length(dataset_files));
    fprintf('   ✓ Total point pairs: %d\n', size(all_image_points, 1));
catch ME
    fprintf('   ✗ Error loading datasets: %s\n', ME.message);
    return;
end

%% Step 2: Prepare calibration data
fprintf('\n2. Preparing calibration data...\n');
try
    [imagePoints, worldPoints] = prepare_calibration_data(all_image_points, all_world_points);
    fprintf('   ✓ Image points prepared: %d sets\n', length(imagePoints));
    fprintf('   ✓ World points prepared: %d sets\n', length(worldPoints));
catch ME
    fprintf('   ✗ Error preparing data: %s\n', ME.message);
    return;
end

%% Step 3: Perform camera calibration
fprintf('\n3. Performing camera calibration...\n');
try
    [cameraParams, imagesUsed, estimationErrors] = perform_calibration(imagePoints, worldPoints, imageSize);
    fprintf('   ✓ Calibration completed successfully\n');
    fprintf('   ✓ Images used: %d/%d\n', sum(imagesUsed), length(imagesUsed));
catch ME
    fprintf('   ✗ Calibration failed: %s\n', ME.message);
    return;
end

%% Step 4: Analyze results
fprintf('\n4. Analyzing calibration results...\n');
try
    analyze_calibration_results(cameraParams, estimationErrors, dataset_info);
    fprintf('   ✓ Analysis completed\n');
catch ME
    fprintf('   ✗ Analysis failed: %s\n', ME.message);
end

%% Step 5: Save results
fprintf('\n5. Saving results...\n');
try
    save_calibration_results(cameraParams, estimationErrors, dataset_info);
    fprintf('   ✓ Results saved to results/ folder\n');
catch ME
    fprintf('   ✗ Save failed: %s\n', ME.message);
end

fprintf('\n=== Calibration Process Complete ===\n');
