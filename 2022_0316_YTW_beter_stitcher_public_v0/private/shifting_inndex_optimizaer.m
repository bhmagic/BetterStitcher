
tiling_info_xy = [tiling_info.x_tiles, tiling_info.y_tiles];
clear center_points
cnetertile_x = round(tiling_info.x_tiles./2);
cnetertile_y = round(tiling_info.y_tiles./2);

[center_points.x, center_points.y] = ind2sub(tiling_info_xy,find(ones(tiling_info.x_tiles, tiling_info.y_tiles)));

center_points.xxx = (center_points.x - cnetertile_x).*double(tiling_info.x_pixel - tiling_info.x_overlap);
center_points.yyy = (center_points.y - cnetertile_y).*double(tiling_info.y_pixel - tiling_info.y_overlap);



%%% stitching_queue
%%% shifting_key_full


%%% tiling_info.z_pixel tiling_info.x_pixel tiling_info.y_pixel
%%% tiling_info.x_overlap tiling_info.y_overlap
%%% tiling_info.x_tiles, tiling_info.y_tiles, ~, tiling_info.ch_num

%%% center_points shifting_key_full


for ii = 1:length(stitching_queue)
    tile_1_ind(ii) = sub2ind(tiling_info_xy,stitching_queue(ii).tile_1(1),stitching_queue(ii).tile_1(2));
    tile_2_ind(ii) = sub2ind(tiling_info_xy,stitching_queue(ii).tile_2(1),stitching_queue(ii).tile_2(2));
end

options = optimoptions(...
    'fminunc','MaxFunctionEvaluations',100000, ...
    'MaxIterations', 100000, ...
    'Display', 'off', ...
    'OptimalityTolerance', 1E-8, ...
    'StepTolerance', 1E-8, ...
    'FiniteDifferenceType', 'central'...
    );


%% x_y location

xxx_shift = zeros([length(center_points.x), tiling_info.z_pixel]);
yyy_shift = zeros([length(center_points.x), tiling_info.z_pixel]);

parfor zz = 1:tiling_info.z_pixel
    
    xy_shifting_0 = zeros(length(center_points.x)-1,2);

    shifting_key_temp = [];
    for ii = 1:length(stitching_queue)
        shifting_key_temp(ii,1) = shifting_key_full{ii}{1}(zz);
        shifting_key_temp(ii,2) = shifting_key_full{ii}{2}(zz);
    end
    
    calculating_error = @(xy_shifting) cal_err_sub_fn(xy_shifting, tile_2_ind, tile_1_ind, shifting_key_temp);

    xy_shifting = fminunc(calculating_error,xy_shifting_0,options);
    
    xy_shifting = [0 0 ;xy_shifting];
    xy_shifting = xy_shifting - xy_shifting(sub2ind(tiling_info_xy,cnetertile_x,cnetertile_y),:);
    
    xxx_shift(:,zz) = xy_shifting(:,1);
    yyy_shift(:,zz) = xy_shifting(:,2);
end



fititing_profile = 1/(1 + (length(zz_temp)./smooth_index).^3./6);
for ii = 1:size(xxx_shift,1)
    xxx_shift(ii,:) = csaps(zz_temp,xxx_shift(ii,:),fititing_profile,zz_temp);
    yyy_shift(ii,:) = csaps(zz_temp,yyy_shift(ii,:),fititing_profile,zz_temp);
end

center_points.xxx_shift = xxx_shift;
center_points.yyy_shift = yyy_shift;


figure;plot(center_points.xxx_shift','DisplayName','center_points.xxx_shift')
figure;plot(center_points.yyy_shift','DisplayName','center_points.yyy_shift')


%% z location






z_shifting_0 = zeros(length(center_points.x)-1,1);

shifting_key_temp = [];
for queue_id_temp = 1:length(stitching_queue)
    shifting_key_temp(queue_id_temp,1) = trform{queue_id_temp}(2);
end

calculating_error = @(z_shifting) cal_err_sub_z_fn(z_shifting, tile_2_ind, tile_1_ind, shifting_key_temp);

z_shifting = fminunc(calculating_error,z_shifting_0,options);

z_shifting = [0 ;z_shifting];
z_shifting = z_shifting - z_shifting(sub2ind(tiling_info_xy,cnetertile_x,cnetertile_y),:);


center_points.zzz_shifting = z_shifting;

