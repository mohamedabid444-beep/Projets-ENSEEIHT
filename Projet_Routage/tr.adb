with Ada.Text_IO.Unbounded_IO;  use  Ada.Text_IO.Unbounded_IO;
with Ada.Unchecked_Deallocation;
package body TR is


	procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_TR);

	-- Les procédures et fonctions sur la liste chainée Tr (Table de routage)

	procedure Initialiser(Tr: out T_TR) is
	begin
		Tr := Null;
	end Initialiser;


	function Est_Vide (Tr : T_TR) return Boolean is
	begin
		return (Tr=Null);	
	end Est_Vide;


	procedure Detruire (Tr : in out T_TR) is

	begin
	    if (not Est_Vide(Tr)) then
	        Detruire(Tr.All.Suivant);
	    end if;
	    
	    Free(Tr);
	    Tr:=Null;
	    
	end Detruire;


	function Taille (Tr : in T_TR) return Integer is
		pt:T_TR;
		taille:Integer;
	begin
	    pt:=Tr;
	    taille:=0;
		while (pt /= Null) loop
			taille:= taille +1;
			pt:=pt.all.suivant;
		end loop;
		Free(pt);
		return taille;
		
	end Taille;


	function Destination_Presente (Tr : in T_TR ; Destination : in T_Adresse_IP) return Boolean is
	
	    pointeur_recherche : T_TR;
	    test : Boolean;
	    
	begin
	
	    pointeur_recherche:= Tr;
	    test:=False;
	        
	    while ((not(Est_Vide(pointeur_recherche))) and (not (test)) ) loop
	        
	        test:=(pointeur_recherche.All.Destination=Destination);
	        if (not test) then 
	            pointeur_recherche:=pointeur_recherche.All.Suivant;
	        else 
	            test:=True; 
	        end if;
	        
	    end loop;
	    
	    
	    return not Est_Vide(pointeur_recherche);
	
	    
	end Destination_Presente;


	function Le_Masque (Tr : in T_TR ; Destination : in T_Adresse_IP) return T_Adresse_IP is
        
	begin
	    if (Destination_Presente(Tr,Destination)) then
	     
	        if(Tr.All.Destination=Destination) then
	            return Tr.All.Masque;
	        else
	            return Le_Masque(Tr.All.Suivant,Destination);
	        end if;
	    
	    else 
	        raise Constraint_Error with "Destination n'est pas présente";
	    end if;
		
	end Le_Masque;
	
	function Destination_corresp(Tr : in T_TR ; Interfac : in Unbounded_String) return T_Adresse_IP is
        
	begin
	    if (not(Est_Vide(Tr))) then
	   
	        if(Tr.All.Interfac=Interfac) then
	            return Tr.All.Destination;
	        else
	            return Destination_corresp(Tr.All.Suivant,Interfac);
	        end if;
	    
	    else 
	        raise Constraint_Error with "Destination n'est pas présente";
	    end if;
		
	end Destination_corresp;
	
	
	function Masque_corresp(Tr : in T_TR ; Interfac : in Unbounded_String) return T_Adresse_IP is
        
	begin
	    if (not(Est_Vide(Tr))) then
	   
	        if(Tr.All.Interfac=Interfac) then
	            return Tr.All.Masque;
	        else
	            return Masque_corresp(Tr.All.Suivant,Interfac);
	        end if;
	    
	    else 
	        raise Constraint_Error with "Masque n'est pas présent";
	    end if;
		
	end Masque_corresp;
	
	
	function L_Interface (Tr : in T_TR ; Destination : in T_Adresse_IP) return Unbounded_String is
        
	begin
	    if (Destination_Presente(Tr,Destination)) then
	     
	        if(Tr.All.Destination=Destination) then
	            return Tr.All.Interfac;
	        else
	            return L_Interface(Tr.All.Suivant,Destination);
	        end if;
	    
	    else 
	        raise Constraint_Error with "Destination n'est pas présente";
	    end if;
		
	end L_Interface;



	procedure Enregistrer (Tr : in out T_TR ; Destination : in T_Adresse_IP ; Masque : in T_Adresse_IP ; Interfac : Unbounded_String) is
	    Nouvelle_Cellule, Parcours : T_TR;
	begin
		
		if (Destination_Presente(Tr,Destination)) then
	        
	        if(Tr.All.Destination=Destination) then
	            Tr.All.Masque:=Masque;
	        else
	            Enregistrer(Tr.All.Suivant,Destination,Masque,Interfac);
	        end if;
	    
	    else 
	        Nouvelle_Cellule := new T_Cellule;
	        Nouvelle_Cellule.All.Destination:=Destination;
	        Nouvelle_Cellule.All.Masque:=Masque;
	        Nouvelle_Cellule.All.Interfac:=Interfac;
	        Nouvelle_Cellule.All.Suivant:=Null;
	        
	        
	        if(Tr=Null) then
	            Tr:=Nouvelle_Cellule;
	        else 
	            Parcours:=Tr;
	            while(Parcours.All.Suivant/=Null) loop
	                Parcours:=Parcours.All.Suivant;
	            end loop;
	            
	            Parcours.All.Suivant:=Nouvelle_Cellule;
	        end if;
	    end if;
		
	end Enregistrer;


	procedure Supprimer (Tr : in out T_TR ; Destination : in T_Adresse_IP) is
	    cellule_a_supp: T_TR;
	begin
	    if (Destination_Presente(Tr, Destination)) then 
	    
		    if (Tr.All.Destination=Destination) then 
		        if (Est_Vide(Tr.All.Suivant)) then
		            Free(Tr);
		        else 
		            cellule_a_supp:= Tr;
		            Tr:=Tr.All.Suivant;
		            Free(cellule_a_supp);
		        end if;
		    else
		        Supprimer(Tr.Suivant,Destination);
		    end if;
		    
		else
	         raise Constraint_Error with "Destination n'est pas présente";
		    
	    end if;
		        
	end Supprimer;
	 
	
	-- Afficher la Table de routage en révélant sa structure interne.
	-- Voici l'affichage réalisé
	--     147.127.50.50            147.127.50.50           eth1  
	--     147.127.18.0             255.255.255.0           eth0    

	procedure Afficher_Table (Tr : in T_TR) is
    
	    cellule_a_afficher: T_Tr;
	    l, i: Integer;
	    begin
	        cellule_a_afficher:=Tr;
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
	            Put(cellule_a_afficher.All.Interfac);
	            New_Line;
	            
	            cellule_a_afficher:=cellule_a_afficher.All.Suivant;
	        end loop;
	        
	    end Afficher_Table;
	            


	function Interface_f (Tr : in T_TR ; Paquet : in T_Adresse_IP) return Unbounded_String is

    -- p est la variable de parcours
	p: T_Tr;
	Masque_d_Interface_corresp: T_Adresse_IP := 0;
	Interface_corresp: Unbounded_String := To_Unbounded_String("");
        
        begin  
            p:=Tr;   
            while (p/=Null) loop
                if ((Paquet and p.All.Masque) = p.All.Destination) then
					if (longueur_adresse_IP(p.All.Masque))>longueur_adresse_IP(Masque_d_Interface_corresp) then
                        Masque_d_Interface_corresp:= p.All.Masque;
                        Interface_corresp:= p.All.Interfac;   
                    end if;
                end if;
            
                p:=p.All.Suivant;
                
            end loop;
            
            return Interface_corresp;
            
        end Interface_f;
        
        
        
        
    function Nombre_Destination_corresp (Tr : in T_TR ; Paquet : in T_Adresse_IP ; Masque : in T_Adresse_IP) return Integer is
        -- p est la variable de parcours
	p: T_Tr;
	Nb_Destination_corresp: Integer;
        
        begin  
            Nb_Destination_corresp:=0;
            p:=Tr;   
            while (p/=Null) loop
            
                if ((p.All.Destination and Masque) = (Paquet and Masque)) then
                    Nb_Destination_corresp:=Nb_Destination_corresp+1;  
                end if;   
                p:=p.All.Suivant;
                
            end loop;
            
            return Nb_Destination_corresp;
            
        end Nombre_Destination_corresp;
        
	
	
end TR;
