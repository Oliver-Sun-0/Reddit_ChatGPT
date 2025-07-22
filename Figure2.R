library(dplyr)
library(plm)
library(stargazer)
library(ggplot2)
library(tidyr)
library(stringr)

dem_comments_week <- read.csv('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/parallel/parallel_dem_week.csv', header = TRUE, stringsAsFactors = FALSE)
neutral_comments_week <- read.csv('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/parallel/parallel_neutral_week.csv', header = TRUE, stringsAsFactors = FALSE)
rep_comments_week <- read.csv('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/parallel/parallel_rep_week.csv', header = TRUE, stringsAsFactors = FALSE)

dem_comments_week$relative <- relevel(factor(dem_comments_week$relative), ref = "-1")
neutral_comments_week$relative <- relevel(factor(neutral_comments_week$relative), ref = "-1")
rep_comments_week$relative <- relevel(factor(rep_comments_week$relative), ref = "-1")

model1 <- plm(avg_norm_slant ~ factor(relative) * treatment + treatment, data = dem_comments_week, index = c("author"), model = "within")
model2 <- plm(avg_norm_slant ~ factor(relative) * treatment + treatment, data = neutral_comments_week, index = c("author"), model = "within")
model3 <- plm(avg_norm_slant ~ factor(relative) * treatment + treatment, data = rep_comments_week, index = c("author"), model = "within")

extract_interaction <- function(model, group_name) {
  tidy(model) %>%
    filter(grepl("factor\\(relative\\).*:treatment", term)) %>%
    mutate(group = group_name)
}

coef1 <- extract_interaction(model1, "Liberal")
coef2 <- extract_interaction(model2, "Neutral")
coef3 <- extract_interaction(model3, "Conservative")

all_coefs <- 
  rbind(coef1, coef2, coef3) %>%
  mutate(relative = as.numeric(str_extract(term, "-?\\d+")),
         group = factor(group, levels = c("Liberal", "Neutral", "Conservative"))) %>%
  mutate(relative_label = case_when(
    relative < 0 ~ paste0("Pre-", abs(relative), " week"),
    relative == 0 ~ "Week 0",
    relative > 0 ~ paste0("Post-", relative, " week")
  ),
  relative_label = factor(relative_label, 
                          levels = c(paste0("Pre-", 6:1, " week"), "Week 0", paste0("Post-", 1:6, " week")))
  )

ggplot(all_coefs, aes(y = relative_label, x = estimate, color = group)) +
  geom_point(size = 3, position = position_dodge(width = 0.5)) +
  geom_errorbar(aes(xmin = estimate - std.error, xmax = estimate + std.error),
                width = 0.2,
                position = position_dodge(width = 0.5)) +
  geom_hline(yintercept = 5.5, linetype = "dashed") +
  geom_vline(xintercept = 0, linetype = "dashed") +
  labs(title = "Political Discussion Around the Introduction of ChatGPT",
       x = "Political Slant",
       y = NULL,
       color = NULL) +
  scale_color_manual(values = c(
    "Liberal" = "#2c4ca0", 
    "Neutral" = "#9f9f9f", 
    "Conservative" = "#c44438"
  )) +
  theme_classic() +
  xlim(-0.007, 0.007) +
  theme(
    legend.position = "bottom",
    legend.margin = margin(t = -10),
    plot.margin = margin(t = 10, r = 20, b = 10, l = 10),
    text = element_text(size = 12)
  )