# ship-attitude-estimation
real time estimation of ship attitude using extended Kalman filter and smartphone

this code can get data from IMU sensor of smartphone in real time and estimate the next move of roll and pitch using extended Kalman filter
and then try to fix the move by stabilizer.
1. connect a smartphone to pc before run the code (note: the smartphone needs to have related android app)
2. get data from smartphone by creating UDP code
3. set the primary value of Kalman
4. open inf loop and estimate the next value
5. fix the roll and pitch by stabilizer
