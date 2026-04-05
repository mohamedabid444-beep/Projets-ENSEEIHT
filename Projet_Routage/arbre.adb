with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Unchecked_Deallocation;

package body ARBRE is

    procedure Free is
        new Ada.Unchecked_Deallocation (Object => T_noeud, Name => T_Arbre);


    procedure Initialiser_ARBRE (Racine : out T_Arbre) is    
    begin
        Racine:=null;    
    end Initialiser_ARBRE;
    
    
    
    procedure Enregistrer_ARBRE (Racine : in out T_Arbre; Destination : in T_Adresse_IP; Masque : in T_Adresse_IP; Interfac: in Unbounded_String) is
     
        function Creer_Noeud_Vide return T_Arbre is
            Nouveau : T_Arbre;
        begin
            Nouveau := new T_noeud;
            Nouveau.all.gauche := null;
            Nouveau.all.droit := null;
            Nouveau.all.Interfac := To_Unbounded_String("");
            Nouveau.all.Est_Route := False;
            
            return Nouveau;
        end Creer_Noeud_Vide;

        Courant    : T_Arbre;
        Position   : Integer := 31;
        Poids_Bit  : T_Adresse_IP;
            
    begin
        if Racine = null then
            Racine := Creer_Noeud_Vide;
        end if;
        Courant := Racine;

        Position := 31;
        Poids_Bit := 2**Position; 

        
        while Position >= 0 and (Masque and Poids_Bit) /= 0 loop
            
            
            if (Destination and Poids_Bit) = 0 then
                if Courant.all.gauche = null then
                    Courant.all.gauche := Creer_Noeud_Vide;
                end if;
                Courant := Courant.all.gauche;
            else
                if Courant.all.droit = null then
                    Courant.all.droit := Creer_Noeud_Vide;
                end if;
                Courant := Courant.all.droit;
            end if;

            
            Position := Position - 1;
            if Position >= 0 then
                Poids_Bit := 2**Position; 
            end if;
        end loop;

        
        Courant.all.Interfac := Interfac;
        Courant.all.Est_Route := True;
    end Enregistrer_ARBRE;
    
    
       
    function Chercher_Interface_ARBRE (Racine : in T_Arbre; Paquet : in T_Adresse_IP) return Unbounded_String is
        Courant   : T_Arbre := Racine;
        Position  : Integer := 31;
        Poids_Bit : T_Adresse_IP;
    begin
        while Courant /= null loop
            
            if Courant.all.Est_Route then
                return Courant.all.Interfac;
            end if;

            
            Poids_Bit := 2**Position;
            if (Paquet and Poids_Bit) = 0 then
                Courant := Courant.all.gauche;
            else
                Courant := Courant.all.droit;
            end if;
            
            Position := Position - 1;
            exit when Position < 0;
        end loop;

      
        return To_Unbounded_String(""); 
    end Chercher_Interface_ARBRE;
    
     
    
    procedure Supprimer_Route_ARBRE (Racine: in out T_Arbre; Destination : in T_Adresse_IP) is
        
        Courant    : T_Arbre := Racine;
        Position   : Integer := 31;
        Poids_Bit  : T_Adresse_IP;
    begin
        while Courant /= null loop
            if Courant.all.Est_Route then
                Courant.all.Est_Route := False;
                Courant.all.Interfac := To_Unbounded_String("");
                return; 
            end if;

            exit when Position < 0;
            Poids_Bit := 2**Position;

            if (Destination and Poids_Bit) = 0 then
                Courant := Courant.all.gauche;
            else
                Courant := Courant.all.droit;
            end if;
            
            Position := Position - 1;
        end loop;
    end Supprimer_Route_ARBRE;
    
    
    
    -- C'est une fonction qui permet de donner le masque à partir d'un nombre binaire déduit de la profondeur       
    function Generer_Masque (Nb_Bits : in Integer) return T_Adresse_IP is
        Masque : T_Adresse_IP := 0;
    begin
        for I in 0 .. Nb_Bits - 1 loop
            Masque := Masque or (2**(31 - I));
        end loop;
        return Masque;
    end Generer_Masque;
    

    
    
    procedure Afficher_ARBRE_REC (Racine : in T_Arbre; IP_Actuelle : in T_Adresse_IP; Profondeur : in Integer) is
        Puissance_2, Masque : T_Adresse_IP;
        Nb_Bits_Masque, l : Integer;
        
             
        begin
            if Racine = null then
                return;
            end if;

           
            if Racine.all.Est_Route then
                Nb_Bits_Masque := 31 - Profondeur;
                
                --Afficher la destination sur une largeur égale à 25
	            Afficher_IP(IP_Actuelle);
	            l:= longueur_chaine_IP(IP_Actuelle);
	            for i in 1..(25-l) loop
	                put(" ");
	            end loop;
	            
	            --Afficher le masque sur une largeur égale à 25
	            Masque:=Generer_Masque(Nb_Bits_Masque);
	            Afficher_IP(Masque);
	            l:= longueur_chaine_IP(Masque);
	            for i in 1..(25-l) loop
	                put(" ");
	            end loop;
	            
	            --Afficher l'interface
	            Put(To_String(Racine.all.Interfac));
	            New_Line;
                
            end if;

            if Profondeur >= 0 then
                Puissance_2 := 2**Profondeur;
                
                Afficher_ARBRE_REC(Racine.all.gauche, IP_Actuelle, Profondeur - 1);
                
                Afficher_ARBRE_REC(Racine.all.droit, IP_Actuelle or Puissance_2, Profondeur - 1);
            end if;
        end Afficher_ARBRE_REC;
    
    
    
    
    procedure Afficher_ARBRE (Racine : in T_Arbre) is
                
        begin
        
            Afficher_ARBRE_REC(Racine, Initialiser_IP(0,0,0,0), 31);
            
        end Afficher_ARBRE;
    
    
    procedure Detruire_ARBRE (Racine : in out T_Arbre) is 
    
    begin 
        
        if (Racine/=Null) then
            Detruire_ARBRE(Racine.All.gauche);
            Detruire_ARBRE(Racine.All.droit);
        end if;
        
        Free(Racine);
        Racine:=Null;
        
    end Detruire_ARBRE;
   
    

end ARBRE;
