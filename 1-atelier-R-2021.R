############################################################
#                                                          #                                      
####       ----          IntroR            ----         ####
#         Script 1 - Objets et grammaire de base           #
#                   Caroline Patenaude                     #
#                      15-10-2021                          # 
############################################################


# ==================== 1. PACKAGES ET ENVIRONNEMENT DE TRAVAIL ====================


#* Télécharger et charger les packages utilisés ====================


# Toujours débuter son script par le code de téléchargement/chargement des packages nécessaires (ou via le menu du haut Tools).
# dependencies=TRUE: assure que tous les modules dépendants nécessaires seront aussi installés.

install.packages("questionr", dep = TRUE)
install.packages("psych", dep = TRUE)
install.packages("Hmisc", dep = TRUE)
install.packages("leaflet", dep = TRUE)


# Activer les packages à chaque session de travail

library(questionr)  # ou require() qui peut être utilisé dans des commandes if()
library(psych)
library(Hmisc)
library(leaflet)


#* Pour télécharger des packages de Github ===================

install.packages("devtools")
library(devtools)
install_github("hadley/dplyr") # nom du développeur et du package


############# Démo package de géo: S'amuser avec du copier/coller! #############
#
# - https://roelandtn.frama.io/slides/2090628_meetup_Raddict_datageo.html#61 
#
# - https://geocompr.robinlovelace.net/intro.html
#
##############################################################################


#*  Gestion de packages ===================

# Voir les modules téléchargés (chargés ou non)
installed.packages()	

# Voir les modules chargés
search()

# Lister les fonctions d'un module chargé
library(help = questionr)

# Détacher un module chargé
detach(package:NomModule)   # pour éviter les conflits entre fonctions du même nom de différents modules

# Supprimer un module chargé
remove.packages("NomModule")

# Trouver à quel module (chargé) appartient une fonction
find("NomFonction")  

# Mise à jour de modules
update.packages()

# Utiliser ponctuellement une fonction d'un module non chargé et désambiguiser différentes fonctions du même nom
psych::describe(bd$age)
questionr::describe(bd$age)
Hmisc::describe(bd$age)


#*   Gérer son environnement de travail  ===================


## Vérifier son dossier de travail actuel
getwd()

## Définir son dossier de travail (ou sous Session > Set Working Directory)
setwd("C:/Users/p0373489/Desktop/AtelierR")
# Ou
setwd("C:\\Users\\p0373489\\Desktop\\AtelierR")

# Il faut utiliser soit "/" ou "\\" MAIS par souci de reproductibilité, préférable de ne pas inscrire de chemin absolu mais d'utiliser un chemin relatif. 
# R ira chercher les fichiers dans le dossier de travail, par exemple read.table("fichier.csv") ou read.table("donnees/fichier.csv")

# Peut aussi se faire via le menu du haut ou l'onglet Files à droite

# Documenter les détails de son environnement de travail (système, packages, versions...)
sessionInfo()   # Important à noter pour assurer la reproductibilité des analyses


#*   Trouver de l'aide  ===================

## Aide générale de R
help.start()


## Trouver de l'aide sur une fonction - module doit être chargé, sinon ajouter l'argument "try.all.packages = TRUE"
?NomFonction
help(NomFonction) 

# Note: pour afficher l'aide hors console en format html: help(t.test, help_type="html")

## Chercher un mot dans l'aide
help.search("correlation")
?? "correlation"

## Trouver de l'aide sur un package
help(package = questionr)


## Exécuter les examples d'une fonction
example(NomFonction)

# Note: Certains packages ont aussi des démos: demo(lattice) et des vignettes: browseVignettes(package="dplyr")


# ==================== 2. LES OBJETS ====================

# R comme une grosse calculatrice
2+2

# Calcul simple
(12+15+20) /     3  # Les espaces n'ont pas d'impact


# On remarque la présence du [1] en début de ligne devant le résultat
# Ce nombre entre crochet indique la position du 1er élément de la ligne, ie l'index 
# Comme nous le verrons, ce principe d'indexation permet de sélectionner et de modifier des éléments en indiquant leur numéro entre crochets


# Créer un objet nommé "age" dans lequel je stocke le résultat du calcul
age <- (12+15+20)/3 

# Pour voir le contenu de son objet, tapper son nom
age  # Utilisation implicite de la fonction print(age) 

# Pour mettre dans un objet ET visualiser en même temps, mettre entre parenthèses
(age<-(12+15+20)/3) 



# ==================== 3. LES OPÉRATEURS ====================

#  Opérateurs d'assignation: **<-**, = , ->
#  Opérateurs de sélection: [], [[]], $, :
#  Opérateurs booléen: !, &, |
#  Opérateurs arithmétiques: +, -, *, /, ^
#  Opérateurs de comparaison: ==, !=, <, >, <=, >= 



# ==================== 4. LES FONCTIONS  ====================

#  Permettent d’effectuer des tâches prédéfinies comme des analyses, graphiques, calculs, … 
#  Chaque fonction a un nom et plusieurs fonctions peuvent permettre d'effectuer la même tâche: 
#  par exemple pour faire une correlation, on retrouve entre autres les fonctions cor(), cor.test(), ...
#  On appel une fonction en la nommant et on contrôle son comportement en paramétrant ses arguments.
#  On peut imbriquer les fonctions les unes dans les autres avec des parenthèses.

# Créer un nouvel objet nommé "age" composé d’une série de 5 nombres avec la fonction c() (concaténer)

age <- c(12, 15, 20, 35, 40) 

## À noter: lorsque l'on stocke un nouveau contenu dans un  objet existant, le contenu initial est écrasé

# Voir le contenu de l'objet 
age 

# Passer cet objet comme 1er argument de la fonction mean()
mean(age)

# Arrondir le résultat sans décimale (argument digits=) en imbriquant la fonction mean() dans la fonction round()
round(mean(age), digits=0) 


# ==================== 5.  LES ARGUMENTS ====================

# Chaque fonction possède une liste plus ou moins longue d’arguments (paramètres ou options) permettant de paramétrer son fonctionnement
# Certains arguments ont une valeur par défaut. Si ces valeurs nous conviennent, pas besoin de les indiquer.
# Si l’argument n’a pas de valeur par défaut, il FAUT le renseigner.
# Pour modifier la valeur d’un argument, on le nomme et change sa valeur à la suite d’un =.
# La liste d’arguments respecte un ordre. Si on modifie chaque argument dans l’ordre, on peut omettre le nom des arguments. Les arguments peuvent donc être nommés ou non (mais pour assurer la reproductibilité, il est recommandé de toujours les nommer).
# Le premier argument, toujours les données (on ne le nomme généralement pas: x=).
# Comment savoir quels sont les arguments d’une fonction? Taper Help(NomFonction) ou ?NomFonction .


age <- c(25, 36, 47, 58, 69, NA)  # Créer un vecteur composé de 5 chiffres et une valeur manquante

mean(age)    

# OUPS!
 
help(mean)  # Pour afficher l'aide d'une fonction (ou ?mean ou la fonction args(mean))

mean(age, na.rm=TRUE, trim = 0.05)

# L'argument na.rm=TRUE indique d'exclure les valeurs manquantes
# L'argument trim=.05 indique d'exclure les 5% les plus extrêmes
# La liste des arguments est ordonnée. Mais lorsque les arguments sont nommés, il n'est pas nécessaire de respecter l'ordre indiqué:
# mean(x, trim = 0, na.rm = FALSE, ...)


# ==================== 6. LES TYPES DE DONNÉES ====================

aa <- 123      # Numérique
bb <- "soleil" # Chaîne de caractères - doit être entre guillemet sinon sera interprété comme un NOM D'OBJET
cc <- TRUE     # Logique (T/F)
dd <- NA       # Logique
ee <- "123"    # ???

mode()



# ==================== 7.  LES TYPES D'OBJETS ====================

# Les objets sont caractérisés par **différentes structures**
# On retrouve **5 différents types de contenants** ayant chacun leurs propriétés 

# 1.   **Vecteur**
# 2.   Liste
# 3.   Matrice
# 4.   Arrays 
# 5.   **Dataframe (tableaux)**


#* 7.1. Vecteurs ========================================

#  La brique élémentaire = série de valeurs.
#  En pratique, c’est une variable (mais qui n’est pas dans un tableau) et ses éléments sont ses valeurs.
#  Objet contenant des valeurs (éléments/composantes) d'un seul **mode**: numérique, textuel, logique. 


### Créer des vecteurs principalement avec la fonction c()
aa <- c(5, 23, 89, NA)  # vecteur numérique et une valeur manquante
bb <- c("bleu", "blanc", "rouge")  # vecteur textuel
cc <- c(TRUE, FALSE, FALSE, TRUE)  # vecteur booléen


# On peut faire des calculs entre vecteurs - exemple, calcul de l'IMC: poids divisé par taille au carré 

# crée un vecteur nommé "poids" avec la fonction c() composé de 3 éléments numériques
poids <- c(70, 65, 60) 

# crée un vecteur nommé "taille" avec la fonction c() composé de 3 éléments numériques au carré
taille <- c(1.45, 1.60, 1.70) ^ 2  

# diviser l'objet "poids" par l'objet "taille" et placer le résultat dans un objet nommé IMC
IMC <- poids / taille 

# voir le contenu de l'objet
IMC 

# obtenir la médiane des éléments de l'objet
median(IMC) 

# obtenir les différences à la moyenne des éléments de l'objet
IMC - mean(IMC) 

# Pour voir le "format" des éléments stockés dans un objet, utiliser la fonction mode() ou typeof()
mode(poids)


#* 7.2. Facteurs ========================================

# Vecteur avec des attributs spécifiques, dont la structure correspond aux variables qualitatives (catégorielles).
# On créé des facteurs avec la fonction factor()
# Les modalités de la variable correspondent à des "niveaux" (*levels*) uniques et fixes, ie impossible d’assigner une valeur qui n’a pas été préalablement définie comme une des modalités.
# Des étiquettes (*labels*) peuvent être associées aux niveaux.
# L'argument optionnel levels() permet d'ajouter et modifier les catégories prédéfinies 
# L'argument labels(), aussi optionnel, permet de définir les libellés associés aux niveaux. Faut respecter leur ordre
# Lors de l’importation de données, tout dépendant de la fonction d'importation, les variables qualitatives seront importées sous forme de *vecteur textuel* ou de *facteur*.


### Créer une variable "sexe" de type vecteur character
sexec <- c("H", "H", "F", "H")

# Créer une variable "sexe" de type facteur à partir d'un vecteur textuel de 4 valeurs de 2 niveaux avec la fonction factor() et assigner des étiquettes aux modalités avec l'argument labels
sexef <- factor(c("H", "H", "F", "H"), labels = c("Homme", "Femme"))

# L'objet est un facteur avec 2 modalités (niveaux) définies par défaut en fonction des valeurs fournies 
str(sexef)


#* 7.3. Dataframes ========================================

#  Tableau de données pouvant regrouper des vecteurs de différents types (variables numériques et/ou textuelles).

#  Crée un jeu de données avec la fonction data.frame(), mais on le crée rarement manuellement dans R, généralement importé en format .txt, .csv...

# Créer un dataframe avec 3 variables (2 vecteurs numériques et 1 vecteur textuel) avec la fonction data.frame()
age <- c(45,65,22,38,54,31,29,44,56,67) 
poids <- c(150,125,210,175,110,180,130,155,190,120)
sexe <- c("H","F","F","H","H","F","F","H","F","H")
bd <- data.frame(age, sexe, poids)

bd
str(bd)
