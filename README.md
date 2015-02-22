## How the script works

First, the script loads test and train subjects data, names of activities, and test and train activities data, each to a data frame.

Then it changes codes of activities in the corresponding data frames to their names.

After that, the script loads names of features, and test and train features data.

Then, it binds the data for subjects and activities into two dataframes, one for test data and another for train data. The script also sets label names for subject and activity fields.

Since we need only means and standard deviation information, we add only these columns from features data frames.

After that, the script binds the test and the train dataframes into one, just adding the rows.

Finally, we build a tidy data frame, where we have subjects, activity types and mean data for each activity type.

After some reordering and renaming we are done.