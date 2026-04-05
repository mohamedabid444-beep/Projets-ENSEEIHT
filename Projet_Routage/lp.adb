with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body LP is

    procedure Free is
        new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_Pointeur_Cellule);

    procedure Initialiser_LP(Lp: out T_LP;Taille_MAX: Integer;Politique: T_Politique) is
    begin
        Lp.Tete := null;
        Lp.Taille_MAX := Taille_MAX; 
        Lp.Politique := Politique;
    end Initialiser_LP;

    function Est_Vide (Lp : T_LP) return Boolean is
    begin
        return Lp.Tete = null;
    end Est_Vide;

    procedure Detruire (Lp : in out T_LP) is
        P : T_Pointeur_Cellule;
    begin
        while Lp.Tete /= null loop
            P := Lp.Tete;
            Lp.Tete := Lp.Tete.all.Suivant;
            Free(P);
        end loop;
    end Detruire;

    function Taille (Lp : in T_LP) return Integer is
        Pt : T_Pointeur_Cellule;
        Cpt : Integer := 0;
    begin
        Pt := Lp.Tete;
        while Pt /= null loop
            Cpt := Cpt + 1;
            Pt := Pt.all.Suivant;
        end loop;
        return Cpt;
    end Taille;

    function Destination_Presente (Lp : in T_LP ; Destination : in T_Adresse_IP) return Boolean is
        P : T_Pointeur_Cellule := Lp.Tete;
    begin
        while P /= null loop
            if P.all.Destination = Destination then
                return True;
            end if;
            P := P.all.Suivant;
        end loop;
        return False;
    end Destination_Presente;

    procedure Supprimer (Lp : in out T_LP ; Destination : in T_Adresse_IP) is
        P, Prec : T_Pointeur_Cellule;
    begin
        P := Lp.Tete;
        Prec := null;
        while P /= null loop
            if P.all.Destination = Destination then
                if Prec = null then
                    Lp.Tete := P.all.Suivant;
                else
                    Prec.all.Suivant := P.all.Suivant;
                end if;
                Free(P);
                return;
            end if;
            Prec := P;
            P := P.all.Suivant;
        end loop;
    end Supprimer;

    procedure Enregistrer (Lp : in out T_LP ; Destination : in T_Adresse_IP; Supp: in out Boolean; Elem_Supp: in out T_Adresse_IP) is
        P, Prec : T_Pointeur_Cellule;
        Nouvelle : T_Pointeur_Cellule;
    begin
        if Destination_Presente(Lp, Destination) then
            if Lp.Politique = LRU then
                Supprimer(Lp, Destination); 
                Nouvelle := new T_Cellule'(Destination, Lp.Tete);
                Lp.Tete := Nouvelle;
            end if;
        else
            if Taille(Lp) >= Lp.Taille_MAX then
                -- Supprimer le dernier (le plus ancien en FIFO ou le moins utilisé en LRU)
                Supp:=True;
                P := Lp.Tete;
                Prec := null;
                if P /= null then
                    while P.all.Suivant /= null loop
                        Prec := P;
                        P := P.all.Suivant;
                    end loop;
                    if Prec = null then
                        Lp.Tete := null;
                        Elem_Supp:=P.all.Destination;
                    else
                        Elem_Supp:=P.all.Destination;
                        Prec.all.Suivant := null;
                    end if;
                    Free(P);
                end if;
            end if;
            
            Nouvelle := new T_Cellule'(Destination, Lp.Tete);
            Lp.Tete := Nouvelle;
        end if;
    end Enregistrer;

    procedure Afficher_LP (Lp : in T_LP) is
        P : T_Pointeur_Cellule := Lp.Tete;
    begin
        while P /= null loop
            Afficher_IP(P.all.Destination);
            New_Line;
            P := P.all.Suivant;
        end loop;
    end Afficher_LP;

end LP;
