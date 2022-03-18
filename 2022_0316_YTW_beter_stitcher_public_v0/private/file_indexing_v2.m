

file_expression  = replace(file_expression ,'\','/');

file_expression_dir = replace(file_expression,'*XXXX*','*');
file_expression_dir = replace(file_expression_dir,'*YYYY*','*');
file_expression_dir = replace(file_expression_dir,'*ZZZZ*','*');
file_expression_dir = replace(file_expression_dir,'*CCCC*','*');

tif_list = dir(file_expression_dir);

file_names = {tif_list(:).name};
folder_names = {tif_list(:).folder};
for ii = 1: length(file_names)
    file_names{ii} = [folder_names{ii}, '/', file_names{ii}];
    file_names{ii}  = replace(file_names{ii} ,'\','/');
end


token_XX_rep = replace(file_expression , '*XXXX*','(\d+)');
token_XX_rep = replace(token_XX_rep,'*YYYY*','(\d+)');
token_XX_rep = replace(token_XX_rep,'*ZZZZ*','(\d+)');
token_XX_rep = replace(token_XX_rep,'*CCCC*','(\d+)');
token_XX = regexp(file_names,token_XX_rep,'tokens');

k_XX = strfind(file_expression,'*XXXX*');
k_YY = strfind(file_expression,'*YYYY*');
k_ZZ = strfind(file_expression,'*ZZZZ*');
k_CC = strfind(file_expression,'*CCCC*');

kk_sorted = sort([k_XX, k_YY, k_ZZ, k_CC]);


[~, k_XX_rank] = ismember(k_XX,kk_sorted);
[~, k_YY_rank] = ismember(k_YY,kk_sorted);
[~, k_ZZ_rank] = ismember(k_ZZ,kk_sorted);
[~, k_CC_rank] = ismember(k_CC,kk_sorted);

% for ii = 1:length(token_XX)
%     for jj= 1:length(token_XX{ii}{1})
%     token_XX{ii}{1}{jj} = str2num(token_XX{ii}{1}{jj});
%     end
%     token_XX{ii} = cell2mat(token_XX{ii}{1});
% end
% token_XX = cell2mat(token_XX');
for ii = 1:length(token_XX)
    token_XX{ii}= token_XX{ii}{1} ;
end
token_XX_2 = {};
for ii = 1:length(token_XX)
    token_XX_2(ii,:)= token_XX{ii};
end

unique_XX = unique(token_XX_2(:,k_XX_rank(1)));
unique_YY = unique(token_XX_2(:,k_YY_rank(1)));
unique_ZZ = unique(token_XX_2(:,k_ZZ_rank(1)));
unique_CC = unique(token_XX_2(:,k_CC_rank(1)));


tile_zero = replace(file_expression,'*XXXX*',unique_XX{1});
tile_zero = replace(tile_zero,'*YYYY*',unique_YY{1});
tile_zero = replace(tile_zero,'*ZZZZ*',unique_ZZ{1});
tile_zero = replace(tile_zero,'*CCCC*',unique_CC{1});

for ii = 1:length(unique_XX)
    for jj = 1:length(unique_YY)
        for kk = 1:length(unique_ZZ)
            for ll = 1:length(unique_CC)

                tile_in = replace(file_expression,'*XXXX*',unique_XX{1});
                tile_in = replace(tile_in,'*YYYY*',unique_YY{1});
                tile_in = replace(tile_in,'*ZZZZ*',unique_ZZ{1});
                tile_in = replace(tile_in,'*CCCC*',unique_CC{1});
                if isfile( tile_in)
                    read_file_name{ii,jj,kk,ll} = tile_in;
                else
                    warning(['file ', tile_in, ' do not exist, replacing with ',tile_zero ]);
                end
            end
        end
    end
end

% channel_for_stitching = channel_for_stitching+1;
[ tiling_info.x_tiles, tiling_info.y_tiles, tiling_info.z_pixel, tiling_info.ch_num ] = size(read_file_name);
% size(read_file_name)






