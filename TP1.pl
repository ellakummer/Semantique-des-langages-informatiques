/* ----------------------------- EXERCICE 1 ----------------------------- */

/* 	relations porte(De,Vers) : indiquent les portes et leur direction 	*/
porte(5,6).
porte(6,7).
porte(7,8).
porte(4,3).
porte(3,2).
porte(2,1).
porte(10,9).
porte(16,15).
porte(15,14).
porte(5,1).
porte(9,5).
porte(10,6).
porte(7,11).
porte(8,12).
porte(13,9).
porte(14,10).
porte(15,11).
porte(8,4).

/* relations entree(Piece), sortie(Piece), minotaure(Piece) 	*/
entree(13).
entree(16).
sortie(1).
sortie(12).
minotaure(7).


/* ----------------------------- EXERCICE 2 ----------------------------- */

/*	PARTIE 1 : chemin(De, Vers) retourne vrai s'il y a un chemin de la pièce De à la pièce Vers :  */

/*	cas de base : si on a une porte "De" qui est la même que "Vers", on est bon : on a un chemin */
chemin(Porte,Porte).
/*	règle récursive : (pas à pas)*/
chemin(De,Vers) :-
	porte(De,NouveauDe),
	chemin(NouveauDe,Vers).

/*	PARTIE 2 : itineraire(De, Vers, Piece) retourne dans
Pieces une liste des pièces à parcourir pour aller de De à Vers.  */
itineraire(Porte,Porte,[Porte]).
itineraire(De,Vers,[De|Piece]) :-
	/* on passe de porte à porte, en stockant chaque fois dans pièce la porte suivante*/
	porte(De,NouveauDe),
	itineraire(NouveauDe,Vers,Piece).

/* ----------------------------- EXERCICE 3 ----------------------------- */

/*	PARTIE 1 :
retourne dans Reste la charge restante de la batterie après avoir parcouru les
Pieces.(la batterie s’épuise d’une unité. Initialement,
celle-ci est chargée de 15 unités.)	*/

batterie([], Y, Y).
batterie([De|Pieces], Batterie, Reste) :-
	/* on diminue à chaque porte, la batterie de 1 */
	Bat is Batterie-1,
	/* on teste que la batterie n'est pas négative */
	Bat >= 0,
	/* on fait la récursion avec la suite du chemin et la batterie restante */
	batterie(Pieces, Bat, Reste).

/*	PARTIE 2 :
retourne dans Pieces un chemin allant de De à Vers, si
la Batterie le permet, et retourne dans Reste sa charge restante.*/

chemin_batterie(De, Vers, Batterie, Pieces, Reste) :-
	/* in prend les chemins de De à Vers */
	itineraire(De, Vers, Pieces),
	/* on garde ceux dont la batterie est suffisante */
	batterie(Pieces, Batterie, Reste).

/* ----------------------------- TEST  ----------------------------- */
test_batterie(De, Vers, Batterie, Pieces, Reste) :-
	itineraire(De, Vers, Pieces),
	batterie(Pieces, Batterie, Reste).

/* ----------------------------- FIN TEST ----------------------------- */

/* PARTIE 3 : */
/*retourne dans Pieces un chemin permettant de vaincre le Minotaure puis sortir */
/* attention verif : batterie, entree, sortie, minautore  -> EXPLICATION (fonction) PDF*/

chemin_reussite(Batterie, Pieces) :-
	/* on demande à commencer par une entrée : */
	entree(De),
	/* on demande à finir par une sortie : */
	sortie(Vers),
	chemin_batterie(De,Vers,Batterie,Pieces, Reste),
	/* on définit le minautore et vérifie (<-> il faut) qu'il soit dans Piece */
	minotaure(Mino),
	memberchk(Mino,Pieces).


/* ----------------------------- EXERCICE 4 ----------------------------- */

/* 	PARTIE 1 :
évaluée à vraie pour les chemins permettant de vaincre le Minotaure, tweeter et sortir.
Batterie contiendra la charge initiale de la batterie. */
/* on estime qu'on passe dans Piece le parcours */

/* comme avant, mais on veut qu'il reste 7 et pas 0 minimum de batterie à la fin*/
reussite_complete(Batterie, Pieces) :-
	chemin_reussite(Batterie,Pieces),
	batterie(Pieces,Batterie,Reste),
	/* on verifie que la batterie est au moins 7 = 2(tweet) + 5(eclairage) */
	Reste > 6.

/*	PARTIE 2 :
Écrivez la règle reussite_tweet(Batterie, Pieces) retournant vrai
pour les chemins permettant de vaincre le Minotaure, tweeter le résultat
de la bataille, mais pas de sortir. */
reussite_tweet(Batterie, Pieces) :-
	entree(De),
	/* on ne veut pas finir par une sortie :
	on vérifie que la destination n'est pas une sortie : */
	member(Vers,[2,3,4,5,6,7,8,9,10,11,13,14,15,16]),
	chemin_batterie(De,Vers,Batterie,Pieces, Reste),
	minotaure(Mino),
	memberchk(Mino,Pieces),
	batterie(Pieces,Batterie,Reste),
	/* on veut finir à 0 de batterie (on laisse 7 pour tweet et éclairage) */
	Reste = 7.
