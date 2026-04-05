with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO;               use Ada.Text_IO;

with IP;                       use IP;

package TR is

	type T_TR is limited private;
	
	
	-- Initialiser une table de routage
	procedure Initialiser (Tr: out T_TR) with
		Post => Est_Vide (Tr);


	-- Détruire une table de routage.  Elle ne devra plus être utilisée.
	procedure Detruire (Tr : in out T_TR);


	-- Est-ce qu'une table de routage est vide ?
	function Est_Vide (Tr : in T_TR) return Boolean;


	-- Obtenir le nombre d'éléments d'une table de routage. 
	function Taille (Tr : in T_TR) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (Tr);


	-- Enregistrer un masque et une interface associés à une destination dans une table de routage.
	-- Si la destination est déjà présente dans la table de routage, sa valeur est changée.
	procedure Enregistrer (Tr : in out T_TR ; Destination : in T_Adresse_IP ; Masque : in T_Adresse_IP ; Interfac : Unbounded_String) with
		Post => Destination_Presente (Tr, Destination) and (Le_Masque (Tr, Destination) = Masque)   -- valeur insérée
				and (not (Destination_Presente (Tr, Destination)'Old) or Taille (Tr) = Taille (Tr)'Old)
				and (Destination_Presente (Tr, Destination)'Old or Taille (Tr) = Taille (Tr)'Old + 1);

	-- Supprimer une ligne dans la table de routage.
	-- Exception si la destination n'est pas utilisée dans la table de routage
	procedure Supprimer (Tr : in out T_TR ; Destination : in T_Adresse_IP) with
		Post =>  Taille (Tr) = Taille (Tr)'Old - 1 -- un élément de moins
			and not Destination_Presente (Tr, Destination);         -- la clé a été supprimée


	-- Savoir si une destination est présente dans une table de routage.
	function Destination_Presente (Tr : in T_TR ; Destination : in T_Adresse_IP) return Boolean;


	-- Obtenir le masque associé à une destination dans la Tr.
	-- Exception : si la destination n'est pas utilisée dans la table de routage.
	function Le_Masque (Tr : in T_TR ; Destination : in T_Adresse_IP) return T_Adresse_IP;
	
	
    -- Obtenir l'interface associée à une destination dans la Tr.
	-- Exception : si la destination n'est pas utilisée dans la table de routage.
	function L_Interface (Tr : in T_TR ; Destination : in T_Adresse_IP) return Unbounded_String;
	
	
	function Destination_corresp(Tr : in T_TR ; Interfac : in Unbounded_String) return T_Adresse_IP;
	
	
	function Masque_corresp(Tr : in T_TR ; Interfac : in Unbounded_String) return T_Adresse_IP;

	-- Afficher la table de routage en révélant sa structure interne.
	-- Voici l'affichage réalisé
	-- --> Destination              Masque                  Interface
	--     147.127.50.50            147.127.50.50           eth1  
	--     147.127.18.0             255.255.255.0           eth0   
	procedure Afficher_Table (Tr : in T_TR) ;
	
	-- La fonction (utilisé dans le raffinage) et qui permet de retourner l'interface à utiliser pour un paquet donnée
    function Interface_f (Tr : in T_TR; Paquet : in T_Adresse_IP) return Unbounded_String ;
	    
	-- Dans le cas d'une redondance dans la table de routage il faut une Adaptation : il faut que la fonction Nombre_Destination_corresp compte combien d'interfaces différentes sont touchées, et non combien de routes.
    function Nombre_Destination_corresp (Tr : in T_TR ; Paquet : in T_Adresse_IP ; Masque : in T_Adresse_IP) return Integer;


private
	type T_Cellule;

	type T_TR is access T_Cellule;

	type T_Cellule is record
			Destination: T_Adresse_IP;
			Masque: T_Adresse_IP; 
			Interfac: Unbounded_String;
			Suivant: T_TR;
		end record;
	

end TR;


    


