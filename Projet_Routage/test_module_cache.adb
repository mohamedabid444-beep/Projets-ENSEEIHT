with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with IP;                    use IP;
with TR;                    use TR;
with LP;                    use LP;
with Cache;                 use Cache;

procedure Test_Module_Cache is
    Ma_Table    : T_TR;
    Mon_Cache   : T_Cache;
    Paquet      : T_Adresse_IP;
    Inter_Trouvee : Unbounded_String;
    
    -- Données de test
    IP_Test     : T_Adresse_IP;
    M_Test      : T_Adresse_IP;
begin
    Put_Line("=== Test du Module Cache ===");

    -- 1. Initialisation de la Table de Routage 
    Initialiser(Ma_Table);
    Enregistrer(Ma_Table, Initialiser_IP(147, 127, 127, 0), Initialiser_IP(255, 255, 255, 0), To_Unbounded_String("eth0"));
    Enregistrer(Ma_Table, Initialiser_IP(192, 0, 0, 0), Initialiser_IP(255, 0, 0, 0), To_Unbounded_String("eth1"));
    Enregistrer(Ma_Table, Initialiser_IP(147, 127, 0, 0), Initialiser_IP(255, 255, 0, 0), To_Unbounded_String("eth2"));
    Enregistrer(Ma_Table, Initialiser_IP(0, 0, 0, 0), Initialiser_IP(0, 0, 0, 0), To_Unbounded_String("eth_defaut"));

    -- 2. Initialisation du Cache 
    Initialiser_CACHE(Mon_Cache,Liste_chainee, 2, LP.FIFO);
    Put_Line("Cache initialisé (Taille max : 2, Politique : FIFO)");

    
    Paquet := Initialiser_IP(147, 5, 5, 5);
    Put_Line("Réception paquet : 147.5.5.5");
    
    -- On vérifie d'abord si c'est dans le cache (doit être vide)
    Inter_Trouvee := Chercher_Interface_CACHE(Mon_Cache, Paquet);
    if To_String(Inter_Trouvee) = "" then
        Put_Line("Miss ! Mise à jour du cache...");
        
        Mettre_A_Jour_CACHE(Mon_Cache, Ma_Table, Paquet, To_Unbounded_String("eth_defaut"));
    end if;
    
    put_Line("Affichage 1 du cache");
    Afficher_CACHE (Mon_Cache);
    
    -- 4. Vérification du Hit
    Inter_Trouvee := Chercher_Interface_CACHE(Mon_Cache, Paquet);
    Put("Interface dans le cache : ");
    Put_Line(To_String(Inter_Trouvee));

    -- 5. Test de saturation du cache 
    Put_Line("Ajout de 2 autres routes pour tester l'éviction...");
    Mettre_A_Jour_CACHE(Mon_Cache, Ma_Table, Initialiser_IP(192, 168, 1, 1), To_Unbounded_String("eth1"));
    
    put_Line("Affichage 2 du cache");
    Afficher_CACHE (Mon_Cache);
    
    Mettre_A_Jour_CACHE(Mon_Cache, Ma_Table, Initialiser_IP(147, 10, 0, 1), To_Unbounded_String("eth2"));
    
    put_Line("Affichage 3 du cache");
    Afficher_CACHE (Mon_Cache);

    -- Le premier paquet (147.127.10.1) a normalement été supprimé (FIFO, taille 2)
    Inter_Trouvee := Chercher_Interface_CACHE(Mon_Cache, Paquet);
    if To_String(Inter_Trouvee) = "" then
        Put_Line("Test Eviction : OK (le premier paquet a été supprimé)");
    else
        Put_Line("Test Eviction : Erreur (le paquet est toujours là)");
    end if;
    
    Detruire_CACHE(Mon_Cache);

    Put_Line("=== Fin des tests ===");
end Test_Module_Cache;
