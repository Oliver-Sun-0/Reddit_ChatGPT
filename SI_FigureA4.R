
# Panel A
dem_comments <- 
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/comments/dem_comments.csv', header = TRUE, stringsAsFactors = FALSE) %>% 
  filter(date < '2022-11-30') %>% 
  group_by(author) %>% 
  summarise(avg_slant = mean(norm_slant))

deciles_dem <- data.frame(
  Decile = seq(1, 9, 1),
  Slant = round(quantile(dem_comments$avg_slant, probs = seq(0.1, 0.9, 0.1)), 3)
)

main_plot <- ggplot(dem_comments, aes(x = avg_slant)) +
  geom_histogram(binwidth = 0.02, fill = "blue", color = "black") +
  labs(
    title = "Liberal",
    x = "Slant",
    y = "Frequency"
  ) +
  theme_classic()

table_theme <- ttheme_minimal(
  core = list(bg_params = list(fill = "white"), fg_params = list(cex = 0.8)),
  colhead = list(
    fg_params = list(fontface = "bold", col = "black", cex = 0.8),
    bg_params = list(fill = "white")
  )
)

decile_table <- tableGrob(deciles_dem, rows = NULL, theme = table_theme)
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
    xmin = max(dem_comments$avg_slant) * -7,
    xmax = max(dem_comments$avg_slant),
    ymin = max(table(dem_comments$avg_slant)) * 2
  )

# Panel B
rep_comments <- 
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/comments/rep_comments.csv', header = TRUE, stringsAsFactors = FALSE) %>% 
  filter(date < '2022-11-30') %>% 
  group_by(author) %>% 
  summarise(avg_slant = mean(norm_slant))

deciles_rep <- data.frame(
  Decile = seq(1, 9, 1),
  Slant = round(quantile(rep_comments$avg_slant, probs = seq(0.1, 0.9, 0.1)), 3)
)

main_plot <- ggplot(rep_comments, aes(x = avg_slant)) +
  geom_histogram(binwidth = 0.02, fill = "blue", color = "black") +
  labs(
    title = "Conservative",
    x = "Slant",
    y = "Frequency"
  ) +
  theme_classic()

table_theme <- ttheme_minimal(
  core = list(bg_params = list(fill = "white"), fg_params = list(cex = 0.8)),
  colhead = list(
    fg_params = list(fontface = "bold", col = "black", cex = 0.8),
    bg_params = list(fill = "white")
  )
)

decile_table <- tableGrob(deciles_rep, rows = NULL, theme = table_theme)
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
    xmin = max(rep_comments$avg_slant) * -2,
    xmax = max(rep_comments$avg_slant),
    ymin = max(table(rep_comments$avg_slant)) * 2
  )
