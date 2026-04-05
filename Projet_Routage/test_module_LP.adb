with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;     use Ada.Float_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with LP;                    use LP;
with IP;                    use IP;

procedure test_module_LP is
    
	Lp: T_LP;
	test1: Boolean;
	test2: Boolean;
	supp: Boolean;
	
	Dest1, Dest2, Dest3, Dest4, Dest5,elem_supp : T_Adresse_IP;

begin


    
    -- Tester les procédures et fonctions sur Lp
    
    -- Tester si la Lp est bien initialisée
	Initialiser_LP (Lp,3,FIFO);
	
	if (Est_Vide(Lp)) then
	    put_Line( "Définir Initialiser et Est_Vide: ok ");
	else 
	    raise Constraint_Error with "Définir Initialiser et Est_Vide: Erreur ";
	end if;
	
	--Tester la procédure Enregistrer et Destination_Presente
	
    Enregistrer(Lp,Dest1,supp,elem_supp);
    
    if ( Destination_Presente(Lp,Dest1)) then
        put_Line( "Définir Enregistrer et Destination_Presente: ok ");
	else 
	    raise Constraint_Error with "Définir Enregistrer et Destination_Presente: Erreur ";
	end if;
	
	
	--Tester la fonction Taille
    
    test1 := (Taille(Lp)=1);
    
    Dest2:=Initialiser_IP(178,123,16,56);
	
	Enregistrer(Lp,Dest2,supp,elem_supp);
	
	Dest3:=Initialiser_IP(185,145,82,63);
	
	Enregistrer(Lp,Dest3,supp,elem_supp);
    
    test2 := (Taille(Lp)=3);
    
    Afficher_LP(Lp);
    put_Line("");
    Dest4:=Initialiser_IP(186,19,82,60);
	
	Enregistrer(Lp,Dest1,supp,elem_supp);
	Afficher_LP(Lp);
    put_Line("");
	
	Enregistrer(Lp,Dest4,supp,elem_supp);
	put(Boolean'Image(supp));
	put_Line("");
	
	Afficher_IP(elem_supp);
	
	put_Line("");
	put_Line("");
	Afficher_LP(Lp);
    
    if ( test1 and test2) then
        put_Line( "Définir Taille: ok ");
	else 
	    raise Constraint_Error with "Définir Taille: Erreur ";
	end if;
	
	
	
	--Tester la procédure Supprimer
	-- Cette procédure suppose que la cle existe sinon elle va lever une erreur 
	
	Supprimer(Lp,Dest2);
	test1:=(Destination_Presente(Lp,Dest1) and not Destination_Presente(Lp,Dest2) and Destination_Presente(Lp,Dest3));
	Supprimer(Lp,Dest1);
	Supprimer(Lp,Dest3);
    test2:=(not Destination_Presente(Lp,Dest1) and not Destination_Presente(Lp,Dest2) and not Destination_Presente(Lp,Dest3));
    
	if ( test1 and test2) then
        put_Line( "Définir Supprimer: ok ");
	else 
	    raise Constraint_Error with "Définir Supprimer: Erreur ";
	end if;
	
	
	--Tester la procédure Detruire
	
	Detruire(Lp);
	
	if (Est_Vide(Lp)) then
        put_Line( "Définir Detruire: ok ");
	else 
	    raise Constraint_Error with "Définir Detruire: Erreur ";
	end if;
	
end test_module_LP;
