package allumettes;

/** Représente un joueur identifié par un nom et une stratégie de jeu.
 * @author ABID Mohamed
 */
public class JeuReel implements Jeu {

    private int NombreAllumettes;

    /** Initialiser un jeu avec un nombre d'allumettes donné.
     * @param nbAllumettes le nombre d'allumettes au début de la partie
     */
    public JeuReel(int NbAllumettes) {
        this.NombreAllumettes = NbAllumettes;
    }  

	/** Obtenir le nombre d'allumettes encore en jeu.
	 * @return nombre d'allumettes encore en jeu
	 */
    @Override 
	public int getNombreAllumettes() {
        return this.NombreAllumettes;
    }  

	/** Retirer des allumettes.  Le nombre d'allumettes doit être compris
	 * entre 1 et PRISE_MAX, dans la limite du nombre d'allumettes encore
	 * en jeu.
	 * @param nbPrises nombre d'allumettes prises.
	 * @throws CoupInvalideException tentative de prendre un nombre invalide d'allumettes
	 */
    @Override
	public void retirer(int nbPrises) throws CoupInvalideException {
        if (nbPrises > PRISE_MAX) {
            if (PRISE_MAX > this.getNombreAllumettes()) {
                throw new CoupInvalideException(nbPrises, "> " + this.getNombreAllumettes() );
          
            } 
            else {
                throw new CoupInvalideException(nbPrises, "> " + PRISE_MAX );
            }  
        } 
        else if (nbPrises > this.NombreAllumettes) {
            throw new CoupInvalideException(nbPrises, "> " + this.getNombreAllumettes());
        } 
        else if (nbPrises < 1) {
            throw new CoupInvalideException(nbPrises, ("< 1"));
        }  

        this.NombreAllumettes = this.NombreAllumettes - nbPrises;
    } 

}
