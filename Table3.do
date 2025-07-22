*Panel A - User Slant*
*Liberal active authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/dem_active_merge.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/slant.doc", replace dec(4)

*Liberal inactive authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/dem_inactive_merge.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/slant.doc", append dec(4)

*Conservative active authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/rep_active_merge.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/slant.doc", append dec(4)

*Conservative inactive authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/rep_inactive_merge.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/4_mechanism/slant.doc", append dec(4)


*Panel B - Commenting Change*
*Liberal active authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/monthly/active_author_comment_dem.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg count interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/6_monthly_comments/monthly_comments.doc", replace dec(4)

*Liberal inactive authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/monthly/inactive_author_comment_dem.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg count interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/6_monthly_comments/monthly_comments.doc", append dec(4)

*Conservative active authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/monthly/active_author_comment_rep.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg count interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/6_monthly_comments/monthly_comments.doc", append dec(4)

*Conservative inactive authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/monthly/inactive_author_comment_rep.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg count interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/6_monthly_comments/monthly_comments.doc", append dec(4)

