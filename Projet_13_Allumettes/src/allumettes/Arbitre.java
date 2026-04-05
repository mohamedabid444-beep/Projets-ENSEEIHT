package allumettes;
/** Arbitre qui gère le déroulement d'une partie des allumettes.
 * @author ABID Mohamed
 */

public class Arbitre {

    private Joueur joueur1;
    private Joueur joueur2;
    private boolean confiant;

    /** Initialiser un arbitre avec deux joueurs et un mode de confiance.
     * @param j1 le premier joueur
     * @param j2 le deuxième joueur
     * @param estConfiant true si l'arbitre fait confiance aux joueurs, false sinon
     */

    public Arbitre (Joueur j1, Joueur j2, boolean estConfiant){
        this.joueur1 = j1;
        this.joueur2 = j2;
        this.confiant = estConfiant;
    }

    /** Initialiser un arbitre méfiant avec deux joueurs.
     * @param j1 le premier joueur
     * @param j2 le deuxième joueur
     */

    public Arbitre(Joueur j1, Joueur j2) {
        this(j1, j2, false);
    }

    /** Arbitrer une partie entre les deux joueurs.
     * @param jeu le jeu à arbitrer
     */
    public void arbitrer (Jeu jeu) {

        Joueur courant = this.joueur1;
        Jeu jeuAFaire;
        boolean estTriche = false;

        if (this.confiant){
            jeuAFaire = jeu; 
        } 
        else {
            jeuAFaire = new JeuProcuration(jeu);
        } 

        while (jeu.getNombreAllumettes() != 0) {

            System.out.println("Allumettes restantes : " + jeu.getNombreAllumettes());
            try{ 
                
                int prise = courant.getPrise(jeuAFaire);
        
                if (prise > 1) {
                    System.out.println(courant.getNom() + " prend " + prise + " allumettes.");
                } 
                else {
                    System.out.println(courant.getNom() + " prend " + prise + " allumette.");
                } 

                jeu.retirer(prise); 


                if (courant == this.joueur1) {
                    courant = this.joueur2;
                } 
                else {
                    courant = this.joueur1;
                }
                System.out.println("");
                
            } catch(CoupInvalideException e) {
                System.out.println("Impossible ! Nombre invalide : " + e.getCoup() + " (" + e.getProbleme() + ")");
                System.out.println("");
            } catch (OperationInterditeException e) {
			    System.out.println("Abandon de la partie car " + courant.getNom() + " triche !");
                estTriche = true;
                break;
		    }
        } 
        if (!estTriche) {
            if(courant == this.joueur1) {
                System.out.println(joueur2.getNom() + " perd !");
                System.out.println(joueur1.getNom() + " gagne !");   
            } 
            else{
                System.out.println(joueur1.getNom() + " perd !");
                System.out.println(joueur2.getNom() + " gagne !");
            } 
        }     
    }
}
