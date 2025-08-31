function analyze_results(cameraParams, reprojectionErrors)
%ANALYZE_RESULTS Analyze and visualize calibration results
% Inputs:
%   cameraParams - camera parameters object from calibration
%   reprojectionErrors - reprojection errors for each point

fprintf('4. Analyzing calibration results...\n');

if isempty(cameraParams)
    fprintf('   No calibration data to analyze.\n');
    return;
end

% Display camera parameters
fprintf('   === CAMERA PARAMETERS ===\n');
fprintf('   Focal Length (fx, fy): [%.2f, %.2f] pixels\n', ...
    cameraParams.FocalLength(1), cameraParams.FocalLength(2));
fprintf('   Principal Point (cx, cy): [%.2f, %.2f] pixels\n', ...
    cameraParams.PrincipalPoint(1), cameraParams.PrincipalPoint(2));
fprintf('   Radial Distortion (k1, k2): [%.6f, %.6f]\n', ...
    cameraParams.RadialDistortion(1), cameraParams.RadialDistortion(2));
fprintf('   Mean Reprojection Error: %.2f pixels\n', cameraParams.MeanReprojectionError);

% Analyze reprojection errors
if ~isempty(reprojectionErrors)
    fprintf('\n   === ERROR ANALYSIS ===\n');
    all_errors = reprojectionErrors(:);
    fprintf('   Max error: %.2f pixels\n', max(all_errors));
    fprintf('   Min error: %.2f pixels\n', min(all_errors));
    fprintf('   Std deviation: %.2f pixels\n', std(all_errors));
    
    % Plot error distribution
    figure('Name', 'Reprojection Error Analysis');
    subplot(2,1,1);
    histogram(all_errors, 20);
    title('Distribution of Reprojection Errors');
    xlabel('Error (pixels)');
    ylabel('Frequency');
    
    subplot(2,1,2);
    plot(all_errors, 'o-');
    title('Reprojection Errors by Point');
    xlabel('Point Index');
    ylabel('Error (pixels)');
    
    fprintf('   Error analysis plots generated.\n');
end

% Camera parameters visualization
figure('Name', 'Camera Parameters Visualization');
showExtrinsics(cameraParams);
title('Camera Extrinsics');

fprintf('   Analysis completed.\n');
end