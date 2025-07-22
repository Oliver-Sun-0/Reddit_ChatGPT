*Liberal active authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/dem_active_merge.csv", clear

egen author_id = group(author)

gen interaction = treatment * post_chatgpt

areg anger_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/anger.doc", replace dec(4)

areg fear_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/fear.doc", replace dec(4)

areg disgust_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/disgust.doc", replace dec(4)

areg surprise_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/surprise.doc", replace dec(4)

areg sadness_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/sadness.doc", replace dec(4)

*Liberal inactive authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/dem_inactive_merge.csv", clear

egen author_id = group(author)

gen interaction = treatment * post_chatgpt

areg anger_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/anger.doc", append dec(4)

areg fear_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/fear.doc", append dec(4)

areg disgust_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/disgust.doc", append dec(4)

areg surprise_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/surprise.doc", append dec(4)

areg sadness_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/sadness.doc", append dec(4)

*Conservative active authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/rep_active_merge.csv", clear

egen author_id = group(author)

gen interaction = treatment * post_chatgpt

areg anger_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/anger.doc", append dec(4)

areg fear_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/fear.doc", append dec(4)

areg disgust_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/disgust.doc", append dec(4)

areg surprise_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/surprise.doc", append dec(4)

areg sadness_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/sadness.doc", append dec(4)

*Conservative inactive authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/rep_inactive_merge.csv", clear

egen author_id = group(author)

gen interaction = treatment * post_chatgpt

areg anger_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/anger.doc", append dec(4)

areg fear_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/fear.doc", append dec(4)

areg disgust_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/disgust.doc", append dec(4)

areg surprise_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/surprise.doc", append dec(4)

areg sadness_score interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/sadness.doc", append dec(4)
