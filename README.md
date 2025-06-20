# SeptalCurvatureTool
This GUI-based MATLAB tool computes time-resolved septal curvature (curvature of the interventricular septal wall) based on short-axis stack MRI and contours delineated in cvi42, a commercial image processing tool. Two approaches have been implemented in this tool:
1. Automated septal curvature computation based on contours from cvi42
2. Manual septal curvature computation (See 'Citation' section for original work)  
<br/>

<img src="https://github.com/CU-Anschutz-Advanced-Imaging-Lab/septalCurvatureTool/blob/94e249131da1855f36781e399ff60d2e00e5423e/images/septalCurvatureTool_options.png" alt="twoApproaches" width="1000px">

<br/>
<br/>

# Note
- Use [Native Apple silicon MATLAB][1] if you're on Apple silicon Mac. 
- The tool has been tested only for Philips data.
<br/>
<br/>

# Getting Started
## Software requirements
- MATLAB (has been tested on R2022b)
- Image Processing Toolbox
- cvi42 (Circle Cardiovascular Imaging Inc., Calgary, Canada) for contouring

## Input
- Short-axis stack imaging covering both the left and right ventricle
- *.cvi42wsx file exported from cvi42

## Quick instruction
1. Before using the tool, use cvi42 to delineate
   - LV endocardial/epicardial contours
   - RV endocardial contours
   - Two 'insertion' points (intersection of RV endo and LV epicardial contours)  

&emsp;&emsp;&emsp;throughout a cardiac cycle for a mid-slice of short-axis stack imaging. An AI tool is available for this task. Please see cvi42 manuals.  

2. Export the cvi42 workspace as a *.cvi42wsx file. Create a folder and copy the DICOM images of the mid-slice you used for contouring.

3. Open the tool.  

4. Push 'Load Contour' and select the folder you saved the DICOM files. Then select the cvi42wsx file.  

5. Time-resolved Septal curvature is computed and results are shown in the panels on the left. You can export the septal curvature data using 'export' button.  

6. To use manual approach, click on the 'Points for circle fitting' pull down menu and select 'Manual'. Please follow messages shown in the black window in the center panel.
<br/>
<br/>

# Demo
## Automated approach
https://github.com/user-attachments/assets/05c90a3f-aa92-4302-aecc-a3aac7b367f1

## Manual approach
https://github.com/user-attachments/assets/efd38f1b-4b3f-4ca6-9f15-a3210b894425

<br/>
<br/>

# Citation
This conference abstract is the original citation for this tool (a manuscript in preparation):

> Lu V, Fujiwara T, Ivy D, Fonseca B, Malone L, Frank B, Neves da Silva H, Sassoon D, Burkett D, Browne LP, Barker AJ. Measurement of Time-resolved Septal Curvature to Assess Pediatric Pulmonary Hypertension. Journal of Cardiovascular Magnetic Resonance. 2024;26:100547.   

If you use the manual septal curvature computation functionality, please also cite this original work:
> Pandya B, Quail MA, Steeden JA, McKee A, Odille F, Taylor AM, Schulze-Neick I, Derrick G, Moledina S, Muthurangu V. Real-time magnetic resonance assessment of septal curvature accurately tracks acute hemodynamic changes in pediatric pulmonary hypertension. Circ Cardiovasc Imaging. 2014 Jul;7(4):706-13. doi: 10.1161/CIRCIMAGING.113.001156. Epub 2014 Apr 25. PMID: 24771555.

[1]:https://www.mathworks.com/support/requirements/apple-silicon.html
