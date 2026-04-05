package allumettes;

/** Lance une partie des 13 allumettes en fonction des arguments fournis
 * sur la ligne de commande.
 * @author	ABID Mohamed
 */
public class Jouer {


	private static int estConfiant(String[] args) {
		if (args[0].equals("-confiant")){
			return 1;
		} 
		else {
			return 0;
		} 
	}

	/** Lancer une partie. En argument sont donnés les deux joueurs sous
	 * la forme nom@stratégie.
	 * @param args la description des deux joueurs
	 */
	public static void main(String[] args) {
		try {
			verifierNombreArguments(args);

			// Initialiser les deux joueurs
			Joueur joueur1 = initJoueur (args[Jouer.estConfiant(args)]);
			Joueur joueur2 = initJoueur (args[1+Jouer.estConfiant(args)]);

			// Initialiser le jeu et l'arbitre
			Jeu jeu = new JeuReel(13);
			Arbitre arbitre = new Arbitre(joueur1, joueur2, (estConfiant(args) == 1));

			// Lancer la partie
			arbitre.arbitrer(jeu);

		} catch (ConfigurationException e) {
			System.out.println();
			System.out.println("Erreur : " + e.getMessage());
			afficherUsage();
			System.exit(1);
		} 



	}

	private static Joueur initJoueur(String nomEtStrategie) {
		String[] caracJoueur = nomEtStrategie.split("@");

		if (caracJoueur.length != 2) {
        	throw new ConfigurationException("Format incorrect : " + nomEtStrategie);
    	}

		String nom = caracJoueur[0]; 
		String strategieString = caracJoueur[1];

		if (nom.isEmpty()) {
			throw new ConfigurationException("Nom manquant dans : " + nomEtStrategie);
		}
		if (strategieString.isEmpty()) {
			throw new ConfigurationException("Stratégie manquante dans : " + nomEtStrategie);
		}	
		Strategie strategie;

		if (strategieString.equals("naif") ){
			strategie = new StrategieNaive();
		} 
		else if (strategieString.equals("rapide")) {
			strategie = new StrategieRapide();
		}  
		else if (strategieString.equals("expert")) {
			strategie = new StrategieExpert();
		}  
		else if (strategieString.equals("humain")) {
			strategie = new StrategieHumain(nom);
		}  
		else if (strategieString.equals("tricheur")) {
			strategie = new StrategieTriche();
		} 
		else {
			throw new ConfigurationException("Stratégie inconnue : " + strategieString);
		}  

		Joueur joueur = new Joueur(caracJoueur[0], strategie);
		
		return joueur;
	} 

	private static void verifierNombreArguments(String[] args) {
		final int nbJoueurs = 2;
		if (args.length < nbJoueurs) {
			throw new ConfigurationException("Trop peu d'arguments : "
					+ args.length);
		}
		// Modifiée
		if (args.length > nbJoueurs + 2) {
			throw new ConfigurationException("Trop d'arguments : "
					+ args.length);
		}
		if (args.length == 3 && !args[0].equals("-confiant") ) {
			throw new ConfigurationException("Trop d'arguments : "
					+ args.length);
		}
	}

	/** Afficher des indications sur la manière d'exécuter cette classe. */
	public static void afficherUsage() {
		System.out.println("\n" + "Usage :"
				+ "\n\t" + "java allumettes.Jouer joueur1 joueur2"
				+ "\n\t\t" + "joueur est de la forme nom@stratégie"
				+ "\n\t\t" + "strategie = naif | rapide | expert | humain | tricheur"
				+ "\n"
				+ "\n\t" + "Exemple :"
				+ "\n\t" + "	java allumettes.Jouer Xavier@humain "
					   + "Ordinateur@naif"
				+ "\n"
				);
	}

}
