library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)
library(data.table)
library(forcats)

# total comments
total_comments <-
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/241103_recalculate/3_analysis/total_comments.csv', header = TRUE, stringsAsFactors = FALSE)

# AI detector
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

# democrat (infection) / Republican (activation)
active_dem_comments <-
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/dem_active_merge.csv', header = TRUE, stringsAsFactors = FALSE) %>%
  mutate(
    created_utc = floor_date(ymd_hms(created_utc), unit = "hour")
  ) %>% 
  group_by(created_utc, date) %>%
  summarise(norm_slant_rep = mean(norm_slant))

# baseline
active_dem_baseline <-
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/dem_active_merge.csv', header = TRUE, stringsAsFactors = FALSE) %>%
  mutate(
    created_utc = floor_date(ymd_hms(created_utc), unit = "hour")
  )

# ChatGPT-generated extreme comments
generate_AI_inactive_dem_comments <- function(hour_expand) {
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/dem_inactive_merge.csv') %>%
    filter(date > "2022-11-30") %>%
    filter(norm_slant <= quantile(norm_slant, 0.01)) %>%
    mutate(
      date = as.Date(date),
      hour = hour(created_utc),
      datetime_start = created_utc,
      datetime_end = created_utc + hours(hour_expand)
    ) %>%
    left_join(
      active_dem_comments %>%
        distinct(created_utc, norm_slant_rep),
      join_by(
        datetime_start <= created_utc,
        datetime_end >= created_utc
      )
    ) %>% 
    group_by(subreddit, author, score, total_awards_received, date, created_utc.x, datetime_start, datetime_end, day_month, dow) %>%
    summarise(norm_slant_rep = mean(norm_slant_rep), .groups = 'drop') %>%
    filter(!is.na(norm_slant_rep)) %>%
    as.data.frame() %>%
    mutate(created_utc.x = as.character(created_utc.x)) %>%
    inner_join(AI_treatment_post_chatgpt,
               by = c('author', 'subreddit', 'score', 'total_awards_received', 'created_utc.x' = 'created_utc', 'date')) %>%
    summarise(avg_slant_reply = mean(norm_slant_rep),
              se_slant_reply = sd(norm_slant_rep)/sqrt(n()),
              .groups = 'drop') %>%
    mutate(
      label = 'ChatGPT-Generated Extreme',
      color = paste0(hour_expand, " hours")
    )
}

AI_inactive_dem_comments_3 <- generate_AI_inactive_dem_comments(3)
AI_inactive_dem_comments_6 <- generate_AI_inactive_dem_comments(6)
AI_inactive_dem_comments_9 <- generate_AI_inactive_dem_comments(9)
AI_inactive_dem_comments_12 <- generate_AI_inactive_dem_comments(12)
AI_inactive_dem_comments_15 <- generate_AI_inactive_dem_comments(15)
AI_inactive_dem_comments_18 <- generate_AI_inactive_dem_comments(18)
AI_inactive_dem_comments_21 <- generate_AI_inactive_dem_comments(21)
AI_inactive_dem_comments_24 <- generate_AI_inactive_dem_comments(24)

# human generated extreme
generate_inactive_dem_comments <- function(hour_expand) {
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/dem_inactive_merge.csv') %>%
    filter(date > '2022-11-30') %>%
    filter(norm_slant <= quantile(norm_slant, 0.01)) %>%
    mutate(
      date = as.Date(date),
      hour = hour(created_utc),
      datetime_start = created_utc,
      datetime_end = created_utc + hours(hour_expand)
    ) %>%
    left_join(
      active_dem_comments %>% 
        distinct(created_utc, norm_slant_rep),
      join_by(datetime_start <= created_utc, datetime_end >= created_utc)
    ) %>%
    group_by(subreddit, author, score, total_awards_received,
             date, created_utc.x, datetime_start, datetime_end, day_month, dow) %>%
    summarise(norm_slant_rep = mean(norm_slant_rep), .groups = "drop") %>%
    filter(!is.na(norm_slant_rep)) %>%
    mutate(created_utc.x = as.character(created_utc.x)) %>%
    anti_join(AI_treatment_post_chatgpt,
              by = c('author', 'subreddit', 'score', 'total_awards_received', 'created_utc.x' = 'created_utc', 'date')) %>%
    summarise(avg_slant_reply = mean(norm_slant_rep),
              se_slant_reply = sd(norm_slant_rep) / sqrt(n())) %>% 
    mutate(
      label = 'Human-Generated Extreme',
      color = paste0(hour_expand, " hours")
    )
}

inactive_dem_comments_3 <- generate_inactive_dem_comments(3)
inactive_dem_comments_6 <- generate_inactive_dem_comments(6)
inactive_dem_comments_9 <- generate_inactive_dem_comments(9)
inactive_dem_comments_12 <- generate_inactive_dem_comments(12)
inactive_dem_comments_15 <- generate_inactive_dem_comments(15)
inactive_dem_comments_18 <- generate_inactive_dem_comments(18)
inactive_dem_comments_21 <- generate_inactive_dem_comments(21)
inactive_dem_comments_24 <- generate_inactive_dem_comments(24)

# AI generated extreme
baseline_AI_dem_author <- function(hour_expand) {
  dem_comments_authors <-
    fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/dem_inactive_merge.csv') %>%
    filter(date > '2022-11-30') %>%
    filter(norm_slant <= quantile(norm_slant, 0.01)) %>%
    mutate(
      date = as.Date(date),
      hour = hour(created_utc),
      datetime_start = created_utc,
      datetime_end = created_utc + hours(hour_expand)
    ) %>% 
    select(subreddit, author, score, total_awards_received, date, created_utc, datetime_start, datetime_end, day_month, dow) %>% 
    mutate(created_utc = as.character(created_utc)) %>% 
    inner_join(AI_treatment_post_chatgpt,
               by = c('author', 'subreddit', 'score', 'total_awards_received', 'created_utc', 'date'))%>% 
    inner_join(
      active_dem_baseline %>% 
        rename(author_reply = author,
               created_utc_reply = created_utc) %>% 
        distinct(author_reply, created_utc_reply),
      join_by(
        datetime_start <= created_utc_reply,
        datetime_end >= created_utc_reply
      )
    ) %>% 
    distinct(author_reply)
  
  output <- 
    total_comments %>%
    filter(date >= "2022-09-29",
           date <= "2022-11-29") %>%
    inner_join(dem_comments_authors,
               by = c('author'='author_reply')) %>%
    summarise(avg_slant_reply = mean(norm_slant),
              se_slant_reply = sd(norm_slant)/sqrt(n())) %>% 
    mutate(label = "ChatGPT-generated-baseline",
           color = paste0(hour_expand, " hours"))
  
  return(output)
}

# Human generated extreme 
baseline_human_dem_author <- function(hour_expand) {
  human_dem_pre_control <-
    fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/dem_inactive_merge.csv') %>%
    filter(date > '2022-11-30') %>%
    filter(norm_slant <= quantile(norm_slant, 0.01)) %>%
    mutate(
      date = as.Date(date),
      hour = hour(created_utc),
      datetime_start = created_utc,
      datetime_end = created_utc + hours(hour_expand)
    ) %>%
    select(subreddit, author, score, total_awards_received, date, created_utc, datetime_start, datetime_end, day_month, dow) %>%
    mutate(created_utc = as.character(created_utc)) %>%
    anti_join(AI_treatment_post_chatgpt,
              by = c('author', 'subreddit', 'score', 'total_awards_received', 'created_utc', 'date'))%>%
    inner_join(
      active_dem_baseline %>%
        rename(author_reply = author,
               created_utc_reply = created_utc) %>%
        distinct(author_reply, created_utc_reply),
      join_by(
        datetime_start <= created_utc_reply,
        datetime_end >= created_utc_reply
      )
    ) %>%
    distinct(author_reply)
  
  output <-
    total_comments %>%
    filter(date >= "2022-09-29",
           date <= "2022-11-29") %>%
    inner_join(human_dem_pre_control,
               by = c('author'='author_reply')) %>%
    summarise(avg_slant_reply = mean(norm_slant),
              se_slant_reply = sd(norm_slant)/sqrt(n())) %>% 
    mutate(label = "Human-generated-baseline",
           color = paste0(hour_expand, " hours"))
  
  return(output)
}

baseline_AI_dem_author_3 <- baseline_AI_dem_author(3)
baseline_human_dem_author_3 <- baseline_human_dem_author(3)
baseline_AI_dem_author_6 <- baseline_AI_dem_author(6)
baseline_human_dem_author_6 <- baseline_human_dem_author(6)
baseline_AI_dem_author_9 <- baseline_AI_dem_author(9)
baseline_human_dem_author_9 <- baseline_human_dem_author(9)
baseline_AI_dem_author_12 <- baseline_AI_dem_author(12)
baseline_human_dem_author_12 <- baseline_human_dem_author(12)
baseline_AI_dem_author_15 <- baseline_AI_dem_author(15)
baseline_human_dem_author_15 <- baseline_human_dem_author(15)
baseline_AI_dem_author_18 <- baseline_AI_dem_author(18)
baseline_human_dem_author_18 <- baseline_human_dem_author(18)
baseline_AI_dem_author_21 <- baseline_AI_dem_author(21)
baseline_human_dem_author_21 <- baseline_human_dem_author(21)
baseline_AI_dem_author_24 <- baseline_AI_dem_author(24)
baseline_human_dem_author_24 <- baseline_human_dem_author(24)

combined_dem_comments <- rbind(
  AI_inactive_dem_comments_3,
  AI_inactive_dem_comments_6,
  AI_inactive_dem_comments_9,
  AI_inactive_dem_comments_12,
  AI_inactive_dem_comments_15,
  AI_inactive_dem_comments_18,
  AI_inactive_dem_comments_21,
  AI_inactive_dem_comments_24,
  inactive_dem_comments_3,
  inactive_dem_comments_6,
  inactive_dem_comments_9,
  inactive_dem_comments_12,
  inactive_dem_comments_15,
  inactive_dem_comments_18,
  inactive_dem_comments_21,
  inactive_dem_comments_24,
  baseline_AI_dem_author_3,
  baseline_AI_dem_author_6,
  baseline_AI_dem_author_9,
  baseline_AI_dem_author_12,
  baseline_AI_dem_author_15,
  baseline_AI_dem_author_18,
  baseline_AI_dem_author_21,
  baseline_AI_dem_author_24,
  baseline_human_dem_author_3,
  baseline_human_dem_author_6,
  baseline_human_dem_author_9,
  baseline_human_dem_author_12,
  baseline_human_dem_author_15,
  baseline_human_dem_author_18,
  baseline_human_dem_author_21,
  baseline_human_dem_author_24
)

dem_comments_plot <- 
  combined_dem_comments %>%
  select(color, label, avg_slant_reply, se_slant_reply) %>%
  rename(avg_slant = avg_slant_reply, se_slant = se_slant_reply) %>%
  mutate(color = as.character(color)) %>% 
  mutate(color = fct_relevel(color, "3 hours", "6 hours","9 hours","12 hours","15 hours","18 hours","21 hours","24 hours")) %>% 
  mutate(label = factor(label, levels = c("Human-Generated Extreme","Human-generated-baseline", "ChatGPT-Generated Extreme","ChatGPT-generated-baseline")))

dem_comments_diff <- 
  dem_comments_plot %>%
  group_by(color) %>%
  summarise(
    diff_human = avg_slant[label == "Human-Generated Extreme"] - avg_slant[label == "Human-generated-baseline"],
    se_human = se_slant[label == "Human-Generated Extreme"],
    
    diff_chatgpt = avg_slant[label == "ChatGPT-Generated Extreme"] - avg_slant[label == "ChatGPT-generated-baseline"],
    se_chatgpt = se_slant[label == "ChatGPT-Generated Extreme"]
  ) %>%
  pivot_longer(
    cols = c(diff_human, diff_chatgpt, se_human, se_chatgpt),
    names_to = c(".value", "group"),
    names_sep = "_"
  ) %>%
  mutate(
    group = recode(group,
                   human = "Human-Generated Extreme",
                   chatgpt = "ChatGPT-Generated Extreme")
  )

ggplot(dem_comments_diff, aes(y = color, x = diff, color = group)) +
  geom_point(position = position_dodge(width = 0.5), size = 3) +
  geom_errorbar(aes(xmin = diff - se, xmax = diff + se),
                position = position_dodge(width = 0.5), width = 0.3) +
  labs(title = "Political Slant of Active Liberal-leaning Respondents Following Comments Posted by Inactive Liberals",
       subtitle = "Baseline - average political slant of respondents 60 days prior to the introduction of ChatGPT",
       y = NULL, 
       x = "Political Slant", 
       color = NULL) +
  theme_classic() +
  scale_color_manual(values = c(
    "Human-Generated Extreme" = "#8f69c5",
    "ChatGPT-Generated Extreme" = "#5cb07f"
  )) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "black") +
  xlim(-0.0004, 0.0004) +
  theme(
    legend.position = "bottom",
    legend.margin = margin(t = -10),
    plot.margin = margin(t = 10, r = 20, b = 10, l = 10) 
  ) +
  theme(text = element_text(size = 12),
        axis.text.y = element_text(face = "bold"))

# republican (infection) / democrat (activation)
active_rep_comments <- 
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/dem_active_merge.csv', header = TRUE, stringsAsFactors = FALSE)%>%
  mutate(
    created_utc = floor_date(ymd_hms(created_utc), unit = "hour")
  ) %>%
  group_by(created_utc, date) %>%
  summarise(norm_slant_rep = mean(norm_slant))

# republican baseline
active_rep_baseline <- 
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/dem_active_merge.csv', header = TRUE, stringsAsFactors = FALSE) %>% 
  mutate(
    created_utc = floor_date(ymd_hms(created_utc), unit = "hour")
  )

# ChatGPT-generated extreme comments
generate_AI_inactive_rep_comments <- function(hour_expand) {
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/rep_inactive_merge.csv') %>%
    filter(date > "2022-11-30") %>% 
    filter(norm_slant >= quantile(norm_slant, 0.99)) %>%
    mutate(
      date = as.Date(date),
      hour = hour(created_utc),
      datetime_start = created_utc,
      datetime_end = created_utc + hours(hour_expand)
    ) %>%
    left_join(
      active_rep_comments %>% 
        distinct(created_utc, norm_slant_rep),
      join_by(
        datetime_start <= created_utc,
        datetime_end >= created_utc
      )
    ) %>% 
    group_by(subreddit, author, score, total_awards_received, date, created_utc.x, datetime_start, datetime_end, day_month, dow) %>% 
    summarise(norm_slant_rep = mean(norm_slant_rep), .groups = 'drop') %>%
    filter(!is.na(norm_slant_rep)) %>% 
    as.data.frame() %>% 
    mutate(created_utc.x = as.character(created_utc.x)) %>% 
    inner_join(AI_treatment_post_chatgpt,
               by = c('author', 'subreddit', 'score', 'total_awards_received', 'created_utc.x' = 'created_utc', 'date')) %>% 
    summarise(avg_slant_reply = mean(norm_slant_rep),
              se_slant_reply = sd(norm_slant_rep)/sqrt(n()),
              .groups = 'drop') %>% 
    mutate(
      label = 'ChatGPT-Generated Extreme',
      color = paste0(hour_expand, " hours")
    )
}

AI_inactive_rep_comments_3 <- generate_AI_inactive_rep_comments(3)
AI_inactive_rep_comments_6 <- generate_AI_inactive_rep_comments(6)
AI_inactive_rep_comments_9 <- generate_AI_inactive_rep_comments(9)
AI_inactive_rep_comments_12 <- generate_AI_inactive_rep_comments(12)
AI_inactive_rep_comments_15 <- generate_AI_inactive_rep_comments(15)
AI_inactive_rep_comments_18 <- generate_AI_inactive_rep_comments(18)
AI_inactive_rep_comments_21 <- generate_AI_inactive_rep_comments(21)
AI_inactive_rep_comments_24 <- generate_AI_inactive_rep_comments(24)

# human generated extreme
generate_inactive_rep_comments <- function(hour_expand) {
  fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/rep_inactive_merge.csv') %>%
    filter(date > '2022-11-30') %>%
    filter(norm_slant >= quantile(norm_slant, 0.99)) %>%
    mutate(
      date = as.Date(date),
      hour = hour(created_utc),
      datetime_start = created_utc,
      datetime_end = created_utc + hours(hour_expand)
    ) %>%
    left_join(
      active_rep_comments %>% 
        distinct(created_utc, norm_slant_rep),
      join_by(datetime_start <= created_utc, datetime_end >= created_utc)
    ) %>%
    group_by(subreddit, author, score, total_awards_received,
             date, created_utc.x, datetime_start, datetime_end, day_month, dow) %>%
    summarise(norm_slant_rep = mean(norm_slant_rep), .groups = "drop") %>%
    filter(!is.na(norm_slant_rep)) %>%
    mutate(created_utc.x = as.character(created_utc.x)) %>%
    anti_join(AI_treatment_post_chatgpt,
              by = c('author', 'subreddit', 'score', 'total_awards_received', 'created_utc.x' = 'created_utc', 'date')) %>%
    summarise(avg_slant_reply = mean(norm_slant_rep),
              se_slant_reply = sd(norm_slant_rep) / sqrt(n())) %>% 
    mutate(
      label = 'Human-Generated Extreme',
      color = paste0(hour_expand, " hours")
    )
}

inactive_rep_comments_3 <- generate_inactive_rep_comments(3)
inactive_rep_comments_6 <- generate_inactive_rep_comments(6)
inactive_rep_comments_9 <- generate_inactive_rep_comments(9)
inactive_rep_comments_12 <- generate_inactive_rep_comments(12)
inactive_rep_comments_15 <- generate_inactive_rep_comments(15)
inactive_rep_comments_18 <- generate_inactive_rep_comments(18)
inactive_rep_comments_21 <- generate_inactive_rep_comments(21)
inactive_rep_comments_24 <- generate_inactive_rep_comments(24)

# AI generated extreme
baseline_AI_rep_author <- function(hour_expand) {
  rep_comments_authors <-
    fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/rep_inactive_merge.csv') %>%
    filter(date > '2022-11-30') %>%
    filter(norm_slant >= quantile(norm_slant, 0.99)) %>%
    mutate(
      date = as.Date(date),
      hour = hour(created_utc),
      datetime_start = created_utc,
      datetime_end = created_utc + hours(hour_expand)
    ) %>%
    select(subreddit, author, score, total_awards_received, date, created_utc, datetime_start, datetime_end, day_month, dow) %>%
    mutate(created_utc = as.character(created_utc)) %>%
    inner_join(AI_treatment_post_chatgpt,
               by = c('author', 'subreddit', 'score', 'total_awards_received', 'created_utc', 'date'))%>%
    inner_join(
      active_rep_baseline %>%
        rename(author_reply = author,
               created_utc_reply = created_utc) %>%
        distinct(author_reply, created_utc_reply),
      join_by(
        datetime_start <= created_utc_reply,
        datetime_end >= created_utc_reply
      )
    ) %>%
    distinct(author_reply)
  
  output <-
    total_comments %>%
    filter(date >= "2022-09-29",
           date <= "2022-11-29") %>%
    inner_join(rep_comments_authors,
               by = c('author'='author_reply')) %>%
    summarise(avg_slant_reply = mean(norm_slant),
              se_slant_reply = sd(norm_slant)/sqrt(n())) %>% 
    mutate(label = "ChatGPT-generated-baseline",
           color = paste0(hour_expand, " hours"))
  
  return(output)
}

# Human generated extreme
baseline_human_rep_author <- function(hour_expand) {
  human_rep_pre_control <-
    fread('/Volumes/Seagate_5T/Reddit_chatgpt/250206_merge/250312_update/active_inactive/rep_inactive_merge.csv') %>%
    filter(date > '2022-11-30') %>%
    filter(norm_slant >= quantile(norm_slant, 0.99)) %>%
    mutate(
      date = as.Date(date),
      hour = hour(created_utc),
      datetime_start = created_utc,
      datetime_end = created_utc + hours(hour_expand)
    ) %>%
    select(subreddit, author, score, total_awards_received, date, created_utc, datetime_start, datetime_end, day_month, dow) %>%
    mutate(created_utc = as.character(created_utc)) %>%
    anti_join(AI_treatment_post_chatgpt,
              by = c('author', 'subreddit', 'score', 'total_awards_received', 'created_utc', 'date'))%>%
    inner_join(
      active_rep_baseline %>%
        rename(author_reply = author,
               created_utc_reply = created_utc) %>%
        distinct(author_reply, created_utc_reply),
      join_by(
        datetime_start <= created_utc_reply,
        datetime_end >= created_utc_reply
      )
    ) %>%
    distinct(author_reply)
  
  output <-
    total_comments %>%
    filter(date >= "2022-09-29",
           date <= "2022-11-29") %>%
    inner_join(human_rep_pre_control,
               by = c('author'='author_reply')) %>%
    summarise(avg_slant_reply = mean(norm_slant),
              se_slant_reply = sd(norm_slant)/sqrt(n())) %>% 
    mutate(label = "Human-generated-baseline",
           color = paste0(hour_expand, " hours"))
  
  return(output)
}

baseline_AI_rep_author_3 <- baseline_AI_rep_author(3)
baseline_human_rep_author_3 <- baseline_human_rep_author(3)
baseline_AI_rep_author_6 <- baseline_AI_rep_author(6)
baseline_human_rep_author_6 <- baseline_human_rep_author(6)
baseline_AI_rep_author_9 <- baseline_AI_rep_author(9)
baseline_human_rep_author_9 <- baseline_human_rep_author(9)
baseline_AI_rep_author_12 <- baseline_AI_rep_author(12)
baseline_human_rep_author_12 <- baseline_human_rep_author(12)
baseline_AI_rep_author_15 <- baseline_AI_rep_author(15)
baseline_human_rep_author_15 <- baseline_human_rep_author(15)
baseline_AI_rep_author_18 <- baseline_AI_rep_author(18)
baseline_human_rep_author_18 <- baseline_human_rep_author(18)
baseline_AI_rep_author_21 <- baseline_AI_rep_author(21)
baseline_human_rep_author_21 <- baseline_human_rep_author(21)
baseline_AI_rep_author_24 <- baseline_AI_rep_author(24)
baseline_human_rep_author_24 <- baseline_human_rep_author(24)

combined_rep_comments <- rbind(
  AI_inactive_rep_comments_3,
  AI_inactive_rep_comments_6,
  AI_inactive_rep_comments_9,
  AI_inactive_rep_comments_12,
  AI_inactive_rep_comments_15,
  AI_inactive_rep_comments_18,
  AI_inactive_rep_comments_21,
  AI_inactive_rep_comments_24,
  inactive_rep_comments_3,
  inactive_rep_comments_6,
  inactive_rep_comments_9,
  inactive_rep_comments_12,
  inactive_rep_comments_15,
  inactive_rep_comments_18,
  inactive_rep_comments_21,
  inactive_rep_comments_24,
  baseline_AI_rep_author_3,
  baseline_AI_rep_author_6,
  baseline_AI_rep_author_9,
  baseline_AI_rep_author_12,
  baseline_AI_rep_author_15,
  baseline_AI_rep_author_18,
  baseline_AI_rep_author_21,
  baseline_AI_rep_author_24,
  baseline_human_rep_author_3,
  baseline_human_rep_author_6,
  baseline_human_rep_author_9,
  baseline_human_rep_author_12,
  baseline_human_rep_author_15,
  baseline_human_rep_author_18,
  baseline_human_rep_author_21,
  baseline_human_rep_author_24
)

rep_comments_plot <- 
  combined_rep_comments %>%
  select(color, label, avg_slant_reply, se_slant_reply) %>%
  rename(avg_slant = avg_slant_reply, se_slant = se_slant_reply) %>%
  mutate(color = as.character(color)) %>% 
  mutate(color = fct_relevel(color, "3 hours", "6 hours","9 hours","12 hours","15 hours","18 hours","21 hours","24 hours")) %>% 
  mutate(label = factor(label, levels = c("Human-Generated Extreme","Human-generated-baseline", "ChatGPT-Generated Extreme","ChatGPT-generated-baseline")))

rep_comments_diff <- 
  rep_comments_plot %>%
  group_by(color) %>%
  summarise(
    diff_human = avg_slant[label == "Human-Generated Extreme"] - avg_slant[label == "Human-generated-baseline"],
    se_human = se_slant[label == "Human-Generated Extreme"],
    
    diff_chatgpt = avg_slant[label == "ChatGPT-Generated Extreme"] - avg_slant[label == "ChatGPT-generated-baseline"],
    se_chatgpt = se_slant[label == "ChatGPT-Generated Extreme"]
  ) %>%
  pivot_longer(
    cols = c(diff_human, diff_chatgpt, se_human, se_chatgpt),
    names_to = c(".value", "group"),
    names_sep = "_"
  ) %>%
  mutate(
    group = recode(group,
                   human = "Human-Generated Extreme",
                   chatgpt = "ChatGPT-Generated Extreme")
  )

ggplot(rep_comments_diff, aes(y = color, x = diff, color = group)) +
  geom_point(position = position_dodge(width = 0.5), size = 3) +
  geom_errorbar(aes(xmin = diff - se, xmax = diff + se),
                position = position_dodge(width = 0.5), width = 0.3) +
  labs(title = "Political Slant of Active Liberal-leaning Respondents Following Comments Posted by Inactive Conservatives",
       subtitle = "Baseline - average political slant of respondents 60 days prior to the introduction of ChatGPT",
       y = NULL, 
       x = "Political Slant", 
       color = NULL) +
  theme_classic() +
  scale_color_manual(values = c(
    "Human-Generated Extreme" = "#8f69c5",
    "ChatGPT-Generated Extreme" = "#5cb07f"
  )) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "black") +
  xlim(-0.0004, 0.0004) +
  theme(
    legend.position = "bottom",
    legend.margin = margin(t = -10),
    plot.margin = margin(t = 10, r = 20, b = 10, l = 10) 
  ) +
  theme(text = element_text(size = 12),
        axis.text.y = element_text(face = "bold"))

