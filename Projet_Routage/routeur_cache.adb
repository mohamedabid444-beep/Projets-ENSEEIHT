with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Command_Line;     use Ada.Command_Line;
with Ada.Strings;               use Ada.Strings;	
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with TR;        use TR;
with IP;        use IP;
with cache;


procedure RouteurSimple is
   Nom_Fichier_Table : Unbounded_String;
   Nom_Fichier_Paquet : Unbounded_String;
   Nom_Fichier_Resultats : Unbounded_String;

   Table_File : File_Type;
   Paquet_File : File_Type;
   Resultat_File : File_Type;
	

   Table_Routage : T_TR;
   Table_Cache : T_Cache;

   

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
   Numero_Ligne : Integer := 0;
   Ligne : Unbounded_String;
   Destination : Unbounded_String;
   Masque : Unbounded_String;
   Interfac : Unbounded_String;
   begin
      loop
         exit when End_Of_File (Fichier);
         if Numero_Ligne = 0 then
            Get_Line (Fichier, Ligne);
            Numero_Ligne := Numero_Ligne + 1;
         else 
            Numero_Ligne := Numero_Ligne + 1;
            Get_Line (Fichier, Ligne);
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
   begin
      loop
         exit when End_Of_File (Fichier_Paquet);
         Get_Line (Fichier_Paquet, Ligne);
         Paquet := Ligne;
         begin
            Interface_Utilisee := Interface_f (Table_Routage, Paquet => Transf_Chaine_Adresse (Paquet));
         exception
            when others =>
               Interface_Utilisee := To_Unbounded_String("Pas de route trouvee");
         end;
         Afficher_Table(Table_Routage, Fichier_Resultat);
      end loop;
   end Traiter_Paquets;

   Arg_Unb : Unbounded_String;

begin
   if Argument_Count < 3 then
		Afficher_Usage;
	else
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
               Table_Cache.Taille_Max := Integer'Value(Argument (I + 1));
            elsif To_String(Arg_Unb) = "-p" then
                Table_Cache.Politique := T_Politique'Value(Argument (I + 1));
            elsif To_String(Arg_Unb) = "-s" then
               Table_Cache.Afficher_Statistique := True;  
            end if;
         exception
            when Constraint_Error =>
               Afficher_Usage;
         end;
      end loop;

      end;
   end if;

   Cache.Initialiser(Table_Cache, Table_Cache.Taille_Max, Table_Cache.Politique, Table_Cache.Afficher_Statistique);
   Ouvrir_Fichiers(Nom_Fichier_Table, Nom_Fichier_Paquet, Nom_Fichier_Resultats);

   Lire_Table_De_Routage(Table_File);
   Traiter_Paquets(Paquet_File, Resultat_File);


   Close (Resultat_File);
   Close(Table_File);
   Close(Paquet_File);
	

   Detruire (Table_Routage);
end RouteurSimple;