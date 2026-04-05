with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Unchecked_Deallocation;

package body LC is

    procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_Lc);


    procedure Initialiser_LC (lc : out T_Lc) is   
    begin
        lc := Null;   
    end Initialiser_LC;
    
    
    
    procedure Enregistrer_LC (lc : in out T_Lc; Destination : in T_Adresse_IP; Masque : in T_Adresse_IP; Interfac: in Unbounded_String) is
    Nouvelle_Cellule, Parcours : T_Lc;
    
	begin
	    Nouvelle_Cellule := new T_Cellule;
	    Nouvelle_Cellule.All.Destination:=Destination;
	    Nouvelle_Cellule.All.Masque:=Masque;
	    Nouvelle_Cellule.All.Interfac:=Interfac;
	    Nouvelle_Cellule.All.Suivant:=Null;
	    
	    if(lc=Null) then
	        lc:=Nouvelle_Cellule;
	    else 
	        Parcours:=lc;
	        while(Parcours.All.Suivant/=Null) loop
	            Parcours:=Parcours.All.Suivant;
	        end loop;
	            
	        Parcours.All.Suivant:=Nouvelle_Cellule;
	    end if;
	    
		
	end Enregistrer_LC;
    
    
       
    function Chercher_Interface_LC (lc : in T_Lc; Paquet : in T_Adresse_IP) return Unbounded_String is
    -- p est la variable de parcours
	p: T_Lc;
	Interface_corresp: Unbounded_String := To_Unbounded_String("");
        
    begin  
        p:=lc;   
        while (p/=Null) loop
            if ((Paquet and p.All.Masque) = p.All.Destination) then
                return p.All.Interfac;     
            end if;          
            p:=p.All.Suivant;               
        end loop;
            
        return Interface_corresp;
            
    end Chercher_Interface_LC;
    
    
    procedure Supprimer_Route_LC (lc: in out T_Lc; Destination : in T_Adresse_IP) is
        p, prec : T_Lc;
    begin
        p := lc;
        prec := null;
        while p /= null loop
            if p.all.Destination = Destination then
                if prec = null then
                    lc := p.all.Suivant;
                else
                    prec.all.Suivant := p.all.Suivant;
                end if;
                Free(p);
                return;
            end if;
            prec := p;
            p := p.all.Suivant;
        end loop;
    end Supprimer_Route_LC;


    procedure Afficher_LC (lc : in T_Lc) is
    
        cellule_a_afficher: T_Lc;
	    l : Integer;
	    begin
	        cellule_a_afficher:=lc;
	        while (cellule_a_afficher/=Null) loop
	            --Afficher la destination sur une largeur égale à 25
	            Afficher_IP(cellule_a_afficher.All.Destination);
	            l:= longueur_chaine_IP(cellule_a_afficher.All.Destination);
	            for i in 1..(25-l) loop
	                put(" ");
	            end loop;
	            
	            --Afficher le masque sur une largeur égale à 25
	            Afficher_IP(cellule_a_afficher.All.Masque);
	            l:= longueur_chaine_IP(cellule_a_afficher.All.Masque);
	            for i in 1..(25-l) loop
	                put(" ");
	            end loop;
	            
	            --Afficher l'interface
	            Put(To_String(cellule_a_afficher.All.Interfac));
	            New_Line;
	            
	            cellule_a_afficher:=cellule_a_afficher.All.Suivant;
	        end loop;
	        
        end Afficher_LC;
        
    
    procedure Detruire_LC (lc : in out T_LC) is

	    begin
	        if (lc/=Null) then
	            Detruire_LC(lc.All.Suivant);
	        end if;
	        
	        Free(lc);
	        lc:=Null;
	        
	    end Detruire_LC;

end LC;
