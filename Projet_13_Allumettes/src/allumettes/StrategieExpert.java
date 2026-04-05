package allumettes;

/** Stratégie experte : joue toujours le coup optimal pour gagner.
 * @author ABID Mohamed
 */
public class StrategieExpert implements Strategie {

    /** Indique si une position est perdante pour le joueur en cours.
     * @param nbAllumettes le nombre d'allumettes restantes
     * @return true si la position est perdante, false sinon
     */
    private boolean estPerdant(int nbAllumettes) {
        return ((nbAllumettes - 1)%4 == 0);
    } 

    /** Calculer le coup optimal à jouer.
     * @param nbAllumettes le nombre d'allumettes restantes
     * @return le nombre d'allumettes à prendre pour se placer en position gagnante
     */
    private int coupExpert (int nbAllumettes) {
        if (estPerdant(nbAllumettes - 1)) {
            return 1;
        }   

        else if (estPerdant(nbAllumettes - 2)) {
            return 2;
        }  

        else {
            return 3;
        } 
    } 
    
    /** Retourner le coup expert à jouer.
     * @param jeu le jeu en cours
     * @return le nombre d'allumettes à prendre
     */
    public int getPrise(Jeu jeu) {

        int restant = jeu.getNombreAllumettes();

        if (estPerdant(restant)){
            //On prend 1 pour essayer de durer
            return 1;
        } 
        else {  
            return coupExpert(restant);
        } 
    }  

}  