1. convertScreenshotsJpg2Pgm has to happen first obviously. But just once. It takes in a block type.

2. scenestats_cmd is a script, and it happens next. 
 -- It must be run on one condition at a time, because it organizes everything by condition along the psychometric Axis (ratio of means)
 -- Each screenshot is opened, and a pooling region is extracted from each side. 
 -- Texture statistics are computed on each pooling region.
 -- These are organized by the trial's psychometric tick-value
 -- ... and saved for that condition (.mat)

3. tryDifferentConds: script to explore whether texture stats are different between LHS and RHS
 -- Run once you have the texture stats generated for each cond (step 2)
 -- It loads the matfile for each condition and lets you select a subset of texture stats
 -- compareStats is a helper that accesses texture statistics on the LHS and RHS and runs paired ttests
