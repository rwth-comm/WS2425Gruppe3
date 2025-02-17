library(pwr)
pwr::pwr.t.test(n = 220, sig.level = 0.05 , d = NULL, power = 0.8)

# Pakete aktivieren ----
library(tidyverse)
library(psych)
source("qualtricshelpers.R")

# Daten einlesen ----
raw <- load_qualtrics_csv("data/Methodenseminar+WS2425_10.+Januar+2025_09.51.csv")



# Rohdaten filtern ----
raw %>% 
  filter(Progress == 100) %>% 
  filter(Status == 0) -> raw

# Überflüssige Variablen entfernen ----
raw.short <- raw[,c(-1,-2,-4,-8,-10:-18,-23,-26:-28,-38:-49,-56:-62,-64:-75, -94:-106)]


# Variablen umbenennen ----

generate_codebook(raw.short, "data/Methodenseminar+WS2425_10.+Januar+2025_09.51.csv", "data/codebook.csv")
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
                     "Hochschulabschluss")) -> raw.short$Bildungsabschluss 

raw.short$Wohnort %>%
  ordered(levels = c(1:3),
          labels = c("Ländlich", 
                     "Vorort/Kleinstadt", 
                     "Großstadt")) -> raw.short$Wohnort

# Geschlechterverhältnis
table(raw.short$Gender)
table(raw.short.quality$Gender)

#Alter (min, max, M, SD)
summary(raw.short$Age)
summary(raw.short.quality$Age)

#Bildungsabschluss
table(raw.short$Bildungsabschluss)
table(raw.short.quality$Bildungsabschluss)

#Wohnort
table(raw.short$Wohnort)
table(raw.short.quality$Wohnort)

# Qualitätskontrolle ----

raw.short.quality <- careless_indices(raw.short, likert_vector = c(10:45), speeder_analysis = "Median/2")

raw.short.quality %>%
  filter(speeder_flag==FALSE) %>%
  filter(careless_longstr < 15) -> raw.short.quality

# Skalenwerte berechnen ----

schluesselliste <- list(
  BF_Offenheit = c("big5_1", "-big5_2n"),
  ATI = vars4psych(raw.short, "ati"),
  Behoerden = c("behoerden_1", "behoerden_2", "behoerden_3", "behoerden_4", "behoerden_5", "-behoerden_6n"),
  Szenario_B_BI = c("sz_B_1", "sz_B_2", "sz_B_3"),
  Szenario_B_ATT = c("sz_B_4", "sz_B_5", "sz_B_6"),
  Privatsphäre = c("-privat_B_1n", "-privat_B_2n", "-privat_B_3n"),
  Vertrauen = c("vertrauen_B_1", "vertrauen_B_2"),
  Bedienbarkeit = c("bedienenb_B_1", "bedienenb_B_2", "bedienenb_B_3", "bedienenb_B_4", "bedienenb_B_5"),
  Zeitersparnis = c("zeit_B_1", "zeit_B_2")
)


scores <- scoreItems(schluesselliste, items = raw.short, min = 1, max = 6)

scores$alpha

data <- bind_cols(raw.short, scores$scores)


# Daten exportieren ----
write_rds(data, "data/data.rds")





