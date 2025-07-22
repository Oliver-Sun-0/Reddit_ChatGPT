library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)
library(data.table)
library(forcats)
library(ggtext)

# # AI detector
folder_path_treatment_ai <- "/Volumes/Seagate_5T/Reddit_chatgpt/Phd_results/AI_measurement_2019/treatment_AI"
ai_csv_files_treatment <- list.files(path = folder_path_treatment_ai, pattern = "*.csv", full.names = TRUE)

AI_treatment_post_chatgpt <-
  ai_csv_files_treatment %>%
  lapply(read.csv) %>%
  bind_rows() %>%
  mutate(date = as.Date(created_utc)) %>%
  filter(date > "2022-11-30",
         ai_label == 'Real') %>% # human score
  filter(author != 'PoliticsModeratorBot' & author != 'AutoModerator') %>% 
  filter(ai_score >= quantile(ai_score, 0.7, na.rm=TRUE))

# passive verbs
passive_treatment_path <- "/Volumes/Seagate_5T/Reddit_chatgpt/250427_infection_update_2/passive_verbs/treatment"
csv_passive_treatment <- list.files(path = passive_treatment_path, pattern = "*.csv", full.names = TRUE)

passive_treatment <- 
  csv_passive_treatment %>%
  lapply(read.csv) %>%
  bind_rows() %>% 
  mutate(
    date = as.Date(created_utc),
  ) %>% 
  filter(date <= '2023-03-01',
         date >= '2022-11-30') %>% 
  filter(author != 'PoliticsModeratorBot' & author != 'AutoModerator')

# all comments
coomments_path <- "/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive"
csv_coomments_path <- list.files(path = coomments_path, pattern = "*.csv", full.names = TRUE)

dem_rep_comments <- 
  csv_coomments_path %>%
  lapply(read.csv) %>%
  bind_rows() %>% 
  filter(date >= "2022-11-30")

dem_rep_comments_merge <- 
  dem_rep_comments %>% 
  inner_join(passive_treatment %>% 
               distinct(subreddit, author, score, total_awards_received, created_utc, date, passive_verbs_count) %>% 
               mutate(date = as.character(date)),
             by = c('subreddit', 'author', 'score', 'total_awards_received', 'created_utc', 'date'))

AI_comments <- 
  dem_rep_comments_merge %>% 
  inner_join(AI_treatment_post_chatgpt %>% 
               mutate(date = as.character(date)),
             by = c('subreddit', 'author', 'score', 'total_awards_received', 'created_utc', 'date')) %>% 
  mutate(log_word_count = log(word_count)) %>% 
  summarise(
    mean_word = mean(log_word_count),
    se_word = sd(log_word_count),
    mean_passive_verbs = mean(passive_verbs_count),
    se_passive_verbs = sd(passive_verbs_count),
    mean_perplexity = mean(log_perplexity_score),
    se_perplexity = sd(log_perplexity_score)
  ) %>% 
  mutate(type = "ChatGPT-Generated")

human_comments <- 
  dem_rep_comments_merge %>% 
  anti_join(AI_treatment_post_chatgpt %>% 
              mutate(date = as.character(date)),
            by = c('subreddit', 'author', 'score', 'total_awards_received', 'created_utc', 'date')) %>% 
  mutate(log_word_count = log(word_count)) %>% 
  summarise(
    mean_word = mean(log_word_count),
    se_word = sd(log_word_count),
    mean_passive_verbs = mean(passive_verbs_count),
    se_passive_verbs = sd(passive_verbs_count),
    mean_perplexity = mean(log_perplexity_score),
    se_perplexity = sd(log_perplexity_score)
  ) %>% 
  mutate(type = "Human-Generated")

# extreme comments
AI_comments_ex <- 
  dem_rep_comments_merge %>% 
  filter(norm_slant <= quantile(norm_slant, 0.01) |
           norm_slant >= quantile(norm_slant, 0.99)) %>%
  inner_join(AI_treatment_post_chatgpt %>% 
               mutate(date = as.character(date)),
             by = c('subreddit', 'author', 'score', 'total_awards_received', 'created_utc', 'date')) %>% 
  mutate(log_word_count = log(word_count)) %>% 
  summarise(
    mean_word = mean(log_word_count),
    se_word = sd(log_word_count),
    mean_passive_verbs = mean(passive_verbs_count),
    se_passive_verbs = sd(passive_verbs_count),
    mean_perplexity = mean(log_perplexity_score),
    se_perplexity = sd(log_perplexity_score)
  ) %>% 
  mutate(type = "ChatGPT-Generated Extreme")

human_comments_ex <- 
  dem_rep_comments_merge %>% 
  filter(norm_slant <= quantile(norm_slant, 0.01) |
           norm_slant >= quantile(norm_slant, 0.99)) %>%
  anti_join(AI_treatment_post_chatgpt %>% 
              mutate(date = as.character(date)),
            by = c('subreddit', 'author', 'score', 'total_awards_received', 'created_utc', 'date')) %>% 
  mutate(log_word_count = log(word_count)) %>% 
  summarise(
    mean_word = mean(log_word_count),
    se_word = sd(log_word_count),
    mean_passive_verbs = mean(passive_verbs_count),
    se_passive_verbs = sd(passive_verbs_count),
    mean_perplexity = mean(log_perplexity_score),
    se_perplexity = sd(log_perplexity_score)
  ) %>% 
  mutate(type = "Human-Generated Extreme")

combined_comments_ex <- bind_rows(AI_comments, human_comments, AI_comments_ex, human_comments_ex)

combined_emotions_emotion <- 
  combined_comments_ex %>%
  pivot_longer(
    cols = -type,
    names_to = c(".value", "measure"),
    names_pattern = "(mean|se)_(.*)"
  ) %>%
  mutate(measure = as.character(measure)) %>% 
  mutate(measure = ifelse(measure == 'passive_verbs', 'passive verbs',
                          ifelse(measure == 'perplexity', 'perplexity score', 
                                 ifelse(measure == "word", "length (log)", measure)))) %>% 
  mutate(measure = factor(measure, levels = c("passive verbs", "perplexity score", "length (log)"))) %>%
  mutate(type = factor(type, levels = c("ChatGPT-Generated","Human-Generated","ChatGPT-Generated Extreme", "Human-Generated Extreme"))) %>% 
  filter(!measure %in% c("passive verbs", "perplexity score", "length (log)"))

ggplot(combined_emotions_emotion, aes(x = measure, y = mean, color = type)) +
  geom_point(position = position_dodge(width = 0.5), size = 2) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se),
                position = position_dodge(width = 0.5), width = 0.3) +
  labs(
    x = NULL,
    y = "Estimate (standard deviation)",
    title = "ChatGPT vs Human Comments",
    color = NULL
  ) +
  scale_color_manual(values = c(
    "Human-Generated" = "#bcbedd",
    "Human-Generated Extreme" = "#8f69c5",
    "ChatGPT-Generated" = "#afdd8b",
    "ChatGPT-Generated Extreme" = "#5cb07f"
  )) +
  theme_classic() +
  ylim(-0.25, 1) +
  theme(
    legend.position = "bottom",
    legend.margin = margin(t = -10),
    plot.margin = margin(t = 10, r = 20, b = 10, l = 10) 
  ) +
  theme(text = element_text(size = 10),
        axis.text.x = element_text(face = "bold"))

combined_emotions_text <- 
  combined_comments_ex %>%
  pivot_longer(
    cols = -type,
    names_to = c(".value", "measure"),
    names_pattern = "(mean|se)_(.*)"
  ) %>%
  mutate(measure = as.character(measure)) %>% 
  mutate(measure = ifelse(measure == 'passive_verbs', 'passive verbs',
                          ifelse(measure == 'perplexity', 'perplexity score', 
                                 ifelse(measure == "word", "length (log)", measure)))) %>% 
  mutate(measure = factor(measure, levels = c("passive verbs", "perplexity score", "length (log)"))) %>%
  mutate(type = factor(type, levels = c("ChatGPT-Generated","Human-Generated","ChatGPT-Generated Extreme", "Human-Generated Extreme"))) %>% 
  filter(measure %in% c("passive verbs", "perplexity score", "length (log)"))

annotations_df <- data.frame(
  x_axis = c(0.8, 1.2, 1.8, 2.2, 2.8, 3.2),
  y_axis = c(2.1, 2.1, 6.1, 6.1, 4.9, 4.9),
  label = c(
    "<b><i>t-statistic = 206.15<br>P &lt; 0.001***</i></b>",
    "<b><i>t-statistic = 41.02<br>P &lt; 0.001***</i></b>",
    "<b><i>t-statistic = 388.85<br>P &lt; 0.001***</i></b>",
    "<b><i>t-statistic = 47.73<br>P &lt; 0.001***</i></b>",
    "<b><i>t-statistic = 780.11<br>P &lt; 0.001***</i></b>",
    "<b><i>t-statistic = 108.61<br>P &lt; 0.001***</i></b>"
  )
)

ggplot(combined_emotions_text, aes(x = measure, y = mean, color = type)) +
  geom_point(position = position_dodge(width = 0.5), size = 2) +
  geom_errorbar(aes(ymin = mean - se, ymax = mean + se),
                position = position_dodge(width = 0.5), width = 0.3) +
  ylim(-0.5, 7) +
  geom_richtext(
    data = annotations_df,
    aes(x = x_axis, y = y_axis, label = label),
    inherit.aes = FALSE,
    vjust = -0.5,
    size = 3.5,
    fill = NA,   # removes the background box
    label.color = NA,  # removes the border
    color = "black"
  ) +
  labs(
    x = NULL,
    y = "Estimate (standard deviation)",
    title = "ChatGPT vs Human Comments",
    color = NULL
  ) +
  scale_color_manual(values = c(
    "Human-Generated" = "#bcbedd",
    "Human-Generated Extreme" = "#8f69c5",
    "ChatGPT-Generated" = "#afdd8b",
    "ChatGPT-Generated Extreme" = "#5cb07f"
  )) +
  theme_classic() +
  theme(
    legend.position = "bottom",
    legend.margin = margin(t = -10),
    plot.margin = margin(t = 10, r = 20, b = 10, l = 10) 
  ) +
  theme(text = element_text(size = 10),
        axis.text.x = element_text(face = "bold"))

# t-test
human_data <- 
  dem_rep_comments_merge %>%
  anti_join(AI_treatment_post_chatgpt %>%
              mutate(date = as.character(date)),
            by = c('subreddit', 'author', 'score', 'total_awards_received', 'created_utc', 'date')) %>%
  mutate(
    log_word_count = log(word_count),
    group = "Human"
  )

ai_data <- 
  dem_rep_comments_merge %>%
  inner_join(AI_treatment_post_chatgpt %>%
               mutate(date = as.character(date)),
             by = c('subreddit', 'author', 'score', 'total_awards_received', 'created_utc', 'date')) %>%
  mutate(
    log_word_count = log(word_count),
    group = "AI"
  )

human_data_ex <- 
  dem_rep_comments_merge %>%
  filter(norm_slant <= quantile(norm_slant, 0.01) |
           norm_slant >= quantile(norm_slant, 0.99)) %>%
  anti_join(AI_treatment_post_chatgpt %>%
              mutate(date = as.character(date)),
            by = c('subreddit', 'author', 'score', 'total_awards_received', 'created_utc', 'date')) %>%
  mutate(
    log_word_count = log(word_count),
    group = "Human"
  )

# Combine
t_test <- bind_rows(ai_data, human_data)
t_test_ex <- bind_rows(ai_data_ex, human_data_ex)

t_test_passive <- t.test(passive_verbs_count ~ group, data = t_test_ex)
t_test_perplexity <- t.test(log_perplexity_score ~ group, data = t_test_ex)
t_test_length <- t.test(log_word_count ~ group, data = t_test_ex)

t_test_passive
t_test_perplexity
t_test_length
