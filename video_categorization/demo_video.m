function demo_video()
    % includepath
    addpath('../freqSaliencyMap/pft');
    addpath('../freqSaliencyMap/pqft');
    addpath('../ittiSaliencyMap/');
    addpath('../gbvsSaliencyMap/');
%     addpath('../infoSaliencyMap/');

    % Flag
    saveFlag = 1;
    demoFlag = 0;

    % I/O Part
    dbname = 'digikam4.db';
    albname = 'autosplit';
    if (demoFlag == 1)
        ptagname = 'our_car';
        ctagname = 'go_up';
        inputVideos =  cVideos(dbname,albname,ptagname,ctagname);    
    else
        inputVideos =  cVideos(dbname,albname);
    end
    pftSaliencyMap = 0; pqftSaliencyMap = 0; ittiSaliencyMap = 0; gbvsSaliencyMap = 0; infoSaliencyMap = 0; infoSaliencyMap_3 = 1;
    
    if (pftSaliencyMap == 1)
        outputFolder = ['./results' '/' albname '/pftSaliencyMaps_date-' datestr(now,'yyyymmddTHHMMSS')];    
        if (saveFlag == 1)
            if (exist(outputFolder,'dir') ~= 7) 
                mkdir(outputFolder);
            else
                warning('The folder is already existed');
            end
        end        

        for i = 1:1:length(inputVideos.vidpaths)    
            inputVideo = inputVideos.vidpaths{i};
            [~,name,~] = fileparts(inputVideo);
            
            %% Add eye-fixated location data
            inputData = inputVideo; 
            inputData(end-2:end) = 'mat';
            load(inputData);
            inputData = subLoc.Data;
            
            outputVideo = [outputFolder '/' name];
            % saveFlag is used for controlling save action
            % processing part    
            pftSaliencyMap_video(inputVideo,outputVideo,saveFlag,demoFlag,inputData);
        end
    end
    
    if (pqftSaliencyMap == 1)
        outputFolder = ['./results' '/' albname '/pqftSaliencyMaps_date-' datestr(now,'yyyymmddTHHMMSS')];    
        if (saveFlag == 1)
            if (exist(outputFolder,'dir') ~= 7) 
                mkdir(outputFolder);
            else
                warning('The folder is already existed');
            end
        end        

        for i = 1:1:length(inputVideos.vidpaths)    
            inputVideo = inputVideos.vidpaths{i};    
            
            %% Add eye-fixated location data
            inputData = inputVideo; 
            inputData(end-2:end) = 'mat';
            load(inputData);
            inputData = subLoc.Data;
            
            [~,name,~] = fileparts(inputVideo);            
            outputVideo = [outputFolder '/' name];
            % saveFlag is used for controlling save action
            % processing part    
            pqftSaliencyMap_video(inputVideo,outputVideo,saveFlag,demoFlag,inputData);
        end
    end
    
    if (ittiSaliencyMap == 1)
        outputFolder = ['./results' '/' albname '/ittiSaliencyMaps_date-' datestr(now,'yyyymmddTHHMMSS')];    
        if (saveFlag == 1)
            if (exist(outputFolder,'dir') ~= 7) 
                mkdir(outputFolder);
            else
                warning('The folder is already existed');
            end
        end        

        for i = 1:1:length(inputVideos.vidpaths)    
            inputVideo = inputVideos.vidpaths{i};    
            
            %% Add eye-fixated location data
            inputData = inputVideo; 
            inputData(end-2:end) = 'mat';
            load(inputData);
            inputData = subLoc.Data;
            
            [~,name,~] = fileparts(inputVideo);            
            outputVideo = [outputFolder '/' name];
            % saveFlag is used for controlling save action
            % processing part    
            ittiSaliencyMap_video(inputVideo,outputVideo,saveFlag,demoFlag,inputData);
        end
    end 
    
    if (gbvsSaliencyMap == 1)
        outputFolder = ['./results' '/' albname '/gbvsSaliencyMaps_date-' datestr(now,'yyyymmddTHHMMSS')];    
        if (saveFlag == 1)
            if (exist(outputFolder,'dir') ~= 7) 
                mkdir(outputFolder);
            else
                warning('The folder is already existed');
            end
        end        

        for i = 1:1:length(inputVideos.vidpaths)    
            inputVideo = inputVideos.vidpaths{i};    
            
            %% Add eye-fixated location data
            inputData = inputVideo; 
            inputData(end-2:end) = 'mat';
            load(inputData);
            inputData = subLoc.Data;
            
            [~,name,~] = fileparts(inputVideo);            
            outputVideo = [outputFolder '/' name];
            % saveFlag is used for controlling save action
            % processing part    
            gbvsSaliencyMap_video(inputVideo,outputVideo,saveFlag,demoFlag,inputData);
        end
    end

    if (infoSaliencyMap == 1)
        outputFolder = ['./results' '/' albname '/infoSaliencyMaps_date-' datestr(now,'yyyymmddTHHMMSS')];
        if (saveFlag == 1)
            if (exist(outputFolder,'dir') ~= 7) 
                mkdir(outputFolder);
            else
                warning('The folder is already existed');
            end
        end        

        for i = 1:1:length(inputVideos.vidpaths)
            inputVideo = inputVideos.vidpaths{i};    
            
            %% Add eye-fixated location data
            inputData = inputVideo;
            inputData(end-2:end) = 'mat';
            load(inputData);
            inputData = subLoc.Data;
            
            [~,name,~] = fileparts(inputVideo);            
            outputVideo = [outputFolder '/' name];
            % saveFlag is used for controlling save action
            % processing part    
            infoSaliencyMap_video_1(inputVideo,outputVideo,saveFlag,demoFlag,inputData);
        end
    end       

    addpath('../../vap_svn_ghost_branches/infoSaliencyMap_0.3/');    
    if (infoSaliencyMap_3 == 1)
        outputFolder = ['./results' '/' albname '/infoSaliencyMaps_3_date-' datestr(now,'yyyymmddTHHMMSS')];
        if (saveFlag == 1)
            if (exist(outputFolder,'dir') ~= 7) 
                mkdir(outputFolder);
            else
                warning('The folder is already existed');
            end
        end        

        for i = 5:1:length(inputVideos.vidpaths)    
            inputVideo = inputVideos.vidpaths{i};    
            
            %% Add eye-fixated location data
            inputData = inputVideo;
            inputData(end-2:end) = 'mat';
            load(inputData);
            inputData = subLoc.Data;
            
            [~,name,~] = fileparts(inputVideo);            
            outputVideo = [outputFolder '/' name];
            % saveFlag is used for controlling save action
            % processing part    
            infoSaliencyMap_video_3(inputVideo,outputVideo,saveFlag,demoFlag,inputData);
        end
    end           
end