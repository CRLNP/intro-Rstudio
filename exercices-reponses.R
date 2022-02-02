############################################################
#                                                          #                                      
####       ----          IntroR            ----         ####
#                  Exercices-Réponses                      #
#                  Caroline Patenaude                      #
#                      15-10-2021                          # 
############################################################


# 1.  Importer la base de données rp2012 d'un fichier .txt
# File -> Import Dataset -> From text (Base) -> rp2012.txt

# Ou via module questionr mais le format ne sera pas tout à fait le même (tibble)
library(questionr)
data(rp2012)


# 2. Placer la base de données dans un objet nommé fr
fr <- rp2012


# 3. La base de données contient combien d'observations et de variables?
ncol(fr)
nrow(fr)
# OU dim(fr) ou str(fr)


# 4. Afficher les noms des variables
names(fr)


# 5. De quel format est la variable departement?
class(fr$departement) # Ou mode() ou str()


# 6. Supprimer la variable code_region
fr$code_region <- NULL


# 7. Combien de valeurs uniques contient la variable region 
unique(fr$region)


# 8. Y a-t-il des valeurs manquantes dans la base, si oui combien ?
freq.na(fr) # Aucune


# 9. Explorer les statistiques descritives des variables region et hlm avec les fonctions summary() et describe()

## Une à la fois
questionr::describe(fr$region)
summary(fr$region)


## OU les deux en même temps
questionr::describe(fr[ ,c("region", "hlm")])
summary(fr[ ,c("region", "hlm")])


# 10. Sélectionner la variable departement (deux façons possibles)
fr$departement
#ou
fr[ ,"departement"]


# 11. Sélectionner les 100 premières observations pour les variables 2, 6 et 7
fr[1:100, c(2,6,7)]


# 12. Sélectionner les cas ayant plus de 10 000 habitants (pop_tot) et créer une nouvelle base de données nommé fr.pop
fr.pop <- fr[fr$pop_tot > 10000, ]


# 13. Sélectionner la variable region pour les observations ayant plus de 25% de la population sans diplome (dipl_aucun) et ayant moins de 50% de femmes (femmes)
fr$region[fr$dipl_aucun > 25 & fr$femmes< 50]
#OU
fr[fr$dipl_aucun > 25 & fr$femmes< 50, "region"]


# 14. Créer une variable nommée hommes contenant le nombre d'hommes (calcul sur les variables pop_tot et pop_femmes)
fr$hommes <- fr$pop_tot - fr$pop_femmes  


# 15. Créer une variable nommée hommesp contenant le pourcentage d'hommes (variables hommes et pop_tot)
fr$hommesp <- (fr$hommes / fr$pop_tot) *100


# 16. Créer une nouvelle variable nommée chomcat regroupant le pourcentage de chomeurs (var chom) en 4 catégories (moins de 25%, 25 à 50, 51 à 75 et plus de 75%)
fr$chomcat <- cut(fr$chom, breaks=c(0, 25, 50, 75, 100), labels=c("moins de 25%", "25% à 50%", "51% à 75%", "plus de 75%"), include.lowest=T)


# 17. Créer un tableau croisée avec la variable region et chomcat 
table(fr$region, fr$chomcat)


# 18. Créer un graphique de nuage de points (fonction plot()) croisant le pourcentage d'habitants sans diplôme (dipl_aucun) et le pourcentage de chômeurs (chom).
plot(fr$dipl_aucun, fr$chom)


# 19. Fin de session

# Sauvegarder tous les objets dans un fichier nommé fr2012
save.image("fr2012.RData")	# Sauvegarde tous les objets

# Sauvegarder l'historique dans un fichier nommé fr2012

savehistory("fr2012.Rhistory") 

# Exporter la base fr dans un fichier .txt nommé fr2012
write.table(fr, "fr2012.txt")
