package allumettes;

/** Stratégie tricheuse : retire des allumettes en dehors de son tour
 * jusqu'à ce qu'il n'en reste que 2, puis en prend 1.
 * @author ABID Mohamed
 */
public class StrategieTriche implements Strategie {

    /** Tricher en retirant des allumettes jusqu'à n'en laisser que 2,
     * puis retourner 1.
     * @param jeu le jeu en cours
     * @return toujours 1
     */
    @Override
    public int getPrise(Jeu jeu) {
        try {
            System.out.println("[Je triche...]");
            while (jeu.getNombreAllumettes() > 2) {
                jeu.retirer(1);
            } 
            System.out.println("[Allumettes restantes : " + jeu.getNombreAllumettes() + "]");

        }catch (CoupInvalideException e) {} 
        
        return 1;
    }  

    
} 
