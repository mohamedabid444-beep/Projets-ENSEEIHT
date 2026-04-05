with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with TR; use TR;
with IP; use IP;
with LP; use LP;

package LC is
   
    type T_Lc is limited private;
   

    -- Initialiser une liste chainée
    procedure Initialiser_LC(lc : out T_Lc);

    -- Enregistrer une destination, un masque et une interface dans laliste chainée
    procedure Enregistrer_LC (lc : in out T_Lc; Destination : in T_Adresse_IP; Masque : in T_Adresse_IP; Interfac: in Unbounded_String);
   
    -- Chercher dans la liste chainée l'interface correspondante à un paquet donné
    --Cette fct retourne une chaine vide si pas d'interface correspondante
    function Chercher_Interface_LC (lc : in T_Lc; Paquet : in T_Adresse_IP) return Unbounded_String ;
   
    --Supprimer une Route (Destination_masque_Interface) de la liste chainée
    procedure Supprimer_Route_LC (lc: in out T_Lc; Destination : in T_Adresse_IP);
   
    --Cette fonction affiche les Routes stockées dans la liste chainée
    procedure Afficher_LC (lc : in T_Lc);

   -- Détruire la liste chainée et libérer la mémoire 
   procedure Detruire_LC (lc : in out T_LC) ;

private

    type T_Cellule is record
        Destination: T_Adresse_IP;
		Masque: T_Adresse_IP; 
		Interfac: Unbounded_String;
		Suivant: T_Lc;
    end record;

	type T_Lc is access T_Cellule;

	

end LC;
