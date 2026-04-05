package allumettes;

/** Représente un joueur identifié par un nom et une stratégie de jeu.
 * @author ABID Mohamed
 */
public class Joueur {

    private String nom;
    /* On a choisie de faire strategie comme attribut de Joueur afin de sastisfaire 
la contrainte C14*/
    private Strategie strategie;

    /** Initialiser un joueur avec un nom et une stratégie.
     * @param nom le nom du joueur
     * @param strategie la stratégie utilisée par le joueur
     */
    public Joueur(String nom, Strategie strategie){
        this.nom = nom;
        this.strategie = strategie;
    }

    /** Retourner le nom du joueur.
     * @return le nom du joueur
     */
    public String getNom() {
        return this.nom;
    }

    /** Retourner la stratégie du joueur.
     * @return la stratégie du joueur
     */
    public Strategie getStrategie() {
        return this.strategie;
    } 

    /** Obtenir le nombre d'allumettes que le joueur souhaite prendre.
     * @param jeu le jeu en cours
     * @return le nombre d'allumettes choisies par la stratégie
     */
    public int getPrise (Jeu jeu) {
        return this.getStrategie().getPrise(jeu);
    }
}