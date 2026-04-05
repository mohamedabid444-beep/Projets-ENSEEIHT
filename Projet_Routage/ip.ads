with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO;               use Ada.Text_IO;

package IP is

    type T_Octet is mod 2 ** 8;
    type T_Adresse_IP is mod 2 ** 32;

    UN_OCTET: constant T_Adresse_IP := 2 ** 8;
    POIDS_FORT : constant T_Adresse_IP  := 2 ** 31;

    function Initialiser_IP(P1 : in Integer ; P2 : in Integer ; P3 : in Integer ; P4 : in Integer) return T_Adresse_IP;

    procedure Ecrire_IP (Fichier_Resultat : in File_Type; IP : in T_Adresse_IP);

    function Transf_Chaine_Adresse (Ad_ip : in Unbounded_String) return T_Adresse_IP ;

    function longueur_chaine_IP (IP : in T_Adresse_IP) return Integer ;
    
    function longueur_adresse_IP (IP : in T_Adresse_IP) return Integer ;
    
    -- Afficher une adresse IP.
	procedure Afficher_IP (IP : T_Adresse_IP) ;
	
	procedure Ajoute_bit_paquet_a_destination_masque(Paquet : in T_Adresse_IP; Dest_corresp : in out T_Adresse_IP; Ms_corresp : in out T_Adresse_IP);
        
end IP;
