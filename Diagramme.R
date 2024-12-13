install.packages("tidyverse")
install.packages("ggthemes")
remotes::install_github("christianholland/AachenColorPalette")
install.packages("esquisse")

library(tidyverse)
library(ggthemes)
library(AachenColorPalette)

df <- readRDS("data/data.rds")

display_aachen_colors()

library(ggplot2)

ggplot(df) +
  aes(x = Age) +
  geom_histogram(bins = 30L, fill = aachen_color("magenta")) +
  geom_vline(xintercept = mean(df$Age, na.rm = TRUE)) +
  geom_text(x = mean(df$Age, na.rm = TRUE), y = 25, label = paste0("M = ", round(mean(df$Age, na.rm = TRUE), 2)), angle = 90 , vjust = 1.5) +
  labs(x = "Alter in Jahren", 
       y = "Anzahl", 
       title = paste0("Altersverteilung an Fragebogen teilgenommenn n = (", nrow(df), ")"),
       subtitle = "Histogramm der Altersverteilung", 
       caption = "30 Bins") +
  theme_minimal()

ggsave(filename = "histogram.png", width = 15, height = 12, units = "cm")


library(ggplot2)

df %>% 
 filter(Gender == "Männlich" | Gender == "Weiblich") %>% 
 ggplot() +
 aes(x = ATI, 
     y = Gender) +
 geom_boxplot(fill = aachen_color("purple", "turquoise")) +
 labs(x = "ATI", 
      y = "Geschlecht", 
      title = "Männer haben deskriptiv einen höheren KUT als Frauen", 
      subtitle = "Deskriptiver Vergleich im Boxplot", 
      caption = "Punkte zeigen Außreißer") +
  coord_flip() +
  scale_x_continuous(limits = c(1,6), breaks = c(1:6)) +
 theme_minimal()


ggsave(filename = "boxplot.png", width = 15, height = 12, units = "cm")

library(ggplot2)

ggplot(df) +
 aes(x = Bildungsabschluss, y = big5_1) +
 geom_violin(fill = aachen_color("orange")) +
 labs(x = "Bildungsabschluss", 
      y = "BIG5", 
      title = "Abschluss und Persönlichkeit", 
      subtitle = "Vergleich", 
      caption = " ") +
  coord_flip() +
 theme_minimal()



library(ggplot2)

ggplot(df) +
 aes(x = Vertrauen) +
 geom_density(fill = aachen_color("yellow")) +
 labs(x = " ", 
      y = " ", 
      title = " ", 
      subtitle = " ", 
      caption = " ") +
 theme_minimal()




#Hypothesentests
#Hypothese 1
cor.test(df$Age, df$Vertrauen)

x <- c(df$Age)
y <- c(df$Vertrauen)
cor.test(x, y, method = "pearson")

cor.test(x, y, alternative = "two.sided", method = "pearson", 
         exact = NULL, conf.level = 0.95, continuity = FALSE)

#Hypothese 2
cor.test(df$ATI, df$Privatsphäre)

#Hypothese 3
cor.test(df$Bedienbarkeit, df$Szenario_B)

#Hypothese 4
cor.test(df$Behörden, df$Vertrauen)

#Hypothese 5
cor.test(df$Zeitersparnis, df$Szenario_B)

#Hypothese 6
cor.test(df$Privatsphäre, df$BF_Offenheit)

