# 2024-covid-czech-data
Calculs sur les données covid tchèques, statut vaccinal vs mortalité TCC

Le Ministère de la santé de la République tchèque a publié des données covid de 2020 à 2024 qui comprennent notamment, des individus :

- la catégorie de l'année de naissance
- le sexe
- la semaine de vaccination (1e à 7e doses)
- la semaine de décès (toutes causes confondues)

Ce programme R :

- télécharge et vérifie l'intégrité des données (checksum),
- effectue des tests basiques sur le contenu de la base (contrôle d'incohérences),
- formate les données et exclut les données incohérentes.

Ce programme est divisé en trois scripts :

- `main.R`
- `variables.R`
- `functions.R`

Pour avoir un aperçu du programme, lire `main.R` et regarder les autres fichiers si besoin.

Le programme peut servir de template pour des calculs plus approfondis.

**Publiée sous licence GPL v3 ou supérieure.**

---

### Indicateurs

| Indicateur                                         | Valeur         |
|----------------------------------------------------|----------------|
|source des données|https://www.nzip.cz/data/2135-covid-19-prehled-populace|
|Taille du fichier CSV                              | 1,4 Go         |
| Nombre de lignes (avant exclusions)                | 12,6 millions  |
| Nombre de lignes (après exclusions des données invalides) | 11 millions    |
