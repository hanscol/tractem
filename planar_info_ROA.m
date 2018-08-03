clear all;
close all;
clc;

exDir              = '/home-local/bayrakrg/Dropbox*VUMC*/complete_BLSA_subjects';
subjectDir = fullfile(exDir, '*');
sub = fullfile(subjectDir, '*');  
subDir = dir(fullfile(subjectDir, '*'));
addpath('/home-nfs/masi-shared-home/home/local/VANDERBILT/bayrakrg/masimatlab/trunk/users/bayrakrg:')
tractList = {'anterior_commissure';'anterior_corona_radiata';'anterior_limb_internal_capsule';'body_corpus_callosum';'cerebral_peduncle'; ...
'cingulum_cingulate_gyrus';'cingulum_hippocampal';'corticospinal_tract';'fornix';'fornix_stria_terminalis';'frontal_lobe';'genu_corpus_callosum';...
'inferior_cerebellar_peduncle';'inferior_fronto_occipital_fasciculus';'inferior_longitundinal_fasciculus';'medial_lemniscus';'midbrain';...
'middle_cerebellar_peduncle';'occipital_lobe';'olfactory_radiation';'optic_tract';'parietal_lobe';'pontine_crossing_tract';'posterior_corona_radiata';...
'posterior_limb_internal_capsule';'posterior_thalamic_radiation';'sagittal_stratum';'splenium_corpus_callosum';'superior_cerebellar_peduncle';...
'superior_corona_radiata';'superior_fronto_occipital_fasciculus';'superior_longitundinal_fasciculus';'tapetum_corpus_callosum';'temporal_lobe';'uncinate_fasciculus'};

% exclude folder if not in the tractList
filenames = cellstr(char(subDir.name));
tracts = false(length(subDir),1);
tracts(ismember(filenames,tractList)) = true;
subDir = subDir(tracts);

namePlot = [];
for d = 4:length(tractList)
%     one tract
    mask_tract = strcmp({subDir.name}, tractList(d));
    spec_tract = subDir(mask_tract);
    coords = {};
    for l = 1:length(spec_tract)
        spec_tract_dir = dir(fullfile([spec_tract(l).folder,'/', spec_tract(l).name, '/*ROI*.nii.gz']));
        if length(spec_tract_dir) ~= 0
            if length(strfind(spec_tract_dir(1).name,'_')) == 1
                nifty = load_density(spec_tract_dir);
                clear size;
                % find the ones in mask
                idx = find(nifty == 1);
                [x, y, z] = ind2sub(size(nifty), idx); %get the location of the ones 
                coord = [x, y, z];
                s = scatter3(x,y,z, 'filled');
                xlabel('Sagital')
%                 xlim([0 156])
                ylabel('Coronal')
%                 ylim([0 189])
%                 zlim([0 157])
                zlabel('Axial')
                hold on;
                coords{l} = coord;
                parts = strsplit(spec_tract(l).folder, '/');
                dirPart = parts{end};
                namePlot = [namePlot convertCharsToStrings(dirPart)];
                namePlot = strrep(namePlot,'_',' ');

            elseif length(strfind(spec_tract_dir(1).name,'_')) == 2
                if length(spec_tract_dir) == 2 % ignoring
                    if length(strfind(spec_tract_dir(1).name,'_L_')) == 1
                        spec_tract_dir_L = dir(fullfile([spec_tract(l).folder,'/', spec_tract(l).name, '/*_L_ROI*.nii.gz']));
                        niftyL = load_density(spec_tract_dir_L);
                        clear size;
                        % find the ones in mask
                        idxL = find(niftyL == 1);
                        [x, y, z] = ind2sub(size(niftyL), idxL); %get the location of the ones 
                        coord = [x, y, z];
                        s = scatter3(x,y,z);
                        xlabel('Sagital')
%                         xlim([0 156])
                        ylabel('Coronal')
%                         ylim([0 189])
%                         zlim([0 157])
                        zlabel('Axial')
                        hold on;
                        coords{l} = coord;
                        partsL = strsplit(spec_tract(l).folder, '/');
                        dirPartL = partsL{end};
                        namePlot = [namePlot convertCharsToStrings(dirPartL)];
                        namePlot = strrep(namePlot,'_',' ');
                    end

                    if length(strfind(spec_tract_dir(2).name,'_R_')) == 1
                        spec_tract_dir_R = dir(fullfile([spec_tract(l).folder,'/', spec_tract(l).name, '/*_R_ROI*.nii.gz']));
                        niftyR = load_density(spec_tract_dir_R);
                        clear size;
                        % find the ones in mask
                        idxR = find(niftyR == 1);
                        [x, y, z] = ind2sub(size(niftyR), idxR); %get the location of the ones 
                        coord = [x, y, z];
                        s = scatter3(x,y,z);
                        xlabel('Sagital')
%                         xlim([0 156])
                        ylabel('Coronal')
%                         ylim([0 189])
%                         zlim([0 157])
                        zlabel('Axial')
                        hold on;
                        coords{l} = coord;
                        partsR = strsplit(spec_tract(l).folder, '/');
                        dirPartR = partsR{end};
                        namePlot = [namePlot convertCharsToStrings(dirPartR)];
                        namePlot = strrep(namePlot,'_',' ');
                    end
                end
            end
        end  
    end   
    if size(coords) ~= 0
        figure(2)
        loc = vertcat(coords{:});
        x = loc(:,1);
        y = loc(:,2);
        z = loc(:,3);
        figure(2)
        subplot(2,2,1)
        % 6 max number of bins to pick from
        sortedIndx = 0; sortedIndy = 0; sortedIndz = 0;
        [sortedX, sortedIndx] = sort(histcounts(x),'descend');
        [sortedY, sortedIndy] = sort(histcounts(y),'descend');
        if length(sortedIndx) >= 4 && length(sortedIndy) >=4
            top4_sag = sortedIndx(1:4);
            top4_cor = sortedIndy(1:4);
            histogram2(x, y)
            title(['sag(' num2str(top4_sag) ') vs. cor(' num2str(top4_cor) ')' ])
            xlim([0 157])
            ylim([0 189])
            xlabel('Sagital')
            ylabel('Coronal')
            zlabel('# of voxels')
        end
        subplot(2,2,2)
        % 4 max number of bins to pick from
        sortedIndx = 0; sortedIndy = 0; sortedIndz = 0;
        [sortedX, sortedIndx] = sort(histcounts(x),'descend');
        [sortedZ, sortedIndz] = sort(histcounts(z),'descend');
        if length(sortedIndx) >= 4 && length(sortedIndz) >=4
            top4_sag = sortedIndx(1:4);
            top4_ax = sortedIndz(1:4);
            histogram2(x, z)
            title(['sag(' num2str(top4_sag) ') vs. ax(' num2str(top4_ax) ')' ])
            xlim([0 157])
            ylim([0 156])
            xlabel('Sagital')
            ylabel('Axial')
            zlabel('# of voxels')
        end
        subplot(2,2,3)

        title('Number of voxels on coronal vs. axial axes')
        % 4 max number of bins to pick from
        sortedIndx = 0; sortedIndy = 0; sortedIndz = 0;
        [sortedY, sortedIndy] = sort(histcounts(y),'descend');
        [sortedZ, sortedIndz] = sort(histcounts(z),'descend');
        if length(sortedIndy) >= 4 && length(sortedIndz) >=4
            top4_cor = sortedIndy(1:4);
            top4_ax = sortedIndz(1:4);
            histogram2(y, z)
            title(['cor(' num2str(top4_cor) ') vs. ax(' num2str(top4_ax) ')' ])
            xlim([0 189])
            ylim([0 156])
            xlabel('Coronal')
            ylabel('Axial')
            zlabel('# of voxels')
        end
        subplot(2,2,4)
        scatter3(x, y, z)
    %     legend(namePlot)
        st = strrep(spec_tract(l).name,'_',' ');
        title(['ROI overlay for ' st])
        xlabel('Sagital')
        xlim([0 156])
        ylabel('Coronal')
        ylim([0 189])
        zlim([0 157])
        zlabel('Axial')
%         set(figure(2),'Position', [1 1 1680 1050]);
%         saveas(figure(2),['/home-local/bayrakrg/Dropbox (VUMC)/tractEM/BLSA/region_overlays/BLSA_ROI_' spec_tract(l).name '.jpg']); 
        close all;
    end
end
