# Documentation Technique : Simulateur de Routage Dynamique
**Groupe CD-01** | *Conçu par Ludwigs Cédric & Mohamed Abdi*

---

## 1. Description du Projet
Ce programme simule le fonctionnement d'un routeur réseau. Il lit une **table de routage** (qui associe des préfixes réseaux à des interfaces) et un fichier contenant des **adresses IP de destination** (ou paquets). Pour chaque paquet, le routeur détermine l'interface de sortie appropriée en cherchant la meilleure correspondance dans la table.

Pour accélérer ce processus, un **mécanisme de cache** est intégré. Ce cache mémorise les routes récemment utilisées.
Deux structures de données ont été expérimentées pour le cache :
1.  **Liste Chaînée (LC)** : Simple, mais la recherche est linéaire.
2.  **Arbre Binaire de Préfixe (Arbre)** : Optimisé pour une recherche rapide bit par bit.

---

## 2. Guide de Mise en Œuvre

### Prérequis
- Environnement Linux ou Unix.
- Compilateur GNAT pour Ada (commande `gnatmake`).

### Compilation
Trois exécutables peuvent être générés :

1.  **Routeur Simple (sans cache)** :
    ```bash
    gnatmake routeur_simple.adb
    ```
2.  **Routeur avec Cache Liste Chaînée** :
    ```bash
    gnatmake routeur_cache_liste_chaine.adb
    ```
3.  **Routeur avec Cache Arbre (Recommandé)** :
    ```bash
    gnatmake routeur_cache_liste_arbre.adb
    ```

---

## 3. Utilisation & Paramètres

Le programme s'exécute en ligne de commande. 
Syntaxe générale :
```bash
./routeur_type [paramètres]
```

### Options Disponibles
| Arguments | Description | Valeur par défaut |
| :--- | :--- | :--- |
| **`-c <taille>`** | Taille maximale du cache (nombre de routes mémorisées). | 10 |
| **`-p <politique>`** | Politique de remplacement du cache : `FIFO` ou `LRU`. | FIFO |
| **`-t <fichier>`** | Fichier contenant la table de routage complète. | `Exemples/tables.txt` |
| **`-q <fichier>`** | Fichier contenant les paquets (IPs) à traiter. | `Exemples/paquets.txt` |
| **`-r <fichier>`** | Fichier où seront écrits les résultats (IP + Interface). | `Exemples/resultats.txt` |
| **`-s`** | Force l'affichage des statistiques (taux de défauts) à la fin. | Activé par défaut |
| **`-S`** | **Désactive** l'affichage des statistiques. | N/A |

### Exemple de Commande
Pour utiliser le routeur "Arbre" avec un cache de taille 50, une politique LRU, et afficher les statistiques :
```bash
./routeur_cache_liste_arbre -c 50 -p LRU -s
```

---

## 4. Formats des Fichiers

### A. Table de Routage (`-t`)
Fichier texte décrivant le réseau. Chaque ligne doit respecter le format :
`Destination` `Masque` `Interface`

**Exemple (`tables.txt`)** :
```
147.127.0.0      255.255.0.0      eth1
147.127.18.0     255.255.255.0    eth0
0.0.0.0          0.0.0.0          eth3  (Route par défaut)
```

### B. Fichier de Paquets (`-q`)
Contient la liste des adresses IP destination pour lesquelles on cherche une route.
Il peut aussi contenir des **commandes spéciales** pour debugger ou analyser le routeur en cours d'exécution.

| Commande | Effet |
| :--- | :--- |
| `192.168.1.10` | IP standard : le routeur cherche l'interface et met à jour le cache (si besoin). |
| `table` | Affiche la table de routage complète dans la console. |
| `cache` | Affiche le contenu actuel du cache et l'ordre des éléments. |
| `stat` | Affiche les statistiques intermédiaires (Nb demandes, Nb défauts, %). |
| `fin` | Arrête la lecture du fichier de paquets immédiatement. |

**Exemple de fichier paquets :**
```
147.127.18.12
192.168.0.1
stat
10.0.0.1
table
fin
```

---

## 5. Politiques de Cache

La gestion du cache est cruciale lorsque celui-ci est plein (taille max atteinte). Il faut décider quelle ancienne route supprimer pour en insérer une nouvelle.

### FIFO (First In, First Out)
- **Principe** : "Premier arrivé, premier sorti".
- **Fonctionnement** : On supprime l'élément qui est dans le cache depuis le plus longtemps, peu importe s'il est souvent utilisé ou non.
- **Avantage** : Très simple et rapide à gérer.

### LRU (Least Recently Used)
- **Principe** : "Moins récemment utilisé".
- **Fonctionnement** : Lorsqu'une route est utilisée (succès cache), elle est considérée comme "récente" et replacée en tête de liste. Si le cache est plein, on supprime l'élément qui n'a pas été utilisé depuis le plus longtemps.
- **Avantage** : Garde en mémoire les routes populaires, souvent plus performant en pratique.

---

## 6. Analyse des Performances

Le programme calcule le **Taux de défaut de cache** pour évaluer l'efficacité de la configuration.
* **Défaut de cache** : Le routeur n'a pas trouvé l'IP dans le cache et a dû chercher dans la grande table de routage (lent).
* **Demande de route** : Le routeur a trouvé la réponse directement dans le cache (rapide).

**Formule :**
$$ \text{Taux défaut} = \frac{\text{Nombre de défauts}}{\text{Nombre total de demandes}} \times 100 $$

Un taux faible indique que le cache est efficace et bien dimensionné pour le trafic.

---

## 7. Automatisation des Tests

Un script `test_routeurs.sh` est fourni pour valider le bon fonctionnement de toutes les versions.
```bash
chmod +x test_routeurs.sh
./test_routeurs.sh
```
Ce script compile les fichiers si nécessaire et lance une batterie de tests sur les fichiers d'exemples fournis.