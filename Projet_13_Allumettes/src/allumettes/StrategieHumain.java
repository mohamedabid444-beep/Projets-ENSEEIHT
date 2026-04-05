package allumettes;
import java.util.Scanner;

/** Stratégie humaine : demande à l'utilisateur combien d'allumettes prendre.
 * @author ABID Mohamed
 */
public class StrategieHumain implements Strategie {

    private Scanner scanner = new Scanner(System.in);
    private String nom;

    /** Initialiser la stratégie humaine avec le nom du joueur.
     * @param nom le nom du joueur humain
     */
    public StrategieHumain(String nom) {
        
        this.nom = nom;
    }  
    
    /** Demander à l'utilisateur combien d'allumettes il souhaite prendre.
     * @param jeu le jeu en cours
     * @return le nombre d'allumettes saisi par l'utilisateur
     */
    @Override
    public int getPrise(Jeu jeu)  {
        while (true) {
            try {
                System.out.print(this.nom + ", combien d'allumettes ? ");
                String ligne = scanner.nextLine();
                if (ligne.equals("triche")) {
                    try {
                        jeu.retirer(1);
                    } catch (CoupInvalideException e) {}
                    System.out.println("[Une allumette en moins, plus que " + jeu.getNombreAllumettes() + ". Chut !]");

                } 
                else {
                    return Integer.parseInt(ligne);
    
                }  

            }catch (NumberFormatException e) {
                System.out.println("Vous devez donner un entier.");
            }
        }      
    }  
} 
