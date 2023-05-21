##############################
### Sampling registrations ###
##############################

## Load relevant data
load("group1_and_2_IDs.RData")

sample_size <- #... put here your sample size

seed <- 100
set.seed(seed)                # change seed to get different results when sampling again

sample_group1 <- sample(group1_IDs, sample_size) # take a random sample of size "sample_size" from group 1
sample_group2 <- sample(group2_IDs, sample_size) # take a random sample of size "sample_size" from group 2

show(sample_group1)           # show all IDs sampled from group 1
show(sample_group2)           # show all IDs sampled from group 2


## Save samples from both groups
save(group1_IDs, group2_IDs, file = "sample_group1_and_2_IDs.RData")
