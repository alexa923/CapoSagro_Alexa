######################## TOP 30 pour les mammifères, poissons et plantes (Avec séparation Marins/Terrestres)

library(tidyverse)

# 1. IMPORTER ET NETTOYER LES DONNÉES
df <- read.csv2("results_table_assignation.txt.csv")  
df <- df[, 1:7] # Garde uniquement les 7 premières colonnes
colnames(df) <- c("Taxonomy", "sed6_merge", "sed6_unmerge", "sed8_merge", "sed8_unmerge", "sed6total", "sed8total")

# 2. SÉPARATION EN TABLEAUX THÉMATIQUES

# Liste des mots-clés pour piéger les mammifères marins dans la chaîne taxonomique
mots_cles_marins <- "Cetacea|Delphinidae|Balaenopteridae|Phocidae|Otariidae|Odobenidae|Sirenia|Mysticeti|Odontoceti"

# Tableau A : Mammifères MARINS seulement
df_mamm_marins <- df %>%
  filter(str_detect(Taxonomy, "c__Mammalia") & str_detect(Taxonomy, "\\|s__")) %>%
  filter(str_detect(Taxonomy, mots_cles_marins)) %>%
  mutate(Taxon = sub(".*\\|s__", "", Taxonomy))

# Tableau B : Mammifères TERRESTRES (On exclut les marins grâce au "!")
df_mamm_terrestres <- df %>%
  filter(str_detect(Taxonomy, "c__Mammalia") & str_detect(Taxonomy, "\\|s__")) %>%
  filter(!str_detect(Taxonomy, mots_cles_marins)) %>%
  mutate(Taxon = sub(".*\\|s__", "", Taxonomy))

# Tableau C : Poissons
df_poissons <- df %>%
  filter(str_detect(Taxonomy, "c__Actinopteri") & str_detect(Taxonomy, "\\|s__")) %>%
  mutate(Taxon = sub(".*\\|s__", "", Taxonomy))

# Tableau D : Plantes
df_plantes <- df %>%
  filter(str_detect(Taxonomy, "Viridiplantae") & str_detect(Taxonomy, "\\|s__")) %>%
  mutate(Taxon = sub(".*\\|s__", "", Taxonomy))


######################################################################
# 3. GRAPHIQUES POUR L'ÉCHANTILLON SED6 (Thème Bleu)
######################################################################

# --- Mammifères Marins (SED6) ---
top_mamm_marins_sed6 <- top_n(df_mamm_marins, 30, wt = sed6total)
plot_mamm_marins_sed6 <- ggplot(top_mamm_marins_sed6, aes(x = sed6total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "steelblue") +  
  scale_x_continuous(limits = c(0, 25000), breaks = seq(0, 25000, by = 5000)) +
  labs(title = "SED6 - Mammifères Marins", x = "Reads", y = "Espèces") +  
  theme_minimal() + theme(axis.text.y = element_text(size = 7))
print(plot_mamm_marins_sed6)

# --- Mammifères Terrestres / Autres (SED6) ---
top_mamm_terr_sed6 <- top_n(df_mamm_terrestres, 30, wt = sed6total)

plot_mamm_terr_sed6 <- ggplot(top_mamm_terr_sed6, aes(x = sed6total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "steelblue") +  
  #On passe en échelle logarithmique pour voir les espèces avec moins de reads
  scale_x_log10(labels = scales::comma) + 
  labs(
    title = "SED6 - Top 30 Mammifères Terrestres", 
    x = "Reads (Échelle Logarithmique)", 
    y = "Espèces"
  ) +  
  theme_minimal() + 
  theme(axis.text.y = element_text(size = 7))

print(plot_mamm_terr_sed6)

# --- Poissons (SED6) ---
top_pois_sed6 <- top_n(df_poissons, 30, wt = sed6total)
plot_pois_sed6 <- ggplot(top_pois_sed6, aes(x = sed6total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "steelblue") +  
  # scale_x_continuous(...) a été supprimé pour laisser l'axe s'adapter tout seul 
  labs(title = "SED6 - Top 30 Poissons", x = "Reads", y = "Espèces") +  
  theme_minimal() + 
  theme(axis.text.y = element_text(size = 7))
print(plot_pois_sed6)

# --- Plantes (SED6) ---
top_plan_sed6 <- top_n(df_plantes, 30, wt = sed6total)
plot_plan_sed6 <- ggplot(top_plan_sed6, aes(x = sed6total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "steelblue") +  
  # scale_x_continuous(...) a été supprimé ici aussi 
  labs(title = "SED6 - Top 30 Plantes", x = "Reads", y = "Espèces") +  
  theme_minimal() + 
  theme(axis.text.y = element_text(size = 7))
print(plot_plan_sed6)

######################################################################
# 4. GRAPHIQUES POUR L'ÉCHANTILLON SED8 (Thème Corail)
######################################################################

# --- Mammifères Marins (SED8) ---
top_mamm_marins_sed8 <- top_n(df_mamm_marins, 30, wt = sed8total)
plot_mamm_marins_sed8 <- ggplot(top_mamm_marins_sed8, aes(x = sed8total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "coral") +  
  scale_x_continuous(limits = c(0, 25000), breaks = seq(0, 25000, by = 5000)) +
  labs(title = "SED8 - Mammifères Marins", x = "Reads", y = "Espèces") +  
  theme_minimal() + theme(axis.text.y = element_text(size = 7))
print(plot_mamm_marins_sed8)

# --- Mammifères Terrestres / Autres (SED8) ---
top_mamm_terr_sed8 <- top_n(df_mamm_terrestres, 30, wt = sed8total)

plot_mamm_terr_sed8 <- ggplot(top_mamm_terr_sed8, aes(x = sed8total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "coral") +  
  #On passe en échelle logarithmique pour voir les espèces avec moins de reads
  scale_x_log10(labels = scales::comma) + 
  labs(
    title = "SED8 - Top 30 Mammifères Terrestres", 
    x = "Reads (Échelle Logarithmique)", 
    y = "Espèces"
  ) +  
  theme_minimal() + 
  theme(axis.text.y = element_text(size = 7))

print(plot_mamm_terr_sed8)
# --- Poissons (SED8) ---
top_pois_sed8 <- top_n(df_poissons, 30, wt = sed8total)
plot_pois_sed8 <- ggplot(top_pois_sed8, aes(x = sed8total, y = reorder(Taxon, sed8total))) +
  geom_col(fill = "coral") +  
  # scale_x_continuous(...) a été supprimé pour laisser l'axe s'adapter tout seul 
  labs(title = "SED8 - Top 30 Poissons", x = "Reads", y = "Espèces") +  
  theme_minimal() + 
  theme(axis.text.y = element_text(size = 7))
print(plot_pois_sed8)

# --- Plantes (SED8) ---
top_plan_sed8 <- top_n(df_plantes, 30, wt = sed8total)
plot_plan_sed8 <- ggplot(top_plan_sed8, aes(x = sed8total, y = reorder(Taxon, sed6total))) +
  geom_col(fill = "coral") +  
  # scale_x_continuous(...) a été supprimé ici aussi 
  labs(title = "SED8 - Top 30 Plantes", x = "Reads", y = "Espèces") +  
  theme_minimal() + 
  theme(axis.text.y = element_text(size = 7))
print(plot_plan_sed8)

