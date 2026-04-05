#!/bin/bash

echo "========================================================="
echo "       TEST DES ROUTEURS"
echo "========================================================="

TABLE="Exemples/tables.txt"
PAQUETS="Exemples/paquets.txt"
OUT_DIR="Resultats_Tests"
mkdir -p $OUT_DIR

ROUTEURS=("routeur_simple" "routeur_cache_liste_chaine" "routeur_cache_liste_arbre")

for routeur in "${ROUTEURS[@]}"; do
    if [ ! -f "./$routeur" ]; then
        echo "Compilation de $routeur..."
        gnatmake $routeur.adb
    fi
done

echo ""

tester_routeur() {
    local nom_exe=$1
    local suffixe=$(echo "$2" | tr -d ' -')
    local fichier_res="$OUT_DIR/res_${nom_exe}_${suffixe}.txt" 
    local options=$2

    echo "---------------------------------------------------------"
    echo "Test de $nom_exe $options"

    if [ -f "./$nom_exe" ]; then
        ./$nom_exe -t "$TABLE" -q "$PAQUETS" -r "$fichier_res" $options > "$OUT_DIR/log_${nom_exe}_${suffixe}.txt"
        
        if [ $? -eq 0 ]; then
            echo "OK."
            if [ -s "$OUT_DIR/log_${nom_exe}_${suffixe}.txt" ]; then
                echo "Sortie :"
                grep -E "Défaut|Demande|Taux" "$OUT_DIR/log_${nom_exe}_${suffixe}.txt" || cat "$OUT_DIR/log_${nom_exe}_${suffixe}.txt"
            fi
        else
            echo "ERREUR"
        fi
    else
        echo "Exécutable introuvable."
    fi
}

tester_routeur "routeur_simple" ""

tester_routeur "routeur_cache_liste_chaine" "-s" 
tester_routeur "routeur_cache_liste_chaine" "-c 10 -p FIFO -s"
tester_routeur "routeur_cache_liste_chaine" "-c 10 -p LRU -s"
tester_routeur "routeur_cache_liste_chaine" "-c 10 -p LFU -s"

tester_routeur "routeur_cache_liste_arbre" "-s"
tester_routeur "routeur_cache_liste_arbre" "-c 100 -p FIFO -s"
tester_routeur "routeur_cache_liste_arbre" "-c 100 -p LRU -s"
tester_routeur "routeur_cache_liste_arbre" "-c 100 -p LFU -s"
tester_routeur "routeur_cache_liste_arbre" "-c 5 -p LRU -s"

echo "========================================================="
echo "Fin des tests."
