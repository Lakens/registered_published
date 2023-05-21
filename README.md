# An Inception Cohort Study Quantifying How Many Registered Studies are Published.

This is a repository for the reproducible manuscript by Eline Ensinck and Daniel Lakens. 

We quantified how many research studies registered on the Open Science Framework (OSF) are performed but never publicly shared. Examining 315 registrations revealed that 169 were research studies, of which 104 (62%) were published. For the whole population of registrations on the OSF before November 2017 we estimate 58% is published. Researchers use registries to make unpublished studies public, and the OSF policy to automatically make registrations public substantially increases the number of performed studies that become known to the scientific community. It is often challenging to identify whether public registrations are published due to a lack of information in registrations. In responses to emails asking researchers why studies remained unpublished, logistics (e.g., lack of time, researchers changing jobs) was the most common reason, followed by null results and rejections during peer review. Our project shows a substantial amount of data that researchers collect is never publicly shared. Selectively publishing studies is problematic because of the possibility that the resources used to collect the data are wasted, and if the publication of studies depend on the results their non-publication can cause bias in the scientific literature. Although it is common knowledge that researchers have studies in their filedrawer, it is extremely difficult to quantify how many studies in psychology are performed, but never published. The OSF has a policy to make all registrations public after four years. This allows us to perform the first inception cohort study on the OSF where we attempt to examine for registered studies if they end up in the scientific literature after at least 4 years. A better understanding of how many studies remain unpublished, and the reasons why researchers did not publish studies, enables researchers to seriously engage with the question how internal inefficiency in science can be reduced.

- paper.Rmd contains the computationally reproducible manuscript. 

- supplement.Rmd contains the computationally reproducible manuscript.

- registration.data.xlsx contains the data for the 315 registrations that were examined. 

- get_data_from_osf_with_api.R is the code we used to get information about registrations from the OSF through the OSF API. 

- This code creates the file: registration_data.RData

- This data file is loaded by the file: analyze_prereg_api_data.R which uses the API to query whether registrations have open project pages or not. 

- This is stored in the file: res_df_data.RData

- The same analyze_prereg_api_data.R file contains code to get data about researchers associated with OSF projects. This is stored in the file: author_df.RData

- Both these files are loaded and used to compute descriptives about the registrations, which are reported in the manuscript compiled by paper.Rmd.

- The code sorting_registrations.R was used to sort registrations based on whether they were open or not, as we sampled equal numbers of open and closed projects.

- The code sampling_registrations.R was used to randomly sample registrations from the total population. 

