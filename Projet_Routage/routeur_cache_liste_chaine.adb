with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Command_Line;     use Ada.Command_Line;
with Ada.Strings;               use Ada.Strings;	
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with TR;        use TR;
with IP;        use IP;
with CACHE; use CACHE;
with LP;    use LP;


procedure Routeur_Cache_Liste_Chaine is
   Nom_Fichier_Table : Unbounded_String;
   Nom_Fichier_Paquet : Unbounded_String;
   Nom_Fichier_Resultats : Unbounded_String;

   Table_File : File_Type;
   Paquet_File : File_Type;
   Resultat_File : File_Type;
	

   Table_Routage : T_TR;
   Table_Cache : T_Cache;

   Taille_Cache : Integer := 10; -- Valeur par défaut
   Politique_Cache : T_Politique := FIFO; -- Valeur par défaut
   Afficher_Stats_Argument : Boolean := False;

   Nb_Defauts_Cache : Integer := 0;
   Nb_Demandes_Route : Integer := 0;

   procedure Afficher_Statistiques (Nb_Defauts : in Integer; Nb_Demandes : in Integer) is
      Taux_Defauts : Float;
   begin
      Put_Line("Le nombre de défauts de cache est : " & Integer'Image(Nb_Defauts));
      Put_Line("Le nombre de demandes de route est : " & Integer'Image(Nb_Demandes));
      if Nb_Demandes > 0 then
         Taux_Defauts := Float(Nb_Defauts) / Float(Nb_Demandes);
         Put_Line("Le taux de défaut de cache est : " & Float'Image(Taux_Defauts));
      else
         Put_Line("Le taux de défaut de cache est : 0.0");
      end if;
   end Afficher_Statistiques;

   

   -- Afficher l'usage.
   -- -t fichier_table -q fichier_paquet -r fichier_resultats
   -- arguement dans n'importe quel ordre
   procedure Afficher_Usage is
	begin
      New_Line;
      Put_Line ("Usage : " & Command_Name & " -t fichier_table -q fichier_paquet -r fichier_resultats");
      New_Line;
      Put_Line ("   -t fichier_table      : le fichier contenant la table de routage");
      Put_Line ("   -q fichier_paquet     : le fichier contenant les paquets à router");
      Put_Line ("   -r fichier_resultats  : le fichier où écrire les résultats");
      Put_Line ("   -c taille             : taille max du cache (defaut 10)");
      Put_Line ("   -p politique          : FIFO ou LRU (defaut FIFO)");
      Put_Line ("   -s                    : afficher les statistiques du cache");
      New_Line;
	end Afficher_Usage;
   procedure Ouvrir_Fichiers (
      Nom_Fichier_Table     : in Unbounded_String;
      Nom_Fichier_Paquet    : in Unbounded_String;
      Nom_Fichier_Resultats : in Unbounded_String) is
     
   begin
		Open (Table_File, In_File, To_String (Nom_Fichier_Table));
      Open (Paquet_File, In_File, To_String (Nom_Fichier_Paquet));
      Create (Resultat_File, Out_File, To_String (Nom_Fichier_Resultats));
   end Ouvrir_Fichiers;


-- Fonction à revoir, elle me semble compliquée...
   procedure Split (
      Ligne_Origine : in Unbounded_String;
      Separateur    : in Character;
      Partie1       : out Unbounded_String;
      Partie2       : out Unbounded_String;
      Partie3       : out Unbounded_String) is
   
      Indice_Separateur : Integer;
      Ligne_Temp        : Unbounded_String := Ligne_Origine;
      Reste             : Unbounded_String;
   begin
      Indice_Separateur := Index (Ligne_Temp, "" & Separateur); -- "" & Char permet de convertir Character en String
      if Indice_Separateur > 0 then
         Partie1 := To_Unbounded_String (Slice (Ligne_Temp, 1, Indice_Separateur - 1));
         Reste := To_Unbounded_String (Slice (Ligne_Temp, Indice_Separateur + 1, Length (Ligne_Temp)));
      else
         Partie1 := Ligne_Temp;
         Reste := Null_Unbounded_String;
      end if;

      Indice_Separateur := Index (Reste, "" & Separateur);
      if Indice_Separateur > 0 then
         Partie2 := To_Unbounded_String (Slice (Reste, 1, Indice_Separateur - 1));
         Partie3 := To_Unbounded_String (Slice (Reste, Indice_Separateur + 1, Length (Reste)));
      else
         Partie2 := Reste;
         Partie3 := Null_Unbounded_String;
      end if;
   end Split;

   --  -- Transf_Chaine_Adresse transforme un unbounded_string "147.127.0.0" en T_Adresse_IP en faisant comme dans le fichier exemple_adresse_IP
   --  function Transf_Chaine_Adresse (Adresse : in Unbounded_String) return T_Adresse_IP is
   --     Partie1, Partie2, Partie3, Partie4, Reste1, Reste2 : Unbounded_String;
   --     Octet1, Octet2, Octet3, Octet4 : T_Adresse_IP;
   --     Adresse_IP : T_Adresse_IP := 0;
   --  begin
   --     Split (Adresse, '.', Partie1, Partie2, Reste1);
   --     Split (Reste1, '.', Partie3, Partie4, Reste2);
   --     Octet1 := T_Adresse_IP (Integer'Value (To_String (Partie1)));
   --     Octet2 := T_Adresse_IP (Integer'Value (To_String (Partie2)));
   --     Octet3 := T_Adresse_IP (Integer'Value (To_String (Partie3)));
   --     Octet4 := T_Adresse_IP (Integer'Value (To_String (Partie4)));

   --     Adresse_IP := Octet1;
   --     Adresse_IP := Adresse_IP * UN_OCTET + Octet2;
   --     Adresse_IP := Adresse_IP * UN_OCTET + Octet3;
   --     Adresse_IP := Adresse_IP * UN_OCTET + Octet4;
   --     return Adresse_IP;   
   --  end Transf_Chaine_Adresse;

-- Table de routage dans le fichier tables.txt de la forme :
--Destination Masque Interface
--147.127.0.0 255.255.0.0 eth1
--147.127.18.0 255.255.255.0 eth0
   procedure Lire_Table_De_Routage (Fichier : in File_Type) is
   Ligne : Unbounded_String;
   Destination : Unbounded_String;
   Masque : Unbounded_String;
   Interfac : Unbounded_String;
   begin
      loop
         exit when End_Of_File (Fichier);
         Get_Line (Fichier, Ligne);
         Ligne := Trim(Ligne, Both);
         -- Ignorer lignes vides et éventuellement la ligne d'entête "Destination ..."
         if Ligne = Null_Unbounded_String or else Index(Ligne, "Destination") = 1 then
            null;
         else
            Split (Ligne, ' ', Destination, Masque, Interfac);
            Enregistrer (Table_Routage, Destination => Transf_Chaine_Adresse (Destination), Masque => Transf_Chaine_Adresse (Masque), Interfac => Interfac);
         end if;
      end loop;
   end Lire_Table_De_Routage;

   procedure Traiter_Paquets (
      Fichier_Paquet : in File_Type;
      Fichier_Resultat : in File_Type) is

   Ligne : Unbounded_String;
   Paquet : Unbounded_String;
   Interface_Utilisee : Unbounded_String;
   IP_Paquet : T_Adresse_IP;
   Numero_Ligne : Integer := 0;
   begin
      loop
         exit when End_Of_File (Fichier_Paquet);
         Get_Line (Fichier_Paquet, Ligne);
         Numero_Ligne := Numero_Ligne + 1;
         
         Ligne := Trim(Ligne, Both);
         
         if Ligne = To_Unbounded_String("table") then
            New_Line;
            Put_Line("table (ligne" & Integer'Image(Numero_Ligne) & ")");
            Afficher_Table(Table_Routage);
            
         elsif Ligne = To_Unbounded_String("cache") then
            New_Line;
            Put_Line("cache (ligne" & Integer'Image(Numero_Ligne) & ")");
            Afficher_CACHE(Table_Cache);
            
         elsif Ligne = To_Unbounded_String("stat") then
            New_Line;
            Put_Line("stat (ligne" & Integer'Image(Numero_Ligne) & ")");
            Afficher_Statistiques(Nb_Defauts_Cache, Nb_Demandes_Route);

         elsif Ligne = To_Unbounded_String("fin") then
            New_Line;
            Put_Line("fin (ligne" & Integer'Image(Numero_Ligne) & ")");
            exit;
            
         elsif Length(Ligne) > 0 then
             Paquet := Ligne;
             
             begin
                 IP_Paquet := Transf_Chaine_Adresse (Paquet);
                 
                 Nb_Demandes_Route := Nb_Demandes_Route + 1; 


                 Interface_Utilisee := Chercher_Interface_CACHE(Table_Cache, IP_Paquet);
                 
                 if Interface_Utilisee = Null_Unbounded_String then
      
                     Nb_Defauts_Cache := Nb_Defauts_Cache + 1; 
                     begin
                         Interface_Utilisee := Interface_f (Table_Routage, Paquet => IP_Paquet);
                         Mettre_A_Jour_CACHE(Table_Cache, Table_Routage, IP_Paquet, Interface_Utilisee);
                     exception
                        when others =>
                           Interface_Utilisee := To_Unbounded_String("Pas de route trouvee");
                     end;
                 end if;
                 
                 -- Affichage du résultat pour ce paquet
                 Ecrire_IP(Fichier_Resultat, IP_Paquet);
                 Put(Fichier_Resultat, " " & Interface_Utilisee);
                 New_Line(Fichier_Resultat);
                 
             exception
                 when others =>
                     null; -- Ignorer les lignes malformées ou vides
             end;
         end if;
      end loop;
   end Traiter_Paquets;

   Arg_Unb : Unbounded_String;

begin
   -- Valeurs par défaut
   Nom_Fichier_Table      := To_Unbounded_String("Exemples/tables.txt");
   Nom_Fichier_Paquet     := To_Unbounded_String("Exemples/paquets.txt");
   Nom_Fichier_Resultats  := To_Unbounded_String("Exemples/resultats.txt");
   Afficher_Stats_Argument := True; -- Par defaut a vrai

   if Argument_Count > 0 then
		begin
		-- On récupérer les arguments avec un boucle for
      -- si l'argument à la postion i vaut par exemple "-t", on sait que celui d'après ets le path du fichier table
      for I in 1 .. Argument_Count loop
         Arg_Unb := To_Unbounded_String(Argument (I));
         begin
            if To_String(Arg_Unb) = "-t" then
               Nom_Fichier_Table := To_Unbounded_String(Argument (I + 1));
            elsif To_String(Arg_Unb) = "-q" then
               Nom_Fichier_Paquet := To_Unbounded_String(Argument (I + 1));
            elsif To_String(Arg_Unb) = "-r" then
               Nom_Fichier_Resultats := To_Unbounded_String(Argument (I + 1));
            elsif To_String(Arg_Unb) = "-c" then
               Taille_Cache := Integer'Value(Argument (I + 1));
            elsif To_String(Arg_Unb) = "-p" then
                Politique_Cache := T_Politique'Value(Argument (I + 1));
            elsif To_String(Arg_Unb) = "-s" then
               Afficher_Stats_Argument := True;  
            elsif To_String(Arg_Unb) = "-S" then
               Afficher_Stats_Argument := False;
            end if;
         exception
            when Constraint_Error =>
               Afficher_Usage;
         end;
      end loop;

      end;
   end if;

   Initialiser_CACHE(Table_Cache, Liste_chainee, Taille_Cache, Politique_Cache);
   Ouvrir_Fichiers(Nom_Fichier_Table, Nom_Fichier_Paquet, Nom_Fichier_Resultats);

   Lire_Table_De_Routage(Table_File);
   Traiter_Paquets(Paquet_File, Resultat_File);
   
   if Afficher_Stats_Argument then
      Afficher_Statistiques(Nb_Defauts_Cache, Nb_Demandes_Route);
   end if;

   Close (Resultat_File);
   Close(Table_File);
   Close(Paquet_File);
	

   Detruire (Table_Routage);
end Routeur_Cache_Liste_Chaine;
