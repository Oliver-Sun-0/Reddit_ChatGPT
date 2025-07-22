library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)
library(data.table)
library(gridExtra)
library(grid)

# active dem
active_dem_list <- 
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/monthly/active_author_comment_dem.csv', header = TRUE, stringsAsFactors = FALSE) %>% 
  distinct(author) %>% 
  filter(author != 'PoliticsModeratorBot' & author != 'AutoModerator') 

dates <- data.frame(
  year = c(2021, 2021, 2021, 2021, 2022, 2022, 2022, 2022, 2022),
  month = c(9, 10, 11, 12, 1, 2, 9, 10, 11)
)

active_author_comment_dem <- 
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/monthly/active_author_comment_dem.csv', header = TRUE, stringsAsFactors = FALSE) %>% 
  filter(author != 'PoliticsModeratorBot' & author != 'AutoModerator') %>% 
  mutate(date = as.Date(paste(year, month, "01", sep = "-"))) %>%
  filter(date < '2022-11-30') %>% 
  group_by(author, year, month) %>% 
  summarise(month_comments = sum(count))

active_dem_list_expanded <- 
  active_dem_list %>%
  crossing(dates) %>% 
  left_join(active_author_comment_dem,
            by = c('author', 'year', 'month')) %>% 
  group_by(author) %>% 
  summarise(month_comments = mean(month_comments)) %>% 
  mutate(month_comments = ifelse(month_comments >= quantile(month_comments, 0.99), quantile(month_comments, 0.99), month_comments),
         month_comments = ifelse(month_comments <= quantile(month_comments, 0.01), quantile(month_comments, 0.01), month_comments))
write.csv(active_dem_list_expanded, '/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/author/distribution_plot/active_dem_list_expanded.csv', row.names = FALSE)

deciles_active_dem <- data.frame(
  Decile = seq(1, 9, 1),
  Comments = round(quantile(active_dem_list_expanded$month_comments, probs = seq(0.1, 0.9, 0.1)), 3)
)

main_plot <- ggplot(active_dem_list_expanded, aes(x = month_comments)) +
  geom_histogram(binwidth = 2, fill = "blue", color = "black") +
  labs(
    title = "Liberal - Active",
    x = "Monthly comments",
    y = "Authors"
  ) +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 85, by = 5))

table_theme <- ttheme_minimal(
  core = list(bg_params = list(fill = "white"), fg_params = list(cex = 0.8)),
  colhead = list(
    fg_params = list(fontface = "bold", col = "black", cex = 0.8),
    bg_params = list(fill = "white")
  )
)

decile_table <- tableGrob(deciles_active_dem, rows = NULL, theme = table_theme)
decile_table <- gtable::gtable_add_grob(
  decile_table,
  grobs = segmentsGrob(
    x0 = unit(0, "npc"), x1 = unit(1, "npc"),
    y0 = unit(0, "npc"), y1 = unit(0, "npc"),
    gp = gpar(lwd = 2, col = "black")
  ),
  t = 1, b = 1, l = 1, r = ncol(decile_table)
)

main_plot +
  annotation_custom(
    grob = decile_table,
    xmin = max(active_dem_list_expanded$month_comments) * 0.5,
    xmax = max(active_dem_list_expanded$month_comments),
    ymin = max(table(active_dem_list_expanded$month_comments)*5)
  )

# inactive dem
inactive_dem_list <- 
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/monthly/inactive_author_comment_dem.csv', header = TRUE, stringsAsFactors = FALSE) %>% 
  distinct(author) %>% 
  filter(author != 'PoliticsModeratorBot' & author != 'AutoModerator')

inactive_author_comment_dem <- 
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/monthly/inactive_author_comment_dem.csv', header = TRUE, stringsAsFactors = FALSE) %>% 
  filter(author != 'PoliticsModeratorBot' & author != 'AutoModerator') %>% 
  mutate(date = as.Date(paste(year, month, "01", sep = "-"))) %>%
  filter(date < '2022-11-30') %>% 
  group_by(author, year, month) %>% 
  summarise(month_comments = sum(count))

inactive_dem_list_expanded <- 
  inactive_dem_list %>%
  crossing(dates) %>% 
  left_join(inactive_author_comment_dem,
            by = c('author', 'year', 'month')) %>% 
  group_by(author) %>% 
  summarise(month_comments = mean(month_comments)) %>% 
  mutate(month_comments = ifelse(month_comments >= quantile(month_comments, 0.99), quantile(month_comments, 0.99), month_comments),
         month_comments = ifelse(month_comments <= quantile(month_comments, 0.01), quantile(month_comments, 0.01), month_comments))

deciles_inactive_dem <- data.frame(
  Decile = seq(1, 9, 1),
  Comments = round(quantile(inactive_dem_list_expanded$month_comments, probs = seq(0.1, 0.9, 0.1)), 3)
)
write.csv(inactive_dem_list_expanded, '/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/author/distribution_plot/inactive_dem_list_expanded.csv', row.names = FALSE)

main_plot <- ggplot(inactive_dem_list_expanded, aes(x = month_comments)) +
  geom_histogram(binwidth = 0.2, fill = "blue", color = "black") +
  labs(
    title = "Liberal - Inactive",
    x = "Monthly comments",
    y = "Authors"
  ) +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 85, by = 1))

table_theme <- ttheme_minimal(
  core = list(bg_params = list(fill = "white"), fg_params = list(cex = 0.8)),
  colhead = list(
    fg_params = list(fontface = "bold", col = "black", cex = 0.8),
    bg_params = list(fill = "white")
  )
)

decile_table <- tableGrob(deciles_inactive_dem, rows = NULL, theme = table_theme)
decile_table <- gtable::gtable_add_grob(
  decile_table,
  grobs = segmentsGrob(
    x0 = unit(0, "npc"), x1 = unit(1, "npc"),
    y0 = unit(0, "npc"), y1 = unit(0, "npc"),
    gp = gpar(lwd = 2, col = "black")
  ),
  t = 1, b = 1, l = 1, r = ncol(decile_table)
)

main_plot +
  annotation_custom(
    grob = decile_table,
    xmin = max(inactive_dem_list_expanded$month_comments) * 0.5,
    xmax = max(inactive_dem_list_expanded$month_comments),
    ymin = max(table(inactive_dem_list_expanded$month_comments)) * 0.5
  )

# active republican
active_rep_list <- 
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/monthly/active_author_comment_rep.csv', header = TRUE, stringsAsFactors = FALSE) %>% 
  distinct(author) %>% 
  filter(author != 'PoliticsModeratorBot' & author != 'AutoModerator')

active_author_comment_rep <- 
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/monthly/active_author_comment_rep.csv', header = TRUE, stringsAsFactors = FALSE) %>% 
  filter(author != 'PoliticsModeratorBot' & author != 'AutoModerator') %>% 
  mutate(date = as.Date(paste(year, month, "01", sep = "-"))) %>%
  filter(date < '2022-11-30') %>% 
  group_by(author, year, month) %>% 
  summarise(month_comments = sum(count))

active_rep_list_expanded <- 
  active_rep_list %>%
  crossing(dates) %>% 
  left_join(active_author_comment_rep,
            by = c('author', 'year', 'month')) %>% 
  group_by(author) %>% 
  summarise(month_comments = mean(month_comments)) %>% 
  mutate(month_comments = ifelse(month_comments >= quantile(month_comments, 0.99), quantile(month_comments, 0.99), month_comments),
         month_comments = ifelse(month_comments <= quantile(month_comments, 0.01), quantile(month_comments, 0.01), month_comments))

deciles_active_rep <- data.frame(
  Decile = seq(1, 9, 1),
  Comments = round(quantile(active_rep_list_expanded$month_comments, probs = seq(0.1, 0.9, 0.1)), 3)
)

main_plot <- ggplot(active_rep_list_expanded, aes(x = month_comments)) +
  geom_histogram(binwidth = 2, fill = "blue", color = "black") +
  labs(
    title = "Conservative - Active",
    x = "Monthly comments",
    y = "Authors"
  ) +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 95, by = 5))
write.csv(active_rep_list_expanded, '/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/author/distribution_plot/active_rep_list_expanded.csv', row.names = FALSE)

table_theme <- ttheme_minimal(
  core = list(bg_params = list(fill = "white"), fg_params = list(cex = 0.8)),
  colhead = list(
    fg_params = list(fontface = "bold", col = "black", cex = 0.8),
    bg_params = list(fill = "white")
  )
)

decile_table <- tableGrob(deciles_active_rep, rows = NULL, theme = table_theme)
decile_table <- gtable::gtable_add_grob(
  decile_table,
  grobs = segmentsGrob(
    x0 = unit(0, "npc"), x1 = unit(1, "npc"),
    y0 = unit(0, "npc"), y1 = unit(0, "npc"),
    gp = gpar(lwd = 2, col = "black")
  ),
  t = 1, b = 1, l = 1, r = ncol(decile_table)
)

main_plot +
  annotation_custom(
    grob = decile_table,
    xmin = max(active_rep_list_expanded$month_comments) * 0.5,
    xmax = max(active_rep_list_expanded$month_comments),
    ymin = max(table(active_rep_list_expanded$month_comments))*5
  )

# inactive republican
inactive_rep_list <- 
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/monthly/inactive_author_comment_rep.csv', header = TRUE, stringsAsFactors = FALSE) %>% 
  distinct(author) %>% 
  filter(author != 'PoliticsModeratorBot' & author != 'AutoModerator')

inactive_author_comment_rep <- 
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/monthly/inactive_author_comment_rep.csv', header = TRUE, stringsAsFactors = FALSE) %>% 
  mutate(date = as.Date(paste(year, month, "01", sep = "-"))) %>%
  filter(date < '2022-11-30') %>% 
  group_by(author, year, month) %>% 
  summarise(month_comments = sum(count))

inactive_rep_list_expanded <- 
  inactive_rep_list %>%
  crossing(dates) %>% 
  left_join(inactive_author_comment_rep,
            by = c('author', 'year', 'month')) %>% 
  group_by(author) %>% 
  summarise(month_comments = mean(month_comments)) %>% 
  mutate(month_comments = ifelse(month_comments >= quantile(month_comments, 0.99), quantile(month_comments, 0.99), month_comments),
         month_comments = ifelse(month_comments <= quantile(month_comments, 0.01), quantile(month_comments, 0.01), month_comments))

deciles_inactive_rep <- data.frame(
  Decile = seq(1, 9, 1),
  Comments = round(quantile(inactive_rep_list_expanded$month_comments, probs = seq(0.1, 0.9, 0.1)), 3)
)

main_plot <- ggplot(inactive_rep_list_expanded, aes(x = month_comments)) +
  geom_histogram(binwidth = 0.2, fill = "blue", color = "black") +
  labs(
    title = "Conservative - Inactive",
    x = "Monthly comments",
    y = "Authors"
  ) +
  theme_classic() +
  scale_x_continuous(breaks = seq(0, 7, by = 1))
write.csv(inactive_rep_list_expanded, '/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/author/distribution_plot/inactive_rep_list_expanded.csv', row.names = FALSE)

table_theme <- ttheme_minimal(
  core = list(bg_params = list(fill = "white"), fg_params = list(cex = 0.8)),
  colhead = list(
    fg_params = list(fontface = "bold", col = "black", cex = 0.8),
    bg_params = list(fill = "white")
  )
)

decile_table <- tableGrob(deciles_inactive_rep, rows = NULL, theme = table_theme)
decile_table <- gtable::gtable_add_grob(
  decile_table,
  grobs = segmentsGrob(
    x0 = unit(0, "npc"), x1 = unit(1, "npc"),
    y0 = unit(0, "npc"), y1 = unit(0, "npc"),
    gp = gpar(lwd = 2, col = "black")
  ),
  t = 1, b = 1, l = 1, r = ncol(decile_table)
)

main_plot +
  annotation_custom(
    grob = decile_table,
    xmin = max(inactive_rep_list_expanded$month_comments) * 0.5,
    xmax = max(inactive_rep_list_expanded$month_comments),
    ymin = max(table(inactive_rep_list_expanded$month_comments)) * 0.5
  )
