with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;


package body CACHE is

    


    procedure Initialiser_CACHE (Cache : out T_Cache; Structure_Cache: STRCT_CACHE; Taille_MAX : in Integer; Politique: in T_Politique) is  
    begin
        Initialiser_LP(Cache.Liste_Priorite,Taille_MAX,Politique);
        Initialiser_Arbre(Cache.Arbre);    
        Initialiser_LC(Cache.lc);
        Cache.Structure_Cache:=Structure_Cache;
    end Initialiser_CACHE;
    
    
    
    procedure Enregistrer_CACHE (Cache : in out T_Cache; Destination : in T_Adresse_IP; Masque : in T_Adresse_IP; Interfac: in Unbounded_String) is 
    begin
        if (Cache.Structure_Cache=Arbre_prefixe)then
            Enregistrer_Arbre (Cache.Arbre, Destination, Masque, Interfac);
        else
            Enregistrer_LC (Cache.lc, Destination, Masque, Interfac);   
        end if;    
        
    end Enregistrer_CACHE;
    
    
       
    function Chercher_Interface_CACHE (Cache : in T_Cache; Paquet : in T_Adresse_IP) return Unbounded_String is
    begin
        if (Cache.Structure_Cache=Arbre_prefixe)then
            return Chercher_Interface_ARBRE (Cache.Arbre, Paquet) ;
        else
            return Chercher_Interface_LC (Cache.lc, Paquet) ;   
        end if;   
               
    end Chercher_Interface_CACHE;
    
     
    
    procedure Supprimer_Route_CACHE (Cache : in out T_Cache; Destination : in T_Adresse_IP) is
    begin
        if (Cache.Structure_Cache=Arbre_prefixe)then
            Supprimer_Route_Arbre (Cache.Arbre, Destination);
        else
            Supprimer_Route_LC (Cache.lc, Destination);   
        end if;
        
    end Supprimer_Route_CACHE;
    
    

    procedure Mettre_A_Jour_CACHE (Cache : in out T_Cache; Table_de_routage : in T_TR; Paquet : in T_Adresse_IP; Interface_corresp: in Unbounded_String) is
    
        Dest_corresp, Ms_corresp, Elem_Supp: T_Adresse_IP;
        Supp: Boolean;
        
    begin
        --La route correspondante au paquet: Destination_corresp et Masque_corresp
        Dest_corresp:=Destination_corresp(Table_de_routage,Interface_corresp);
        
	    Ms_corresp:=Masque_corresp(Table_de_routage,Interface_corresp);
	     
        --Ajouter bit par bit afin qu'on ne se trompe pas d'interface (être distingué par rapport aux autres)
        
        while (Nombre_Destination_corresp(Table_de_routage,Dest_corresp,Ms_corresp)>1) loop
            --Ajouter un bit du paquet à la destination correspondante et un bit au masque 
            Ajoute_bit_paquet_a_destination_masque(Paquet, Dest_corresp, Ms_corresp);
	
        end loop;
       
        
        --Stocker la variable dans la liste de priorite: LP et une eventuelle suppression si LP est pleine
        Enregistrer (Cache.Liste_Priorite, Dest_corresp, Supp, Elem_Supp);
        if (Supp) then 
            Supprimer_Route_CACHE (Cache,Elem_Supp);
        end if;
        --Stocker la variable dans l'arbre et une eventuelle suppression de la destination supprimée de la LP
        Enregistrer_CACHE (Cache, Dest_corresp, Ms_corresp, Interface_corresp); 
        
    end Mettre_A_Jour_CACHE;
    
    
    

    procedure Afficher_CACHE (Cache : in T_Cache) is
    begin
        if (Cache.Structure_Cache=Arbre_prefixe)then
            Afficher_ARBRE (Cache.Arbre);   
        else
            Afficher_LC(Cache.lc);  
        end if;
     
    end Afficher_CACHE;
    
    
    procedure Detruire_CACHE (Cache : in out T_Cache) is
    
    begin
        if (Cache.Structure_Cache=Arbre_prefixe)then
            Detruire_ARBRE (Cache.Arbre);   
        else
            Detruire_LC (Cache.lc);  
        end if;
        
        Detruire (Cache.Liste_Priorite); 
        
        
    end Detruire_CACHE;
    
  

end CACHE;
