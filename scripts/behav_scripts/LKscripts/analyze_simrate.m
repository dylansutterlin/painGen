


%addpath('/Users/Leonie/Documents/Tools/scripts/General scripts')

clc
close all
clear all
%cd /Users/Leonie/Documents/BOULDER/PROJECTS/6_SCEBL1_fMRI/Behavioral/DATA
projectDir = '/home/dsutterlin/projects/genPain'
dataDir = fullfile(projectDir, 'DATA/Behavioral/')
saveDir = fullfile(projectDir, 'results/behavioral')

cd (dataDir);

% subjects = filenames('SCEBL_MRI2*');
subjects = {'SCEBL_MRI201';'SCEBL_MRI202';'SCEBL_MRI203';'SCEBL_MRI204';'SCEBL_MRI205';...
    'SCEBL_MRI207';'SCEBL_MRI208';'SCEBL_MRI209';               ...
    'SCEBL_MRI211';'SCEBL_MRI212';'SCEBL_MRI213';'SCEBL_MRI214';'SCEBL_MRI215';...
    'SCEBL_MRI216';'SCEBL_MRI217';'SCEBL_MRI218';...
    'SCEBL_MRI219';'SCEBL_MRI220';'SCEBL_MRI221';'SCEBL_MRI222';'SCEBL_MRI223';...
    'SCEBL_MRI224';'SCEBL_MRI225';'SCEBL_MRI226';'SCEBL_MRI227';'SCEBL_MRI228';               ...
    'SCEBL_MRI229';'SCEBL_MRI230';'SCEBL_MRI231';'SCEBL_MRI232';'SCEBL_MRI233';...
    'SCEBL_MRI234';'SCEBL_MRI235';'SCEBL_MRI236';'SCEBL_MRI237';'SCEBL_MRI238'};


conditions =   {'GCA1_LC';  'GCA2_LC';  'GCA3_LC'; ...
    'GPA1_LC';  'GPA2_LC';  'GPA3_LC'; ...
    'GWA1_LC';  'GWA2_LC';  'GWA3_LC'; ...
    'GCV1_LC';  'GCV2_LC';  'GCV3_LC'; ...
    'GPV1_LC';  'GPV2_LC';  'GPV3_LC'; ...
    'GWV1_LC';  'GWV2_LC';  'GWV3_LC'; ...
    'GCA1_HC';  'GCA2_HC';  'GCA3_HC'; ...
    'GPA1_HC';  'GPA2_HC';  'GPA3_HC'; ...
    'GWA1_HC';  'GWA2_HC';  'GWA3_HC'; ...
    'GCV1_HC';  'GCV2_HC';  'GCV3_HC'; ...
    'GPV1_HC';  'GPV2_HC';  'GPV3_HC'; ...
    'GWV1_HC';  'GWV2_HC';  'GWV3_HC'};



for sub = 1:numel(subjects)


    for ccs = 1:36
        simrate.(conditions{ccs}){sub} = NaN;
    end

    % put current subject folder here:
    subject = (subjects{sub})

    cd (fullfile(dataDir, subject, '5_SimRate')) %changed !


    %     if sub < 19
    %         cb = sub;
    %     elseif sub > 18
    %         cb = sub - 18;
    %     end

    f = filenames('simrate*.txt', 'char')

    simdata = importdata(f);

    simrate.condi{sub} = simdata.textdata(6:end,3);
    simrate.rate{sub} = simdata.data(:,2);
    simrate.RT{sub} = simdata.data(:,1);

    for t = 1:size(simrate.rate{sub},1)
        simrate.(simrate.condi{sub}{t}){sub} = simrate.rate{sub}(t);
        simrate.cue{sub}{t} = simrate.condi{sub}{t}(1,6:7);

        if strncmp(simrate.condi{sub}{t}(1,6:7), 'HC', 2) == 1
            simrate.cuecond{sub}(t) = 1;
        elseif strncmp(simrate.condi{sub}{t}(1,6:7), 'LC', 2) == 1
            simrate.cuecond{sub}(t) = 2;
        end

        if strncmp(simrate.condi{sub}{t}(1,3), 'A', 1) == 1
            simrate.av{sub}(t) = 1;
        elseif strncmp(simrate.condi{sub}{t}(1,3), 'V', 1) == 1
            simrate.av{sub}(t) = 2;
        end

    end

    %figure('Color', [1 1 1], 'Name', subject)
    %subplot(2,1,1)
    %scatter(simrate.cuecond{sub}, simrate.rate{sub}, (simrate.av{sub})*25, (simrate.av{sub})/2, 'filled');
    %xlim([0.5 2.5]); ylim([0 100])


    simmat{sub} = [ simrate.GCA1_LC{sub}, simrate.GCA2_LC{sub}, simrate.GCA3_LC{sub},...
        simrate.GPA1_LC{sub}, simrate.GPA2_LC{sub}, simrate.GPA3_LC{sub},...
        simrate.GWA1_LC{sub}, simrate.GWA2_LC{sub}, simrate.GWA3_LC{sub},...
        simrate.GCV1_LC{sub}, simrate.GCV2_LC{sub}, simrate.GCV3_LC{sub},...
        simrate.GPV1_LC{sub}, simrate.GPV2_LC{sub}, simrate.GPV3_LC{sub},...
        simrate.GWV1_LC{sub}, simrate.GWV2_LC{sub}, simrate.GWV3_LC{sub};...
        simrate.GCA1_HC{sub}, simrate.GCA2_HC{sub}, simrate.GCA3_HC{sub},...
        simrate.GPA1_HC{sub}, simrate.GPA2_HC{sub}, simrate.GPA3_HC{sub},...
        simrate.GWA1_HC{sub}, simrate.GWA2_HC{sub}, simrate.GWA3_HC{sub},...
        simrate.GCV1_HC{sub}, simrate.GCV2_HC{sub}, simrate.GCV3_HC{sub},...
        simrate.GPV1_HC{sub}, simrate.GPV2_HC{sub}, simrate.GPV3_HC{sub},...
        simrate.GWV1_HC{sub}, simrate.GWV2_HC{sub}, simrate.GWV3_HC{sub}];

    simmat_reord{sub} = [ % !! dylan modif 26/02, change order to match conditions legend 'gencons'
    simrate.GCA1_LC{sub}, simrate.GCA2_LC{sub}, simrate.GCA3_LC{sub}, ...
    simrate.GCV1_LC{sub}, simrate.GCV2_LC{sub}, simrate.GCV3_LC{sub}, ...
    simrate.GPA1_LC{sub}, simrate.GPA2_LC{sub}, simrate.GPA3_LC{sub}, ...
    simrate.GPV1_LC{sub}, simrate.GPV2_LC{sub}, simrate.GPV3_LC{sub}, ...
    simrate.GWA1_LC{sub}, simrate.GWA2_LC{sub}, simrate.GWA3_LC{sub}, ...
    simrate.GWV1_LC{sub}, simrate.GWV2_LC{sub}, simrate.GWV3_LC{sub}; ...
    simrate.GCA1_HC{sub}, simrate.GCA2_HC{sub}, simrate.GCA3_HC{sub}, ...
    simrate.GCV1_HC{sub}, simrate.GCV2_HC{sub}, simrate.GCV3_HC{sub}, ...
    simrate.GPA1_HC{sub}, simrate.GPA2_HC{sub}, simrate.GPA3_HC{sub}, ...
    simrate.GPV1_HC{sub}, simrate.GPV2_HC{sub}, simrate.GPV3_HC{sub}, ...
    simrate.GWA1_HC{sub}, simrate.GWA2_HC{sub}, simrate.GWA3_HC{sub}, ...
    simrate.GWV1_HC{sub}, simrate.GWV2_HC{sub}, simrate.GWV3_HC{sub}
];

    simmat2(:,:,sub) = simmat{sub};
    simmat3(:,:,sub) = simmat_reord{sub};

    subplot(2,1,2)
    imagesc(simmat{sub});
    colorbar

end


cd(saveDir)
save simrate.mat simrate
save simmat.mat simmat simmat2 simmat3  