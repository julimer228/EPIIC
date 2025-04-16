function combinations = create_params(varargin)
% create_params - function to create cell with all combinations of parameters
% varargin - parameters vectors
% returns params - cell with all avaliable combinations of the parameters
fields = fieldnames(varargin{1});

if isempty(fields)
    error('Provide at least one field in the structure.');
end

params = cell(length(fields), 1);
for i = 1:length(fields)
    params{i} = varargin{1}.(fields{i});
end

% Calculate the number of combinations
numCombinations = prod(cellfun(@length, params));

% Initialize cell with combinations
combinations = cell(numCombinations, 1);

% Generate combinations
idx = ones(1, length(fields));
for c = 1:numCombinations
    % Create structure for the current combination
    combination = struct;
    for p = 1:length(fields)
        fieldName = fields{p};
        value = params{p}(idx(p));
        combination.(fieldName) = value;
    end

    % Save the current combination in the cell
    combinations{c} = combination;

    % Update the indices
    for p = length(fields):-1:1
        if idx(p) < length(params{p})
            idx(p) = idx(p) + 1;
            break;
        else
            idx(p) = 1;
        end
    end
end
end