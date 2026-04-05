package allumettes;
import java.util.Random;

/** Stratégie naïve : choisit un nombre d'allumettes aléatoire entre 1 et PRISE_MAX.
 * @author ABID Mohamed
 */
public class StrategieNaive implements Strategie {

    private Random random;

    /** Initialiser la stratégie naïve avec un générateur aléatoire. */
    public StrategieNaive() {
        this.random = new Random();     
    } 

    /** Retourner une prise aléatoire entre 1 et PRISE_MAX.
     * @param jeu le jeu en cours (non utilisé)
     * @return un nombre d'allumettes aléatoire
     */
    @Override 
    public int getPrise(Jeu jeu) {
        
        return random.nextInt(3)+1;
    }  

}  