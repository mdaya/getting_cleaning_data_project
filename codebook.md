## Overview

The data set was generated from experiments that were carried out with a group 
of 30 volunteers within an age bracket of 19-48 years. 
Each person performed six activities (WALKING, WALKING_UPSTAIRS, 
WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone 
(Samsung Galaxy S II) on the waist. 
Using its embedded accelerometer and gyroscope, the 3-axial linear acceleration 
and 3-axial angular velocity were captured at a constant rate of 50Hz. 
The measurements were filtered using a median filter and a 3rd order low pass 
Butterworth filter with a corner frequency of 20 Hz to remove noise. 
The acceleration signal was separated into body and gravity acceleration signals 
using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 
Subsequently, the body linear acceleration and angular velocity were derived to 
obtain Jerk signals.
The magnitude of these three-dimensional signals were calculated using the 
Euclidean norm.
The mean and standard deviations of the measurements are available in this 
data set.
The obtained dataset was also randomly partitioned into two sets, where 70% of 
the volunteers was selected for generating the training data and 30% the test 
data. 

## Columns

Columns contain the following data.

### SubjectID

A unique identifier that was assigned to each subject in the study.

### DataSet	

A label that identifies whether the record belongs to the training (TRAINING)
or testing (TESTING) data sets.

### Activity	

A label that identifies the type of activity that was performed.
Possible values:
* WALKING
* WALKING_UPSTAIRS
* WALKING_DOWNSTAIRS
* SITTING
* STANDING
* LAYING

### Statistic

The type of summary statistic encapsulated by the record: mean (MEAN) or 
standard deviation (SD).

### Activity Variables

The following columns contain the mean and standard deviation of a set of 
measurements.
The X, Y and Z coordinates and magnitudes of body acceleration, gravity 
acceleration, body accelaration Jerk signal, body gyroscope and body gyroscope 
Jerk signal are recorded in terms of time (column names start with *time*).
A fast Fourier transformation was also applied to the body acceleration and 
gyropscope coordinates and magnitudes, as well as to their Jerk signals
(column names start with *fourier*).
