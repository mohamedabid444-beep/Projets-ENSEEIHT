with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Integer_Text_IO;    use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;

package body IP is

    package Adresse_IP_IO is new Modular_IO (T_Adresse_IP);
    use Adresse_IP_IO;
    
    package Octet_IO is new Modular_IO (T_Octet);
    use Octet_IO;

    -- Initialiser une adresse IP 
    function Initialiser_IP(P1 : in Integer ; P2 : in Integer ; P3 : in Integer ; P4 : in Integer) return T_Adresse_IP is
        IP : T_Adresse_IP;
    begin
        IP := T_Adresse_IP(P1);
        IP := IP * UN_OCTET + T_Adresse_IP(P2);
        IP := IP * UN_OCTET + T_Adresse_IP(P3);
        IP := IP * UN_OCTET + T_Adresse_IP(P4);
        return IP; 
    end Initialiser_IP;



   procedure Ecrire_IP (Fichier_Resultat : in File_Type; IP : in T_Adresse_IP) is
      begin
       Put (Fichier_Resultat, Natural ((IP / UN_OCTET ** 3) mod UN_OCTET), 1); Put (Fichier_Resultat, ".");
	    Put (Fichier_Resultat, Natural ((IP / UN_OCTET ** 2) mod UN_OCTET), 1); Put (Fichier_Resultat, ".");
	    Put (Fichier_Resultat, Natural ((IP / UN_OCTET ** 1) mod UN_OCTET), 1); Put (Fichier_Resultat, ".");
	    Put (Fichier_Resultat, Natural  (IP mod UN_OCTET), 1);
   end Ecrire_IP;

    function longueur_chaine_IP (IP : T_Adresse_IP) return Integer is 
        l, IP1, IP2, IP3, IP4: Integer;
    begin
        l:=0;
            
        IP1:=Natural ((IP / UN_OCTET ** 3) mod UN_OCTET);
        if (IP1/=0) then
            l:=l+1;
            while ((IP1/10)/=0) loop
                IP1:=IP1/10;
                l:=l+1;
            end loop;
        else 
            l := l+1;
        end if;
            
        IP2:=Natural ((IP / UN_OCTET ** 2) mod UN_OCTET);
        if (IP2/=0) then
            l:=l+1;
            while ((IP2/10)/=0) loop
                IP2:=IP2/10;
                l:=l+1;
            end loop;
        else 
            l := l+1;
        end if;
            
        IP3:=Natural ((IP / UN_OCTET ** 1) mod UN_OCTET);
        if (IP3/=0) then
            l:=l+1;
            while ((IP3/10)/=0) loop
                IP3:=IP3/10;
                l:=l+1;
            end loop;
        else 
            l := l+1;
        end if;
            
        IP4:=Natural (IP mod UN_OCTET);
        if (IP4/=0) then
            l:=l+1;
            while ((IP4/10)/=0) loop
                IP4:=IP4/10;
                l:=l+1;
            end loop;
        else 
            l := l+1;
        end if;
            
        return l+3;
    end longueur_chaine_IP;
    
    function longueur_adresse_IP (IP : T_Adresse_IP) return Integer is 
        l, IP1, IP2, IP3, IP4: Integer;
    begin
        l:=0;
            
        IP1:=Natural ((IP / UN_OCTET ** 3) mod UN_OCTET);
        if (IP1/=0) then
            l:=l+1;
            while ((IP1/10)/=0) loop
                IP1:=IP1/10;
                l:=l+1;
            end loop;
        end if;
            
        IP2:=Natural ((IP / UN_OCTET ** 2) mod UN_OCTET);
        if (IP2/=0) then
            l:=l+1;
            while ((IP2/10)/=0) loop
                IP2:=IP2/10;
                l:=l+1;
            end loop;
        end if;
            
        IP3:=Natural ((IP / UN_OCTET ** 1) mod UN_OCTET);
        if (IP3/=0) then
            l:=l+1;
            while ((IP3/10)/=0) loop
                IP3:=IP3/10;
                l:=l+1;
            end loop;
        end if;
            
        IP4:=Natural (IP mod UN_OCTET);
        if (IP4/=0) then
            l:=l+1;
            while ((IP4/10)/=0) loop
                IP4:=IP4/10;
                l:=l+1;
            end loop;
        end if;
            
        return l+3;
    end longueur_adresse_IP;


    function Transf_chaine_Adresse (Ad_ip : in Unbounded_String) return T_Adresse_IP is
        P1, P2, P3, P4, n, Id: Integer;
        P1_C, P2_C, P3_C, P4_C: Unbounded_String;
    begin
        Id:=1;
        n:=Length (Ad_ip);
        P1_C:=To_Unbounded_String("");
        P2_C:=To_Unbounded_String("");
        P3_C:=To_Unbounded_String("");
        P4_C:=To_Unbounded_String("");
        for i in 1..n loop
            
            if (To_String (Ad_ip) (i) = '.' ) then
                Id:=Id+1;
            else
                if (Id=1) then
                    Append (P1_C, To_String (Ad_ip) (i));
                elsif (Id=2) then
                    Append (P2_C, To_String (Ad_ip) (i));
                elsif (Id=3) then
                    Append (P3_C, To_String (Ad_ip) (i));      
                else 
                    Append (P4_C, To_String (Ad_ip) (i));
                end if;
            end if;
            
        end loop;
        
        -- Transformation des chaines en des entiers 
        P1:=Integer'Value(To_String (P1_C));
        P2:=Integer'Value(To_String (P2_C));
        P3:=Integer'Value(To_String (P3_C));
        P4:=Integer'Value(To_String (P4_C));
        
        return(Initialiser_IP(P1,P2,P3,P4));
        
    end Transf_chaine_Adresse;
    
    procedure Afficher_IP (IP : T_Adresse_IP) is
	begin
	    Put (Natural ((IP / UN_OCTET ** 3) mod UN_OCTET), 1); Put (".");
	    Put (Natural ((IP / UN_OCTET ** 2) mod UN_OCTET), 1); Put (".");
	    Put (Natural ((IP / UN_OCTET ** 1) mod UN_OCTET), 1); Put (".");
	    Put (Natural  (IP mod UN_OCTET), 1);
    end Afficher_IP;
    
    
    procedure Ajoute_bit_paquet_a_destination_masque(Paquet : in T_Adresse_IP; Dest_corresp : in out T_Adresse_IP; Ms_corresp : in out T_Adresse_IP) is

        POIDS_FORT : T_Adresse_IP  ;

    begin
        
        POIDS_FORT:= 2 ** 31;	 -- 10000000.00000000.00000000.00000000
        
        if (Ms_corresp/=Initialiser_IP(255,255,255,255)) then
        
            while ((Ms_corresp and POIDS_FORT) /=0 ) loop
	            POIDS_FORT:=POIDS_FORT/2;
	        end loop;
	        
	        -- A la sortie de la boucle on est sur que (Ms_corresp and POIDS_FORT) =0
            Ms_corresp:=Ms_corresp+POIDS_FORT;
            
            if ((Paquet and POIDS_FORT) /= (Dest_corresp and POIDS_FORT)) then
		        Dest_corresp:=Dest_corresp+POIDS_FORT;
		        
		       
		    end if;
		        
        end if;
    
	end Ajoute_bit_paquet_a_destination_masque;
		  
	        
end IP;
