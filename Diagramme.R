install.packages("tidyverse")
install.packages("ggthemes")
remotes::install_github("christianholland/AachenColorPalette", force = TRUE)
install.packages("esquisse")


library(tidyverse)
library(ggthemes)
library(AachenColorPalette)
libary()

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
 labs(x = "Vertrauen", 
      y = "Höhe des Vertrauens", 
      title = "Vertrauen in KI", 
      subtitle = " ", 
      caption = " ") +
 theme_minimal()




#Hypothesentests ----
#Zusammenhangshypothese 1 ----
cor.test(df$Age, df$Vertrauen, method = "pearson")

x <- c(df$Age)

y <- c(df$Vertrauen)
cor.test(x, y, method = "pearson")

cor.test(x, y, alternative = "two.sided", method = "pearson", 
         exact = NULL, conf.level = 0.95, continuity = FALSE)

#Diagramm zu Hypothese 1 ----
library(ggplot2)

ggplot(df) +
 aes(x = Age, y = Vertrauen) +
 geom_point(colour = aachen_color("orange")) +
  geom_smooth(method = "lm") +
 labs(x = "Alter in Jahren", 
      y = "Vertrauen in KI-Chatbot", 
      title = "Zusammenhang zwischen Alter und Vertrauen in KI-Chatbot", 
      subtitle = "Punktdiagramm mit linearer Regressionsgraden", 
      caption = "Schattierung zeigt 95%-Konfidenzbereich der Regressionsgrade") +
 theme_minimal()



#Zusammenhangshypothese 2 ----
cor.test(df$Behoerden, df$Vertrauen, method = "pearson")

#Diagramm zu Hypothese 2 ----

library(ggplot2)

ggplot(df) +
 aes(x = Behoerden, y = Vertrauen) +
 geom_jitter(shape = 21, colour = aachen_color("magenta"), fill = aachen_color("yellow")) +
  geom_smooth(method = "lm") +
  scale_y_continuous(limits = c(0.75,6.25), breaks = c(1:6)) +
  scale_x_continuous(limits = c(0.75,6.25), breaks = c(1:6)) +
  labs(x = "Einstellung gegenüber Kommunalverwaltung", 
      y = "Vertrauen in KI-Chatbot", 
      title = "Zusammenhang zwischen Eintsellun ggü. Kommunalververwaltung und Vertrauen in KI-Chatbot", 
      subtitle = "Punktdiagramm mit linearer Regressionsgraden", 
      caption = "Schattierung zeigt 95%-Konfidenzbereich der Regressionsgrade") +
 theme_minimal()

#Zusammenhangshypothese 3 ----
cor.test(df$Zeitersparnis, df$Szenario_B, method = "pearson")

#Diagramm zu Hypothese 3 ---


library(ggplot2)

ggplot(df) +
 aes(x = Szenario_B_BI, y = Zeitersparnis) +
 geom_jitter(shape = 21, colour = aachen_color("blue"), fill = aachen_color("orange50")) +
  geom_smooth(method = "lm") +
  scale_y_continuous(limits = c(0.75,6.25), breaks = c(1:6)) +
  scale_x_continuous(limits = c(0.75,6.25), breaks = c(1:6)) +
 labs(x = "Nutzungsintention", 
       y = "Zeitaufwand", 
       title = "Zusammenhang zwischen Zeitaufwand und Nutzungsintention des KI-Chatbots", 
       subtitle = "Punktdiagramm mit linearer Regressionsgraden", 
       caption = "Schattierung zeigt 95%-Konfidenzbereich der Regressionsgrade") +
theme_minimal()


#Zusammenhangsypothese 4 ----
cor.test(df$Privatsphäre, df$BF_Offenheit, method = "pearson")

#Diagramm zu Hypothese 4 ----

library(ggplot2)

ggplot(df) +
 aes(x = Privatsphäre, y = BF_Offenheit) +
 geom_jitter(shape = 21, colour = aachen_color("bordeaux"), fill = aachen_color("maygreen50")) +
  geom_smooth(method = "lm") +
  scale_y_continuous(limits = c(0.75,6.25), breaks = c(1:6)) +
  scale_x_continuous(limits = c(0.75,6.25), breaks = c(1:6)) +
 labs(x = "Privatsphärewahrnehmung", 
      y = "Offenheit einer Person", 
      title = "Zusammenhang zwischen Privatsphärewahrnehmung und Offenheit einer Person", 
      subtitle = "Punktdiagramm mit linearer Regressionsgraden", 
      caption = "Schattierung zeigt 95%-Konfidenzbereich der Regressionsgrade") +
 theme_minimal()


#komplexe Unterschiedshypothese ----
anova(data, dep = "Szenario_B_BI", factors = c("Bildungsabschluss", "Wohnort"))


library(ggplot2)

ggplot(df) +
 aes(x = Szenario_B_BI, y = Bildungsabschluss, fill = Wohnort) +
 geom_boxplot() +
 scale_fill_hue(direction = 1) +
 labs(x = "Nutzungsintention", y = "Schulabschluss", 
      title = "Einfluss von Schulabschluss und Wohnort auf die Nutzungsintention", 
      subtitle = "Deskriptiver Vergleich im Boxplot", 
      caption = "Punkte zeigen Außreißer") +
  scale_x_continuous(limits = c(1,5), breaks = c(1:5)) +
 theme_minimal()


