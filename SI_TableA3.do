*Panel A - one year earlier*
*Liberal authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/falsification/dem_falsification_1y.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/3_falsification/falsification_1y.doc", replace dec(4)

*Neutral authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/falsification/neu_falsification_1y.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/3_falsification/falsification_1y.doc", append dec(4)

*Conservative authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/falsification/rep_falsification_1y.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/3_falsification/falsification_1y.doc", append dec(4)


*Panel B - 6 months earlier*
*Liberal authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/falsification/dem_falsification_6m.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/3_falsification/falsification_6m.doc", replace dec(4)

*Neutral authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/falsification/neu_falsification_6m.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/3_falsification/falsification_6m.doc", append dec(4)

*Conservative authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/falsification/rep_falsification_6m.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/3_falsification/falsification_6m.doc", append dec(4)

*Panel C - election*
*Liberal authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/falsification/dem_falsification_election.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/3_falsification/election.doc", replace dec(4)

*Neutral authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/falsification/neu_falsification_election.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/3_falsification/election.doc", append dec(4)

*Conservative authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/falsification/rep_falsification_election.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/3_falsification/election.doc", append dec(4)
