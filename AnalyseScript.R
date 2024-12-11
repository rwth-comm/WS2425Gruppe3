library(pwr)
pwr::pwr.t.test(n = 220, sig.level = 0.05 , d = NULL, power = 0.8)

# Pakete aktivieren ----
library(tidyverse)
library(psych)
source("qualtricshelpers.R")

# Daten einlesen ----
raw <- load_qualtrics_csv("data/Methodenseminar+WS2425_6.+Dezember+2024_13.12.csv")

# Rohdaten filtern ----
raw %>% 
  filter(Progress == 100) %>% 
  filter(Status == 2) -> raw

# Überflüssige Variablen entfernen ----
raw.short <- raw[,c(-1,-2,-4,-8:-18,-23,-26:-28,-38:-49,-56:-77,-98:-111)]

# Variablen umbenennen ----

dput(names(raw.short))

names(raw.short) <- c("Status", "Progress", "Duration (in seconds)", "Finished", "Gender", "Age", "Bildungsabschluss", "Wohnort", 
                      "big5_1", "big5_2n", 
                      "ati_1", "ati_2", "ati_3n", "ati_4", "ati_5", "ati_6n", "ati_7", "ati_8n", "ati_9", 
                      "behörden_1", "behörden_2", "behörden_3", "behörden_4", "behörden_5", "behörden_6n", 
                      "sz_B_1", "sz_B_2", "sz_B_3", "sz_B_4", "sz_B_5", "sz_B_6", 
                      "privat_B_1n", "privat_B_2n", "privat_B_3n", "privat_B_4", "privat_B_5", 
                      "vertrauen_B_1", "vertrauen_B_2", 
                      "bedienenb_B_1", "bedienenb_B_2", "bedienenb_B_3", "bedienenb_B_4", "bedienenb_B_5", 
                      "zeit_B_1", "zeit_B_2", 
                      "FL_15_DO_SzenarioA", "FL_15_DO_SzenarioB", "FL_15_DO_SzenarioC")

generate_codebook(raw.short, "data/Methodenseminar+WS2425_6.+Dezember+2024_13.12.csv", "data/codebook.csv")
codebook <- read_codebook("data/codebook_final.csv")
names(raw.short) <- codebook$variable

# Korrekte Datentypen zuordnen ----

raw.short$Age %>% 
  as.numeric() -> raw.short$Age

raw.short$Gender %>% 
  recode(`1` = "Männlich", `2` = "Weiblich", `3` = "Divers", `4`= "keine Angabe") %>% 
  as.factor() -> raw.short$Gender


raw.short$Bildungsabschluss %>% 
  ordered(levels = c(1:5),
          labels = c("(noch) kein Schulabschluss", 
                     "Hauptschulabschluss",
                     "Realschulabschluss",
                     "Abitur",
                     "Hochschulabschluss")) -> raw.short$Edu

raw.short$Bildungsabschluss %>%  recode(`1` = "(noch) kein Schulabschluss", 
                              `2` = "Hauptschulabschluss",
                              `3` = "Realschulabschluss",
                              `4` = "Abitur",
                              `5` = "Hochschulabschluss") %>% 
  as.factor() -> raw.short$Bildungsabschluss

# Qualitätskontrolle ----

# Skalenwerte berechnen ----

schluesselliste <- list(
  BF_Extraversion = c("-bf_1n","bf_6"),
  BF_Agreeableness = c("bf_2","-bf_7n"),
  BF_Openness = c("-bf_5n", "bf_10"),
  BF_Neuroticism = c("-bf_4n", "bf_9"),
  BF_Concientiousness= c("-bf_3n", "bf_8"),
  ATI = vars4psych(raw.short, "ati"), 
  PRO = c("wrfq_1","wrfq_2","wrfq_3","wrfq_4","wrfq_9"),
  PRE = c("wrfq_5","wrfq_6","wrfq_7","wrfq_8"),
  SVI = vars4psych(raw.short, "svi")
)

scores <- scoreItems(schluesselliste, items = raw.short, min = 1, max = 6)

scores$alpha

data <- bind_cols(raw.short, scores$scores)

# Daten exportieren ----
write_rds(data, "data/data.rds")





