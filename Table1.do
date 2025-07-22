*Liberal authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/comments/dem_comments.csv", clear

egen author_id = group(author)

gen interaction = treatment * post_chatgpt

areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/1_primary_finding/primary_finding.doc", replace dec(4)

*Neutral authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/comments/neutral_comments.csv", clear

egen author_id = group(author)

gen interaction = treatment * post_chatgpt

areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/1_primary_finding/primary_finding.doc", append dec(4)

*Conservative authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/comments/rep_comments.csv", clear

egen author_id = group(author)

gen interaction = treatment * post_chatgpt

areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/1_primary_finding/primary_finding.doc", append dec(4)
