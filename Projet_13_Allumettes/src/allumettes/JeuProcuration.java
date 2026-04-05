package allumettes;

/** Jeu en procuration qui autorise uniquement la lecture du nombre d'allumettes.
 * Toute tentative de retirer des allumettes lève une OperationInterditeException.
 * @author ABID Mohamed
 */
public class JeuProcuration implements Jeu {

    private Jeu vraiJeu;

	/** Initialiser la procuration avec le vrai jeu à encapsuler.
     * @param vraiJeu le jeu réel à encapsuler
     */
    public JeuProcuration(Jeu vraiJeu) {
        this.vraiJeu = vraiJeu;
    }  

	/** Obtenir le nombre d'allumettes encore en jeu.
	 * @return nombre d'allumettes encore en jeu
	 */
    @Override 
	public int getNombreAllumettes() {
        return this.vraiJeu.getNombreAllumettes();
    }  

	/** Retirer des allumettes.  Le nombre d'allumettes doit être compris
	 * entre 1 et PRISE_MAX, dans la limite du nombre d'allumettes encore
	 * en jeu.
	 * @param nbPrises nombre d'allumettes prises.
	 * @throws CoupInvalideException tentative de prendre un nombre invalide d'allumettes
	 */
    @Override
	public void retirer(int nbPrises) {
        throw new OperationInterditeException();
    } 

}
