# Afanzar-et-al
Video analysis scripts 
The directory contains the automated script used to extract the locations and rotation velocities of tethered cells in *.avi files. 

Once the script is runned, it opens a dialogue box. Chose the main directory in which all of the video files are located.
Te script will run through all the subdirecotires of the main directory looking for *.avi files. Once a file is found, it is analysed for tethered cells location and angular position in each frame of the movie. The analysis information of each *.avi file is saved as *_AnalysisData.m. In subsequent step of the script, "bad" trajectories are filtered out and angular position data is translated to rotation velocity. The output of this step is saved as *_AnalysisDataB.m.

The script assumes blackish cells over whitish background. In the case that inverted colors are used, replace line 23 in AnalyzeMovie.m from:
    [Angle(n,:),MajAx(n,:),MinAx(n,:),XCor(n,:),YCor(n,:)]=FeaturesFromFrame(double(Temp),AllImg);
To
    [Angle(n,:),MajAx(n,:),MinAx(n,:),XCor(n,:),YCor(n,:)]=FeaturesFromFrame(imcomplement(double(Temp)),AllImg);


In the case that you chose to use these scripts for work that resolves in publication, you can reference afanzar et al 2019.
( in the hope that the ever revising manuscript will be published, eventually )
