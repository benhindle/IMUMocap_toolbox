function data = sync_all(data)
global JUMP_START_TIME JUMP_END_TIME

prox_to_peak_temp = find(data.proximalLowg(:, 3) == max(data.proximalLowg(JUMP_START_TIME:JUMP_END_TIME, 3)));
prox_to_peak = prox_to_peak_temp(1,1);

dist_to_peak_temp = find(data.distalLowg(:, 3) == max(data.distalLowg(JUMP_START_TIME:JUMP_END_TIME, 3)));
dist_to_peak = dist_to_peak_temp(1,1);

foot_to_peak_temp = find(data.footLowg(:, 3) == max(data.footLowg(JUMP_START_TIME:JUMP_END_TIME, 3)));
foot_to_peak = foot_to_peak_temp(1,1);

min_start = min([prox_to_peak, dist_to_peak, foot_to_peak]);
prox_start = prox_to_peak - min_start + 1;
dist_start = dist_to_peak - min_start + 1;
foot_start = foot_to_peak - min_start + 1;

min_end = min([length(data.proximalLowg(:, 3)) - prox_to_peak,...
    length(data.distalLowg(:, 3)) - dist_to_peak,...
    length(data.footLowg(:, 3)) - foot_to_peak]);

prox_end = (prox_start + min_start - 1) + min_end;
dist_end = (dist_start + min_start - 1) + min_end;
foot_end = (foot_start + min_start - 1) + min_end;

data.proximalHighg = data.proximalHighg(prox_start:prox_end, :);
data.proximalLowg = data.proximalLowg(prox_start:prox_end, :);
data.proximalMag = data.proximalMag(prox_start:prox_end, :);

data.distalHighg = data.distalHighg(dist_start:dist_end, :);
data.distalLowg = data.distalLowg(dist_start:dist_end, :);
data.distalMag = data.distalMag(dist_start:dist_end, :);

data.footHighg = data.footHighg(foot_start:foot_end, :);
data.footLowg = data.footLowg(foot_start:foot_end, :);
data.footMag = data.footMag(foot_start:foot_end, :);

data.distalLowg(:,1) = data.proximalLowg(:,1);
data.footLowg(:,1) = data.proximalLowg(:,1);
end