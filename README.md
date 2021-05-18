# MT---Simulation-of-Policies-against-Information-Pollution-on-Twitter
Respository for Master Thesis / Markus Rottmann, 97-919-294

This _respository_ contains the _R_- and _NetLogo_-code for my Master Thesis **"Simulation of Policies against Information-Pollution on Twitter"**.
+ all input and output data are referenced in the respective codes. 
+ for easy viewing, klick the link below each description or download the .html version and view it in your browser.


&nbsp;

### R-Code
**Code: MT_scraping_04.rmd / MT_scraping_04.html**
+ This Code Scrapes the Tweets of all candidates for 2019 elections and combines it into a data frame that also contains properties such as gender, age, party, etc. For the sake of privacy, all twitter API information is set to “YYY”. All code chunks are set eval = FALSE due to the very long running time of this code.
+ [MT_scraping_04.html](https://htmlpreview.github.io/?https://github.com/blueapu/MT---Simulation-of-Policies-against-Information-Pollution-on-Twitter/blob/main/MT_scraping_04.html)

&nbsp;

**Code: MT_corpus_analysis_07.rmd / MT_corpus_analysis_07.html**
+ This code is to identify tweets that contain information pollution on corona in two steps. First, identifying all corona-tweets (including stratifying collection of tweets). Second, identifying information pollution within corona-tweets.
+ [MT_corpus_analysis_07.html](https://htmlpreview.github.io/?https://github.com/blueapu/MT---Simulation-of-Policies-against-Information-Pollution-on-Twitter/blob/main/MT_corpusanalysis_07.html)

&nbsp;

**Code: MT_networkanalysis_06.rmd / MT_networkanalysis_06.html**
+ This Code is to analyze/build the network from downloaded tweets. This is done in two steps. First, analyzing who mentions whose twitter handle (e.g. @markus_rottmann). Second, transforming this information into a adjecency matrix.
+ [MT_networkanalysis_06.html](https://htmlpreview.github.io/?https://github.com/blueapu/MT---Simulation-of-Policies-against-Information-Pollution-on-Twitter/blob/main/MT_networkanalysis_06.html)


&nbsp;

**Code: MT_regressions_05.rmd / MT_regressions_05.html**
+ This code predicts the probability of all candidates in the network to tweet a certain type of information pollution tweets. These results are input for the MABS simulation. This is achieved in three steps. First, a multinominal regression is ran on all manually information pollution tweets of the corona tweets. Independent variables are _gender_ and _party_. Second, The regression results are then applied to all candidates in the network, results are predicted probabilities. Third, since the probabilities to issue an information pollution tweet are very low (less than 0.1%), the probabilites enhanced, resulting in pronounced probabilities.
+ [MT_regressions_05.html](https://htmlpreview.github.io/?https://github.com/blueapu/MT---Simulation-of-Policies-against-Information-Pollution-on-Twitter/blob/main/MT_regressions_05.html)

&nbsp;

**Code: MT_resultanalysis_07.rmd / MT_resultanalysis_07.html**
+ This Code is to analyze/build the results from the simulating each countermeasure (in NetLogo). It calculates descriptive statistics, renders plots and performs OLS. 
+ [MT_resultanalysis_07.html](https://htmlpreview.github.io/?https://github.com/blueapu/MT---Simulation-of-Policies-against-Information-Pollution-on-Twitter/blob/main/MT_resultanalysis_07.html)

&nbsp;

### NetLogo-Code
**Code: network_sim_warn_x02_04.nlogo / network_sim_warn_x02_04.html**
+ Contains the code building the MABS model for countermeasure "Warning Labels".
+ [network_sim_warn_x02_04.html](https://htmlpreview.github.io/?https://github.com/blueapu/MT---Simulation-of-Policies-against-Information-Pollution-on-Twitter/blob/main/network_sim_warn_x02_04.htmlhttps://github.com/blueapu/MT---Simulation-of-Policies-against-Information-Pollution-on-Twitter/blob/main/network_sim_ban_x02_03_universal.html]

&nbsp;

**Code: network_sim_susp_x02_03.nlogo / network_sim_susp_x02_03.html**
+ ... contains the code building the MABS model for countermeasure "Account Suspension".
+ [network_sim_susp_x02_03.html](https://htmlpreview.github.io/?https://github.com/blueapu/MT---Simulation-of-Policies-against-Information-Pollution-on-Twitter/blob/main/network_sim_susp_x02_03.html]

&nbsp;

**Code: network_sim_ban_x02_03_universal.nlogo / network_sim_ban_x02_03_universal.html**
+ Contains the code building the MABS model for countermeasure "Account Ban".
+ [network_sim_ban_x02_03_universal.html](https://htmlpreview.github.io/?https://github.com/blueapu/MT---Simulation-of-Policies-against-Information-Pollution-on-Twitter/blob/main/network_sim_ban_x02_03_universal.html)
