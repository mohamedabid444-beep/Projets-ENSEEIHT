package allumettes;

/** Stratégie rapide : prend toujours le maximum d'allumettes possible.
 * @author ABID Mohamed
 */
public class StrategieRapide implements Strategie {
    
    /** Retourner le nombre maximum d'allumettes prenable.
     * @param jeu le jeu en cours
     * @return PRISE_MAX ou le nombre restant si inférieur à PRISE_MAX
     */
    @Override 
    public int getPrise(Jeu jeu) {
        int restant = jeu.getNombreAllumettes();

        if (restant < 3){
            return restant;
        } 
        else {  
            return 3;
        } 
    }  

}  