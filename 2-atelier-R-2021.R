############################################################
#                                                          #                                      
####       ----          IntroR            ----         ####
#     Script 2 - Exploration et manipulation d'une BD      #
#                   Caroline Patenaude                     #
#                      15-10-2021                          # 
############################################################


#* Télécharger et/ou charger les packages utilisés ====================

install.packages("questionr", dep = TRUE)
install.packages("psych", dep = TRUE)
install.packages("Hmisc", dep = TRUE)

library(questionr)
library(psych)
library(Hmisc)

# ==================== 1. IMPORTER ET EXPLORER UNE BASE DE DONNÉES  ====================


#* 1.1. Les bases de données en différents formats   ====================

#  Il existe plusieurs fonctions (natives R ou de modules divers) pour importer des fichiers de divers formats (.txt, .csv, .sav, .xls, .dta, .sas7bdat, ...). 
#  Chaque fonction a ses particularités (arguments) qui auront un impact sur la conversion des données, par exemple: le traitement des valeurs manquantes, des étiquettes de valeurs, le format des variables qualitatives (facteur ou chaine de caractères), des dates, des décimales.
#  RStudio permet également d'importer un fichier via des fonctions automatisées dans le menu du haut.


### Fichiers csv
read.table("fichier.csv", sep=",", header=TRUE) 


### Fichiers txt
read.table("fichier.txt", header = TRUE, sep = " ", na.strings = c(".", "99"))

# read.table: fonction de base, il faut spécifier les arguments sep et header
# header=TRUE: la première ligne contient le nom des variables
# sep=" ":les données sont séparées par ...
# na.strings=c(".", "99") indique que les valeurs manquantes sont codées par ...


### Fichier excel
read_excel("fichier.xls") 

# Module readxl (fait partie de tidyverse mais doit être chargé individuellement)


### Fichier SPSS
read_spss("fichier.sav", user_na = TRUE) 

# Module haven (fait partie de tidyverse mais doit être chargé individuellement)
# Pour les codes de valeurs manquantes, utiliser l’option user_na = TRUE    
# Les valeurs manquantes codées ne seront pas converties en NA et conserveront leur statut manquant
# Plusieurs autres fonctions disponibles dans haven: read_sav, read_dta, read_sas, read_csv, read_csv2, ...


#* 1.2. Les bases de données intégrées aux modules   ====================


# Voir toutes les bases de données intégrées aux modules (installés ou non)

data(package = .packages(all.available = TRUE))


# Importer une base de données d'un module chargé

## Voir les bases de données dans un module chargé particulier
data(package="questionr") 

## Importer une base de données dans un module chargé particulier
data(hdv2003)

# R a automatiquement créé un objet au nom de la base importée dans notre environnement de travail
hdv2003



#* 1.3. Faire une copie de sa base dans un nouvel objet   ====================

bd <- hdv2003


#* 1.4. Supprimer un  objet   ====================

rm(hdv2003)  # Supprimer la base de données originale

rm(aaa, bbb, ccc)  # Supprimer plus d'un objet

rm(list = ls()) # Supprimer tous les objets


#* 1.5. Afficher le contenu de sa base de données   ==================== 

bd # visualiser la base de données complète

head(bd) # visualiser les 6 premières observations (modifier le nombre par défaut après une virgule: (bd, 4))

tail(bd) # visualiser les 6 dernières observations



#* 1.6. Afficher les noms de variables/colonnes   ====================

names(bd) # noms des variables



#* 1.7. Afficher le nombre de rangées et de colonnes (dimensions)   ====================


ncol(bd) # nombre de variables

nrow(bd) # nombre d'observations

dim(bd) # nombre de dimensions (colonnes et lignes)


#* 1.8. Examiner les caractéristiques sa base de données: classe, taille, structure   ====================


class(bd)  # type d'objet

length(bd) # nombre de variables

str(bd)    # description plus détaillée de la structure du tableau (aussi en cliquant sur objet dans l'environnement - permet de connaitre la structure de tout type d'objet)


# ==================== 2. SÉLECTIONNER DES ÉLÉMENTS (INDEXATION)  ====================


#* 2.1. Par position (directe) avec l'opérateur [ ]   ====================

#  Indique le rang du ou des éléments à sélectionner - Commence par l'indice 1.

#  **NomObjet[rangée, colonne]**


#** 2.1.1 Pour sélectionner une ou plusieurs variables   ====================

#   NomObjet[rangée, **colonne**] 

bd[ , 2]       # Sélectionner la deuxième variable 

bd[ ,3:6]	    # Sélectionner les variables 3 à 6 (notez l'opérateur `:`, raccourci de la fonction `seq()`)

bd[ ,c(3,6)]	# Sélectionner les variables 3 et 6 (peut aussi sélectionner dans le désordre)

bd[ ,-2]    	# Sélectionner toutes les variables sauf la deuxième 

bd[ ,-(3:6)]	# Toutes les variables sauf 3 à 6 


#** 2.1.2 Pour sélectionner une ou plusieurs observations   ====================

#  Même principe, mais de l'autre côté de la virgule:

#  NomObjet[**rangée**, colonne]

bd[3:6, ]       # Sélectionner les observations de 3 à 6


#** 2.1.3. Pour sélectionner des variables ET des observations   ====================

bd[1:100, c(1:5,10)] # Sélectionner les 100 premières observations et les variables de 1 à 5 et 10

## Pour créer une nouvelle base contenant une sélection de variables/observations, simplement placer la sélection dans un nouvel objet:  bd2 <- 



#* 2.2. Sélection par nom     ====================

# Indique le nom du ou des éléments à sélectionner


#** 2.2.1. Avec l'opérateur [ ]   ====================


bd[ ,"relig"] # Sélectionner une variable (contenu textuel entre guillemets simples ou doubles)

bd[ ,c("occup", "relig")] # Sélectionner deux variables 

### On peut aussi mélanger les types d'indexation
bd[1:100, c("id", "age", "sexe", "nivetud", "poids", "relig")]


#** 2.2.2. Avec l'opérateur $   ====================

# $: Symbole "raccourci" pour rapidement sélectionner une seule variable

bd$sexe # Sélectionner la variable sexe


str(bd$sexe) # Structure de la variable 

head(bd$sexe) # Premières observations de la variable

unique(bd$nivetud) # Identifier les valeurs uniques de la variable "nivetud"



#* 2.3. Sélection par condition (opération logique)     ====================

# Sélection d'observations qui remplissent une ou des conditions en utilisant les opérateurs: 
# ==, !=, <, >, <=, >=


#** 2.3.1. Sélectionner selon une valeur de variable    ====================


# *Sélectionner les observations de la variable "sexe" ayant la valeur "Femme" :

# 1. Créer d'abord une condition qui teste si la valeur de sexe est "Femme" et retourne une liste logique de vrai ou faux

bd$sexe=="Femme"

# ou procéder par la négative avec le sauf "!="

bd$sexe != "Homme" # (ne peut utiliser le "-" comme dans l'indexation directe)

# NB Le sauf bd[-5, ] ne fonctionne pas avec les noms de variables.


# 2. Appliquer cette condition de sélection entre crochet à l'objet voulu (bd) pour créer une nouvelle base composée du sous-ensemble correspondant à TRUE


bd.f <- bd[bd$sexe=="Femme", ]
bd.m <- bd[bd$sexe=="Homme", ]

# NB. l'objet sur lequel est appliqué la condition peut aussi être une variable (vecteur): bd$age[bd$sexe=="Femme"]


#** 2.3.2. Sélectionner selon plusieurs conditions appliquées à une même variable  ------


# Sélectionner les répondants à la retraite ou au foyer (variable occup)*

bd[bd$occup == "Retraite" | bd$occup == "Au foyer", ] # avec l'opérateur | (ou)


#** 2.3.3. Sélectionner selon plusieurs conditions appliquées à plus d'une variable  ------

#  La fonction subset()

bd.cadre <- subset(bd, qualif=="Cadre" & age<50, select= c(id,qualif, age))


# Indique le nom de notre base en premier - plus besoin de spécifier bd$qualif...
# Pas besoin de guillemets autour des noms de variables
# Argument select= pour sélectionner des variables spécifiques, sans guillemets


#* 2.4. Les valeurs manquantes    ====================

# Plusieurs fonctions sont à connaitre lorsque l'on travaille avec des données qui incluent des valeurs manquantes:


is.na(bd$age)

# Test logique :  vrai ou faux
# Identifier les cas qui ont une valeur manquante dans une variable sous forme de vecteur logique


which(is.na(bd), arr.ind=TRUE) # Identifier les cas qui ont une valeur manquante dans le jeu de données complet

# is.na()  applique test logique
# which()  retourne les numéros de lignes qui remplissent la condition (TRUE)
# arr.ind= permet d'appliquer le principe sur toutes les colonnes
# Retourne une matrice composée du numéro de l'observation et du numéro de colonne où se trouve les NA
# Pour identifier les cas d'une variable spécifique is.na(bd$occup)

freq.na(bd) # (questionr) Voir le nombre de valeurs manquantes par variable


sum(is.na(bd$qualif)) # Compte des valeurs manquantes dans une variable


sum(!is.na(bd$qualif)) # Compte des valeurs non manquantes (! sauf) dans une variable


bdo <- na.omit(bd) # Élimiter toutes les lignes ayant au moins une valeur manquante


bd$age[is.na(bd$age)] <- mean(bd$age, na.rm=TRUE) # Attribuer une valeur quelconque aux valeurs manquantes d'une variable (ex. imputation)


bd[bd==99] <- NA # Remplacer le code de valeur manquante 99 par NA dans toute la base


# ==================== 3. MANIPULER DES VARIABLES (REMPLACER, RENOMMER, RECODER, CALCULER)  ====================


#** 3.1. ------ Modifier une valeur de variable  ------


# Sélectionner la première observation de la variable quantitative age 
bd$age[1]

# Modifier la valeur 
bd$age[1] <-  38


# Sélectionner la première observation de la variable qualitative (facteur) sexe 
bd$sexe[1]

# Modifier la valeur (information textuelle entre guillemet)
bd$sexe[1] <- "Homme"

# Modifier avec une autre valeur 
bd$sexe[1] <- "Autre" # NON! Puisque c'est un facteur, la modalité (levels) doit avoir été prévue (ça fonctionnerait pour une variable "caractère")

# Il faut d'abord modifier les niveaux permis avec la fonction factor() et son argument levels=
bd$sexe <- factor(bd$sexe, levels=c("Femme", "Homme", "Autre")) 



## Éditer la base
bdedit <- edit(bd) # ou fix() 


#** 3.2. ------ Supprimer une ou plusieurs variables  ------


bd$cuisine <- NULL # supprimer une variable

bd[ ,c(5,15)] <- NULL # Supprimer plusieurs variables

bd1 <- bd[,-16]  # en sélectionnant toutes les colonnes sauf la 16 et en copiant la sélection dans un nouvel objet

### Supprimer des observations: le cinquième répondant
bd2<-bd[-5, ]


#** 3.3. ------ Renommer une ou plusieurs variables  ------


# Modifier un ou plusieurs noms de variables avec la fonction names() et l'indexation par position

names(bd)[c(9,17)] <- c("classe", "bricolage") # On renomme les variables 3 et 4 avec des noms en majuscule 

names(bd) # Lister l'ensemble des noms de variablesstr(bd)



#** 3.4. ------ Renommer des modalités de variables catégorielles ------

# La procédure diffère en fonction du format de la variable qualitative: *character* ou *factor*

# Avec l'indexation par condition

# Si la variable qualitative est de type "character", on peut procéder comme suit
# Mais si c'est un "factor", on ne peut en renommer directement les modalités (niveaux) 
bd$sport[bd$sport == "Non"] <- "NON"
bd$sport[bd$sport == "Oui"] <- "OUI"

# On peut d'abord transfomer le facteur en format caractère et ensuite en renommer les modalités
bd$lecture <- as.character(bd$lecture)
bd$lecture[bd$lecture=="Non"]<- "NON"
bd$lecture[bd$lecture=="Oui"]<- "OUI"

str(bd$lecture) # la variable lecture est maintenant en format caractère

# Pour reconvertir la variable caractère en facteur, utiliser la fonction factor
bd$lecture <- factor(bd$lecture)

## À noter: tous les formats de variables peuvent être transformés avec les fonctions: *as.numeric*, *as.character*, *as.factor*.
## Attention, certaines transformations de formats sont plus délicates que d'autres.



#** 3.5. ------ Recoder/agréger des modalités de variables catégorielles ------

# Avec l'indexation par condition 

# On procède de la même façon que pour renommer
# L'agrégation se fait donc simplement en attribuant le même nom à différentes catégories
# On peut d'abord transformer la variable en format caractère comme ci-haut avec la fonction as.character()
# On peut également recoder directement dans une nouvelle variable (ici bd$relig.rec) qui sera en format caractère

# Agréger et renommer des catégories de la variable "relig" dans la nouvelle variable bd$relig.rec
bd$relig.rec[bd$relig == "Pratiquant regulier"] <- "Pratiquant"
bd$relig.rec[bd$relig == "Pratiquant occasionnel"] <- "Pratiquant"
bd$relig.rec[bd$relig == "Appartenance sans pratique"] <- "Croyant"
bd$relig.rec[bd$relig == "Ni croyance ni appartenance"] <- "Athée"
bd$relig.rec[bd$relig == "Rejet"] <- "ND"
bd$relig.rec[bd$relig == "NSP ou NVPR"] <- "ND"

str(bd$relig.rec) # Fonction str() pour voir le format de notre nouvelle variable


#** 3.6. ------ Recoder des variables numériques en catégorielles (transformer en facteur) ------

# Avec la fonction cut(): découpe la variable quantitative

bd$age.cat <- cut(bd$age, breaks=c(0, 20, 40, 60, 80, 100), labels=c("20 ans et moins", "21 à 40", "41 à 60", "61 à 80", "81 et plus"), ordered_result=TRUE)

## breaks=: limites des catégories (peut aussi simplement indiquer le nombre de groupes (breaks=5), mais le résultat n'est pas optimal)
## (40,60]: signifie que 40 est exclu et 60 est inclu, donc 41 à 60
## labels: intitulés
## include.lowest=T: valeur minimale est incluse dans la première classe (par défaut, la borne de gauche des intervalles est ouverte)
## ordered_result=: définir une variable ordinale

str(bd$age.cat)


# Interfaces interactives de questionr

## questionr offre des outils automatisé de recodage de variables (renommage et regroupement de modalités) - Voir aussi sous Addins

irec(bd, qualif)

icut(bd, age)


#** 3.7. ------ Créer/Calculer des variables  ------


bd$annee <- 2003 - bd$age    # Créer une nouvelle variable (annee) avec l'année de naissance (enquête date de 2003) 

bd$age.ecart <- bd$age - mean(bd$age, na.rm = TRUE) # Créer une nouvelle variable (age.ecart) avec l'écart entre l'âge du répondant et la moyenne

# Calculer un score d'items (moyenne ou somme de plusieurs variables)
bd$sum <- rowSums (bd[ , c("var1", "var2", "var3")], na.rm=TRUE)
bd$moy <- rowMeans (bd[ , c("var1", "var2", "var3")], na.rm=TRUE)


# ==================== 4. STATISTIQUES DESCRIPTIVES   ====================


#** ----- 4.1. Fonction générique summary() -----

#   Fournit les principales mesures de tendance centrale et de dispersion d’une distribution avec quartiles 
#   C’est une fonction dont le comportement s’adapte au type d’objet
#   Élimine d'emblée les valeurs manquantes

summary(bd) # Résumé de la base de données 

summary(bd$age) # Résumé d'une variable quantitative

summary(bd$occup) # Résumé d'une variable qualitative


#** ----- 4.2. Autres fonctions pour indicateurs individuels -----

# Fonctions diverses permettant d'explorer les indicateurs de centralité et de dispersion pour variable quantitative
# Toujours ajouter na.rm=T en argument

median(bd$heures.tv, na.rm=TRUE)

mean(bd$heures.tv, na.rm=TRUE)

max(bd$heures.tv, na.rm=TRUE)

min(bd$heures.tv, na.rm=TRUE)

sum(bd$heures.tv, na.rm=TRUE)

range(bd$heures.tv, na.rm=TRUE)

var(bd$heures.tv, na.rm=TRUE)

sd(bd$heures.tv, na.rm=TRUE)

quantile(bd$heures.tv, na.rm=TRUE)


## Fonctions de normalité

skew(bd$heures.tv, na.rm=TRUE) # module psych

kurtosi(bd$heures.tv, na.rm=TRUE) # module psych


## Fonctions de transformation: normalité & rang

bd$age.log <- log(bd$age, base=10)     # Logarithme (, base=10)

bd$age.sqrt <- sqrt(bd$age)    # Racine carrée

bd$age.scale <- scale(bd$age, center = TRUE, scale = TRUE)    # Standardisation: centrage et réduction (Zscore)


#** ----- 4.3. La très utile fonction apply() -----

# Pour appliquer une fonction sur plusieurs variables à la fois
apply(bd[ ,c("age", "heures.tv","freres.soeurs")], na.rm=TRUE, MARGIN=2, FUN=mean)

## c() indique les variables à utiliser dans le calcul
## MARGIN=2: calcul à travers les participants (ici moyenne de colonnes), =1 est à travers les rangées
## FUN=mean: la fonction à appliquer, pourrait être n'importe laquelle comme somme, variance...


#** ----- 4.4. Table de fréquences -----

# Fonction table() - Tableaux d'effectifs 

table(bd$freres.soeurs)    # var numérique

tb.cat <- table(bd$qualif) # var quali (résultat pareil à summary())

## Exclu NA par défaut, sinon il faut utiliser l’argument useNA ="always" ou "ifany"
## On place la table dans un nouvel objet pour pouvoir lui appliquer d'autres opérations


# Autres fonctions pertinentes

prop.table(tb.cat) # Appliquée à une table pour transformer les valeurs en proportions


# Afficher en % et arrondir

round((prop.table(tb.cat))*100) 


# Fonction freq (module questionr)

freq(bd$qualif) # affiche les NA par défaut


# Fonction freq: nombreux arguments utiles possibles

freq(bd$qualif, cum = TRUE, total = TRUE, sort = "inc", digits = 0, exclude = NA)

## cum: afficher ou non les % cumulés
## total: ajouter les effectifs totaux
## sort: trier le tableau par fréquence croissante (sort="inc") ou décroissante (sort="dec")
## digits: arrondir
## exclude: exclure valeurs manquantes


#** ----- 4.5. Tableaux croisées -----


# Fonction table() et cie.

# 1er argument var en ligne (x), 2e var en colonne (y)

tb <-table(bd$trav.satis, bd$sexe) 

## pour un tableau à plus de deux niveaux, simplement ajouter une virgule puis variable additionnelle


tb # Tableau de distribution de la satisfaction au travail selon le sexe


# Ajouter les totaux des effectifs
addmargins(tb)    

# % Totaux 
prop(tb)       


# % Totaux
prop.table(tb, margin = 2)    

## margin = 1 pour proportion en rangées
## margin 2 = pour proportion en colonnes
## *100


# rprop et cprop de questionr pour %

cprop(tb, percent = TRUE)    # % en colonnes

## Argument percent pour afficher les %

rprop(tb, percent = TRUE, digits = 0)    # % en lignes
help(rprop)
## Argument digits pour arrondir


# Les très pratiques fonctions by() et tapply() (variante de la fonction apply)
# Permettent d'appliquer une fonction sur une variable quantitative (1er) selon les modalités d'une variable catégorielle (2iem)

by(bd$age, bd$sexe, mean, na.rm=TRUE)

tapply(bd$age, bd$sexe, mean, na.rm=TRUE)

tapply(bd$relig, bd$sexe, table) 

tapply(bd$relig, bd$sexe, freq)



# --------------------------- FIN DE SESSION -------------------------------


## Pour enregistrer des objets, utiliser la fonction save et indiquer la liste des objets à sauvegarder et le nom du fichier

save(bd1, bd2, file = "fichier.RData") # Sauvegarde certains objets
save.image("fichier.RData")	# Sauvegarde tous les objets


## Pour charger des objets enregistrés
load("fichier.RData")

## Pour sauvegarder l'historique 
savehistory("fichier.Rhistory")    

## Pour charger l'historique 
loadhistory("fichier.Rhistory")


## Exporter un fichier de données - plusieurs fonctions de plusieurs packages

### Enregistrer objet dans un fichier txt
write.table(bd, file="fichier.txt", quote=FALSE, sep="\t", na="NA",row.names = FALSE, col.names = TRUE) # pas de guillemets de texte, séparé par tab, valeurs manquantes identifiées par NA, absence de noms de rangées et présence de nom de colonnes.

write.table(bd,file=file.choose())

### Enregistrer un objet dans un fichier csv
write.csv(bd,file=file.choose())
write.csv(bd, file = "fichier.csv")


## Package haven: exporter au format sas, spss, stata
write_sas() 
write_csv()
write_sav() 
write_dta() 

## fonction write.xlsx du package xlsx.

## Fermer R
quit()
