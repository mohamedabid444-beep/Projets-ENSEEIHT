with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with TR; use TR;
with IP; use IP;
with LP; use LP;

package ARBRE is
   
    type T_Arbre is limited private;
   

    -- Initialiser un arbre
    procedure Initialiser_ARBRE(Racine : out T_Arbre);

    -- Enregistrer une destination, un masque et une interface dans l'arbre
    procedure Enregistrer_ARBRE (Racine : in out T_Arbre; Destination : in T_Adresse_IP; Masque : in T_Adresse_IP; Interfac: in Unbounded_String);
   
    -- Chercher dans l'arbre l'interface correspondante à un paquet donné
    --Cette fct retourne une chaine vide si pas d'interface correspondante
    function Chercher_Interface_ARBRE (Racine : T_Arbre; Paquet : T_Adresse_IP) return Unbounded_String ;
   
    --Supprimer une Route (Destination_masque_Interface) de l'arbre
    procedure Supprimer_Route_ARBRE (Racine: in out T_Arbre; Destination : in T_Adresse_IP);
   
    --Cette fonction affiche les Routes stockées dans l'arbre 
    procedure Afficher_ARBRE (Racine : in T_Arbre);
    

    -- Détruire l'arbre et libérer la mémoire 
    procedure Detruire_ARBRE (Racine : in out T_Arbre);

private

    type T_noeud;
    
    type T_Arbre is access T_noeud;
    
    type T_noeud is record
        Interfac: Unbounded_String;-- C'est l'interface
		Est_Route: Boolean; -- Indique si le noeud contient une route ou bien juste un noeud intermediaire
		gauche: T_Arbre;
		droit: T_Arbre;			
	end record;

end ARBRE;
