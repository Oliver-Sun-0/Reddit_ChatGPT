*Panel A*
*Liberal extreme authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/author_division/extreme_dem_comments.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/5_extreme/extreme_regular_moderate.doc", replace dec(4)

*Liberal regular authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/author_division/regular_dem_comments.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/5_extreme/extreme_regular_moderate.doc", append dec(4)

*Liberal moderate authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/author_division/moderate_dem_comments.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/5_extreme/extreme_regular_moderate.doc", append dec(4)

*Conservative extreme authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/author_division/extreme_rep_comments.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/5_extreme/extreme_regular_moderate.doc", append dec(4)

*Conservative regular authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/author_division/regular_rep_comments.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/5_extreme/extreme_regular_moderate.doc", append dec(4)

*Conservative moderate authors*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/author_division/moderate_rep_comments.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/5_extreme/extreme_regular_moderate.doc", append dec(4)

*Panel B*
*80 dem*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/author_division/80_neutral_dem.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/5_extreme/relatively_neutral.doc", replace dec(4)


*80 rep*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/author_division/80_neutral_rep.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/5_extreme/relatively_neutral.doc", append dec(4)


*90 dem*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/author_division/90_neutral_dem.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/5_extreme/relatively_neutral.doc", append dec(4)


*90 rep*
import delimited "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/author_division/90_neutral_rep.csv", clear

egen author_id = group(author)
gen interaction = treatment * post_chatgpt
areg norm_slant interaction treatment post_chatgpt, absorb(author_id) vce(cluster author_id)
outreg2 using "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/stata_regression/5_extreme/relatively_neutral.doc", append dec(4)

