with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;     use Ada.Float_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with TR;                    use TR;
with IP;                    use IP;

procedure test_module_TR is
    
	Tr: T_TR;
	test1: Boolean;
	test2: Boolean;
	
	Dest1, Dest2, Dest3, Dest4, Dest5, Dest_test, Dest_corresp : T_Adresse_IP;
	M1, M2, M3, M4, M5, Masque_test, Ms_corresp : T_Adresse_IP;
	I1, I2, I3, I4, I5: Unbounded_String;

begin

    -- Tester les procédures et fonctions sur le type T_Adresse_IP
    
    --Tester la fonction Initialiser_IP et la procédure Afficher_IP
    
    Dest1:=Initialiser_IP(147,5,5,5);
    Afficher_IP(Dest1);
    New_Line;
    
    --Tester la fonction Transf_chaine_Adresse et la procédure Afficher_IP
    
    Afficher_IP(Transf_chaine_Adresse(To_Unbounded_String ("198.54.89.65")));
    New_Line;
    
    -- Tester la fonction long
    put(longueur_chaine_IP(Transf_chaine_Adresse(To_Unbounded_String ("198.54.89.65"))));
    put(longueur_chaine_IP(Transf_chaine_Adresse(To_Unbounded_String ("198.54.0.0"))));
    put_line("");
    
    -- Tester la procedure Ajoute_bit_paquet_a_destination_masque
    put_line("Tester la procedure Ajoute_bit_paquet_a_destination_masque");
    
    Dest_corresp:=Initialiser_IP(0,0,0,0);
    Ms_corresp:=Initialiser_IP(0,0,0,0);
    
    Ajoute_bit_paquet_a_destination_masque(Dest1, Dest_corresp, Ms_corresp);
    
    Afficher_IP(Dest_corresp);
    put_line("");
    Afficher_IP(Ms_corresp);
    put_line("");
    
    Ajoute_bit_paquet_a_destination_masque(Dest1, Dest_corresp, Ms_corresp);
    
    Afficher_IP(Dest_corresp);
    put_line("");
    Afficher_IP(Ms_corresp);
    put_line("");
    
    Ajoute_bit_paquet_a_destination_masque(Dest1, Dest_corresp, Ms_corresp);
    
    Afficher_IP(Dest_corresp);
    put_line("");
    Afficher_IP(Ms_corresp);
    put_line("");
    
    Ajoute_bit_paquet_a_destination_masque(Dest1, Dest_corresp, Ms_corresp);
    
    Afficher_IP(Dest_corresp);
    put_line("");
    Afficher_IP(Ms_corresp);
    put_line("");
    
    Ajoute_bit_paquet_a_destination_masque(Dest1, Dest_corresp, Ms_corresp);
    
    Afficher_IP(Dest_corresp);
    put_line("");
    Afficher_IP(Ms_corresp);
    put_line("");
    

    
    
    
    
    
    
    -- Tester les procédures et fonctions sur la liste chainée Tr (Table de routage)
    
    -- Tester si la TR est bien initialisée
	Initialiser (Tr);
	
	if (Est_Vide(Tr)) then
	    put_Line( "Définir Initialiser et Est_Vide: ok ");
	else 
	    raise Constraint_Error with "Définir Initialiser et Est_Vide: Erreur ";
	end if;
	
	--Tester la procédure Enregistrer et Destination_Presente
	
	M1:=Initialiser_IP(255,255,255,255);
	I1 := To_Unbounded_String ("eth1");
	
    Enregistrer(Tr,Dest1,M1,I1);
    
    if ( not Destination_Presente(Tr,M1) and Destination_Presente(Tr,Dest1)) then
        put_Line( "Définir Enregistrer_Iteratif et Cle_Presente: ok ");
	else 
	    raise Constraint_Error with "Définir Enregistrer_Iteratif et Cle_Presente: Erreur ";
	end if;
	
	
	--Tester la fonction Taille
    
    test1 := (Taille(Tr)=1);
    
    Dest2:=Initialiser_IP(147,127,0,0);
	M2:=Initialiser_IP(255,255,0,0);
	I2 := To_Unbounded_String ("eth2");
	
	Enregistrer(Tr,Dest2,M2,I2);
	
	Dest3:=Initialiser_IP(0,0,0,0);
	M3:=Initialiser_IP(0,0,0,0);
	I3 := To_Unbounded_String ("eth3");
	
	Enregistrer(Tr,Dest3,M3,I3);
    
    test2 := (Taille(Tr)=3);
    
    if ( test1 and test2) then
        put_Line( "Définir Taille: ok ");
	else 
	    raise Constraint_Error with "Définir Taille: Erreur ";
	end if;
	
	--Tester les fonctions Destination_corresp et Masque_corresp
	Dest_test:=Destination_corresp(Tr,To_Unbounded_String ("eth3"));
	
	Masque_test:=Masque_corresp(Tr,To_Unbounded_String ("eth3"));
	
	Afficher_IP(Dest_test);
	put_Line("");
	Afficher_IP(Masque_test);
	put_Line("");

	--Tester la fonction Le_Masque
	-- Cette fonction suppose que la destination existe sinon elle va lever une erreur 
	
	if ( Le_Masque(Tr,Dest1)=M1 and Le_Masque(Tr,Dest2)=M2 and Le_Masque(Tr,Dest3)=M3) then
        put_Line( "Définir La_Valeur: ok ");
	else 
	    raise Constraint_Error with "Définir Le_Masque: Erreur ";
	end if;
	
	--Tester la fonction L_Interface
	-- Cette fonction suppose que la destination existe sinon elle va lever une erreur 
	
	if ( L_Interface(Tr,Dest1)=I1 and L_Interface(Tr,Dest2)=I2 and L_Interface(Tr,Dest3)=I3) then
        put_Line( "Définir L_Interface: ok ");
	else 
	    raise Constraint_Error with "Définir L_Interface: Erreur ";
	end if;
	
	
	--Tester la fonction Interface_f
	
	Dest4:=Initialiser_IP(147,127,127,0);
	M4:=Initialiser_IP(255,255,255,0);
	I4 := To_Unbounded_String ("eth4");
	
	Enregistrer(Tr,Dest4,M4,I4);
    
    Dest5:=Initialiser_IP(147,128,0,0);
	M5:=Initialiser_IP(255,255,0,0);
	I5 := To_Unbounded_String ("eth5");
	
	Enregistrer(Tr,Dest5,M5,I5);
	
	
	--put_Line(To_String(Interface_f(Tr,Initialiser_IP(147,127,18,85))));
    --Tester la fonction Nombre_Destination_corresp
    put(Nombre_Destination_corresp(Tr,Initialiser_IP(128,0,0,0),Initialiser_IP(192,0,0,0)),1);
    put_line("");
	
	--Tester la procédure Supprimer
	-- Cette procédure suppose que la cle existe sinon elle va lever une erreur 
	
	Supprimer(Tr,Dest2);
	test1:=(Destination_Presente(Tr,Dest1) and not Destination_Presente(Tr,Dest2) and Destination_Presente(Tr,Dest3));
	Supprimer(Tr,Dest1);
	Supprimer(Tr,Dest3);
    test2:=(not Destination_Presente(Tr,Dest1) and not Destination_Presente(Tr,Dest2) and not Destination_Presente(Tr,Dest3));
    
	if ( test1 and test2) then
        put_Line( "Définir Supprimer: ok ");
	else 
	    raise Constraint_Error with "Définir Supprimer: Erreur ";
	end if;
	
	
	--Tester la procédure Detruire
	
	Detruire(Tr);
	
	if (Est_Vide(Tr)) then
        put_Line( "Définir Detruire: ok ");
	else 
	    raise Constraint_Error with "Définir Detruire: Erreur ";
	end if;
	
end test_module_TR;
