with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO;               use Ada.Text_IO;
with IP;                        use IP;

package LP is

    type T_Politique is (FIFO, LRU);
    
	type T_LP is limited private;
	
	
	-- Initialiser une Lp
	procedure Initialiser_LP(Lp: out T_LP;Taille_MAX: Integer;Politique: T_Politique);

	-- Détruire une table de routage.  Elle ne devra plus être utilisée.
	procedure Detruire (Lp : in out T_LP);


	-- Est-ce qu'une table de routage est vide ?
	function Est_Vide (Lp : in T_LP) return Boolean;


	-- Obtenir le nombre d'éléments d'une table de routage. 
	function Taille (Lp : in T_LP) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (Lp);
			
    -- Savoir si une destination est présente dans une table de routage.
	function Destination_Presente (Lp : in T_LP ; Destination : in T_Adresse_IP) return Boolean;


	-- Enregistrer un masque et une interface associés à une destination dans une table de routage.
	-- Si la destination est déjà présente dans la table de routage, on ne fait rien si c'est la politique est FIFO
	-- sinon (politique est LRU) on met la position de la destination la première
	procedure Enregistrer (Lp : in out T_LP ; Destination : in T_Adresse_IP; Supp: in out Boolean; Elem_Supp: in out T_Adresse_IP);

	-- Supprimer une ligne dans la table de routage.
	-- Exception si la destination n'est pas utilisée dans la table de routage
	procedure Supprimer (Lp : in out T_LP ; Destination : in T_Adresse_IP);
		
    procedure Afficher_LP (Lp : in T_LP ) ;



private
    type T_Cellule;
    type T_Pointeur_Cellule is access T_Cellule;

    type T_Cellule is record
        Destination : T_Adresse_IP;
        Suivant     : T_Pointeur_Cellule; -- Pour chaîner les éléments [cite: 64]
    end record;

    type T_LP is record
        Tete       : T_Pointeur_Cellule;
        Politique  : T_Politique; 
        Taille_MAX : Integer ; 
    end record;
    
end LP;


    


