function [cameraParams, reprojectionErrors] = perform_calibration(imagePoints, worldPoints, imageSize)
%PERFORM_CALIBRATION Perform camera calibration using MATLAB's built-in function
% Inputs:
%   imagePoints - cell array of image point coordinates
%   worldPoints - cell array of world point coordinates  
%   imageSize - [height, width] of calibration images
% Outputs:
%   cameraParams - camera parameters object
%   reprojectionErrors - reprojection errors for each point

fprintf('3. Performing camera calibration...\n');

try
    % Estimate camera parameters
    [cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(...
        imagePoints, worldPoints, 'ImageSize', imageSize, ...
        'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
        'NumRadialDistortionCoefficients', 2);
    
    % Calculate reprojection errors
    reprojectionErrors = estimationErrors.ReprojectionErrors;
    
    % Display results
    fprintf('   Calibration completed successfully!\n');
    fprintf('   Mean reprojection error: %.2f pixels\n', cameraParams.MeanReprojectionError);
    fprintf('   Images used: %d/%d\n', sum(imagesUsed), length(imagesUsed));
    
catch ME
    fprintf('   Error during calibration: %s\n', ME.message);
    cameraParams = [];
    reprojectionErrors = [];
end

end
