function save_results(cameraParams, reprojectionErrors, outputDir)
%SAVE_RESULTS Save calibration results to files
% Inputs:
%   cameraParams - camera parameters object from calibration
%   reprojectionErrors - reprojection errors for each point
%   outputDir - directory to save results (default: 'results/')

fprintf('5. Saving calibration results...\n');

if isempty(cameraParams)
    fprintf('   No calibration data to save.\n');
    return;
end

% Set default output directory
if nargin < 3
    outputDir = 'results/';
end

% Create output directory if it doesn't exist
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

try
    % Save camera parameters to MAT file
    matFile = fullfile(outputDir, 'camera_parameters.mat');
    save(matFile, 'cameraParams', 'reprojectionErrors');
    fprintf('   Camera parameters saved to: %s\n', matFile);
    
    % Save parameters to text file for easy viewing
    txtFile = fullfile(outputDir, 'camera_parameters.txt');
    fid = fopen(txtFile, 'w');
    if fid ~= -1
        fprintf(fid, 'CAMERA CALIBRATION RESULTS\n');
        fprintf(fid, '==========================\n\n');
        fprintf(fid, 'Focal Length (fx, fy): [%.4f, %.4f] pixels\n', ...
            cameraParams.FocalLength(1), cameraParams.FocalLength(2));
        fprintf(fid, 'Principal Point (cx, cy): [%.4f, %.4f] pixels\n', ...
            cameraParams.PrincipalPoint(1), cameraParams.PrincipalPoint(2));
        fprintf(fid, 'Radial Distortion (k1, k2): [%.8f, %.8f]\n', ...
            cameraParams.RadialDistortion(1), cameraParams.RadialDistortion(2));
        fprintf(fid, 'Mean Reprojection Error: %.4f pixels\n', cameraParams.MeanReprojectionError);
        fprintf(fid, '\nImage Size: [%d, %d] pixels\n', ...
            cameraParams.ImageSize(1), cameraParams.ImageSize(2));
        fclose(fid);
        fprintf('   Parameters summary saved to: %s\n', txtFile);
    end
    
    % Save reprojection errors if available
    if ~isempty(reprojectionErrors)
        errorFile = fullfile(outputDir, 'reprojection_errors.csv');
        csvwrite(errorFile, reprojectionErrors);
        fprintf('   Reprojection errors saved to: %s\n', errorFile);
    end
    
    fprintf('   All results saved successfully!\n');
    
catch ME
    fprintf('   Error saving results: %s\n', ME.message);
end

end
