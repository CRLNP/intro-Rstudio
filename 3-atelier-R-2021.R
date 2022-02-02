############################################################
#                                                          #                                      
####       ----          IntroR            ----         ####
#           Script 3 - Les tests et graphiques             #
#                   Caroline Patenaude                     #
#                      15-10-2021                          # 
############################################################


#* Télécharger et/ou charger les packages utilisés ====================

install.packages("questionr", dep = TRUE)
install.packages("ggplot2", dep = TRUE)

library(questionr)
library(ggplot2)

# ==================== 5. LES TEST STATISTIQUES ====================

# On retrouve une multitude de modules dédiés aux méthodes statistiques (comme stats, MASS, FactoMineR, plm, glm). 
# La même méthode peut se trouver avec variantes dans plusieurs modules. 


# Notation formule et objet modèle

mod <- nom.test(VD ~ VI)

# Souvent utilisé dans les modèles d'analyse (régressions...) et les graphiques.
# Peut s'interpréter comme en "fonction de...": variable dépendante (effet) en fonction (~) de la var indépendante (cause).
# Toutes les fonctions n'acceptent pas la notation formule, mais elle est utilisée dans la plupart des modèles d'analyse.
# On stocke l'analyse dans un objet qui contiendra les résultats qui, selon l'analyse, inclueront différents  éléments d'information 


#** ----- 5.1. Test du Khi-carré  -----

#  fonction chisq.test() (Module questionr)
mod.chi <- chisq.test(bd$sport, bd$sexe) 

# Résumé des résultats
mod.chi  


#** ----- 5.2. Test F  -----

var.test(age ~ sport, data=bd)


#** ----- 5.3. Test T  -----

t.test(age ~ sport, data=bd, var.equal= TRUE)

## Par défaut, la fonction t.test est un test de Welsh qui ne suppose pas égalité des variances. Pour un test t classique, ajouter l'argument var.equal = TRUE


#** ----- 5.4. Différence de moyenne pour plus de deux groupes (ANOVA)   -----

mod.aov <- aov(heures.tv ~ occup, data=bd)

# Voir un résumé du modèle 
mod.aov

# Résultats détaillés
summary(mod.aov)

## Applique la fonction summary à l'objet modèle pour voir résultats détaillés


#** ----- 5.5.  Corrélations -----

cor(bd$age, bd$heures.tv, use="pairwise")


#** ----- 5.6.  Régression linéaire -----

# Fonction lm()

mod1.lm <- lm(heures.tv ~ occup + nivetud + sexe, data=bd) 

# Passe notre objet modèle à la fonction summary pour voir le tableau des coefficients et leur test de significativité
summary(mod1.lm)


#** ----- 5.7.  Régression logistique  -----

# Fonction glm

mod.reg <- glm(sport ~ sexe + nivetud + qualif, bd, family = binomial(logit))

## La fonction glm permet de calculer plusieurs modèles statistiques que l'on indique avec l’argument family=binomial(logit) 

# Résultats détaillés
summary(mod.reg)

# ==================== 6. LES GRAPHIQUES  ====================


# Deux principales familles de fonctions graphiques

# 1.   Fonctions natives
# 2.   Fonctions GGplot2


#** ----- 6.1.  Quatre graphiques de base: plot(), hist(), boxplot(), barplot()  -----


# La fonction générique plot()  --------------------------

# le graphique produit dépend du type d'objet fourni


#** Variable qualitative = Graphique à barres  -----------

plot(bd$trav.satisf) 


#** Variable quantitative = Nuage de points  -----------

plot(bd$freres.soeurs) 


#** Table d'effectifs (ou proportions) = Graphique à barres  -----------

plot(table(bd$freres.soeurs))

# Fonctions de base s'accompagnent de nombreux arguments dont plusieurs peuvent être utilisés pour tous les graphiques**

plot(table(bd$freres.soeurs), 
     col="red", 
     main = "Nombre de frères et soeurs", 
     ylab = "Effectif", 
     xlab="Nombre de frères et soeurs", 
     ylim=c(1, 500),
     xlim=c(0, 25),
     type="b")

## col=    couleur des barres
## main=   titre du grahique
## ylab=   titre de l'axe y
## xlab=   titre de l'axe x
## ylim=   graduation de l'axe y
## xlim=   graduation de l'axe x
## type=   style de lignes
### h	lignes verticales
### p	points
### l	lignes
### o	et b lignes et points
### s escaliers


#** Variables quanti/quanti = Nuage de points ------------

plot(bd$age, bd$heures.tv) 

# Modifications possibles parmi tant d'autres: faire varier les points selon les valeurs d'une autre variable par l'ajout de fonctions superposées

plot(bd$age, bd$heures.tv)  # var quanti/quanti
points(bd$age[bd$sexe=="Homme"], bd$heures.tv[bd$sexe=="Homme"], pch=16, col="steelblue")
points(bd$age[bd$sexe=="Femme"], bd$heures.tv[bd$sexe=="Femme"], pch=16, col="orange")
legend("topright", legend=c("Homme","Femme"), col=c("steelblue","orange"), pch=c(16))

## plot()    nuage de points
## points()  création d'une séquence de points colorés superposés en fonction de valeurs de variables sélectionnées par condition
## pch=      style de points
## col=      couleur des points
## legend()  ajout d'une légende et ses arguments de paramétrage


colours() # Voir la liste des couleurs de base


#** Variables quali/quanti = Boite à moustaches ---------------

plot(bd$sexe, bd$heures.tv) 

## variable indépendante à gauche (x), dépendante à droite (y)
## Notation formule: les formules passent la variable y en premier, donc la notation formule de la fonction générique plot(x, y) est plot(y ~ x)


# Diagramme à barres: fonction barplot()  --------------------------

tb.eff <- table(bd$trav.satis, bd$sexe) # tableau d'effectifs
tb.prop <- cprop(tb.eff, total = FALSE) # tableau de proportions


# Graphique à barres avec table d'effectifs superposés

barplot(tb.eff , legend = levels(bd$trav.satis))

## legend = levels pour faire apparaitre les catégories de la variable choisie


# Graphique à barres avec table de proportions

barplot(tb.prop, beside = TRUE, xlab = "Satisfaction", ylab = "pourcentages", las=2, ylim=c(0, 100),
        col = c("blue", "green", "orange"), legend = levels(bd$trav.satis))

## beside = TRUE  barres côtes à côtes
## las=2          intitulés à la verticale


# Histogramme: fonction hist()  --------------------------


hist(bd$age) 


# Histogramme avec quelques arguments

hist(bd$age, main = "Age", col="violetred2", breaks = 8, xlab = "Age", ylab = "Effectif", labels = TRUE)

## main=   titre du grahique
## col=    couleur des barres
## breaks= nombre de "barres"
## xlab=   titre de l'axe x
## ylab=   titre de l'axe y
## labels= affichage des valeurs
## Pour ajouter une ligne de densité:
### argument prob = TRUE affichage de la ligne de densité
### fonction lines(density(bd$age, na.rm = TRUE), lwd = 4, col = "green")


# Boite à moustaches: fonction boxplot  --------------------------

boxplot(bd$heures.tv, main="Heures d'écoute de la télé", col="green", xlab = "légende horizontale", ylab = "Heures d'écoute" )

# Comparer groupe avec la notation "formule" (y ~ x)

boxplot(age ~ hard.rock, bd)



# ============== 2. Package graphique ggplot2 (grammar of graphics) ==============

# ggplot fonctionnne en superposant des composantes (couches)
# ggplot() spécifie le tableau source des données
# geom(): géométrie, ie choix du graphique (ex:geom_histogram)
# aes(): aestetics, ie propriétés visuelles incluant l’axe des x , des y, la couleur des lignes ( colour ), ...
# Ensuite on peut personnaliser avec des titres, légendes, thèmes, facettes et tout un tas d'options

https://ggplot2.tidyverse.org/reference/ 
  
  
  #* 2.1. geom_histogram = Histogramme ----------------------

ggplot(bd) +                  # objet bd
  geom_histogram(aes(x = age))  # histogramme de la variable age

## Argument aes() imbriqué ici dans le geom() mais peut aussi être défini dans le ggplot()


ggplot(bd) + 
  geom_histogram(aes(x = age), fill="orchid1", colour = "white", binwidth = 5) +  # arguments de couleurs et largeur des barres
  ggtitle("Age des répondants") +   # titre du graphique
  xlab("Age") +                     # titre axe x
  ylab("Effectifs")                 # titre axe y


#***  Le *faceting* -----------------

# Le "faceting" permet d’effectuer plusieurs fois le même graphique selon les valeurs d’une ou plusieurs 
# variables qualitatives, içi facet_grid(~sexe)

ggplot(bd) +  
  geom_histogram(aes(x = age), fill="orchid1", colour = "white", breaks = c(0, 20, 40, 60, 80, 100)) +  # breaks= limites des catégories d'âge
  ggtitle("Age des répondants") +   # titre du graphique
  xlab("Age") +                     # titre axe x
  facet_grid(~sexe)                 # variable de groupes


#* 2.2. geom_bar - Graphique en barres --------------------

ggplot(bd) + 
  geom_bar(aes(x = trav.satisf), fill = "thistle3", width = .7) + 
  xlab("Satisfaction") +
  ylab("Effectifs") + 
  ggtitle("Satisfaction au travail") 


#*** Le *mapping* ---------------------

# Pour faire varier la couleur en fonction des valeurs prises par d'une autre variable, on réalise un "mappage"
# on doit alors placer l’attribut graphique (ici fill=) à l’intérieur de aes()

ggplot(bd) + 
  geom_bar(aes(x = occup, fill = sexe))                     # position = "stack" - effectifs de groupes superposés par défaut

ggplot(bd) + 
  geom_bar(aes(x = occup, fill = sexe), position = "dodge") # position = "dodge" - effectifs de groupes  côte à côte

ggplot(bd) + 
  geom_bar(aes(x = occup, fill = sexe), position = "fill")  # position = "fill" - proportions superposées des groupes


#* 2.3. geom_point: Nuage de points -----------------------

ggplot(bd) + 
  geom_point(aes(x = age, y = freres.soeurs, color = sexe), size=3, pch=19) + 
  scale_color_brewer("sexe", palette = "Accent") +
  theme(legend.position = "bottom", legend.box = "vertical") # ou appliquer des thèmes prédéfinis comme theme_dark()


## color= à l'intérieur de aes() permet de faire varier la couleur des points en fonction des valeurs d’une troisième variable 
## Modier la grosseur des points avec size= et le type avec pch=
## Autre répertoire de couleurs scale_color_brewer: RColorBrewer::display.brewer.all()
## theme() fonction permettant de personnaliser l'apparence des graphiques:
### permet d'appliquer des thèmes complets (ex: theme_dark()) ou des composantes spécifiques - voir aide ?theme

ggplot(bd) + 
  geom_point(aes(x = age, y = heures.tv, color=sexe, size=heures.tv), alpha=0.2) +
  scale_size("Heures de télé", range = c(1,10)) +
  scale_x_continuous("Age", limits = c(15,100)) +
  scale_y_continuous("Heures de télé", limits = c(0,15))

## size= déplacé à l'intérieur de eas permet de faire varier la grosseur des points selon une variable quantitative
## alpha= modifier la transparence
## scale() permet de définir les limites des échelles x et y et leur légende respective


### ajouter une droite de régression + lignes de densité
ggplot(bd, aes(x=age, y=freres.soeurs)) +
  geom_point(col="steelblue2") +
  geom_smooth(method="lm", col="thistle3") +
  geom_density2d(color = "orange") + 
  scale_x_log10()


#* 2.4. geom_boxplot - boite à moustache ---------------

# On passe en y la variable quanti et en x la variable quali
ggplot(bd) + 
  geom_boxplot(aes(x = trav.satisf, y =age), varwidth = TRUE, fill = "midnightblue", color = "chartreuse1") + # varwidth = largeur de la boite selon les effectifs de groupes
  ggtitle("Pratique de la religion")


# On fait varier la couleur selon une variable sexe et on "flip" le tout
ggplot(bd, aes(x = sexe, y = freres.soeurs, color = sexe)) + geom_boxplot() + coord_flip()

#* 2.5. geom_density - densité ---------------------

# Distribution de l'âge selon le sexe - densité superposée avec transparence

ggplot(bd, aes(x = age, color = sexe, fill=sexe)) + 
  geom_density(alpha=0.55)

