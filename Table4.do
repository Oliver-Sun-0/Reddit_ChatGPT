*Liberal active authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/dem_active_merge.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg distance_hate interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/hostility.doc", replace dec(4)

areg toxicity interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/toxicity.doc", replace dec(4)

*Liberal inactive authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/dem_inactive_merge.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg distance_hate interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/hostility.doc", replace dec(4)

areg toxicity interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/toxicity.doc", replace dec(4)

*Conservative active authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/rep_active_merge.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg distance_hate interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/hostility.doc", append dec(4)

areg toxicity interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/toxicity.doc", append dec(4)

*Conservative inactive authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/rep_inactive_merge.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg distance_hate interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/hostility.doc", append dec(4)

areg toxicity interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/toxicity.doc", append dec(4)
