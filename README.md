# dpmlineage
dpm lineage
Failles:
# trouvé par nom
des objets de config qui ont le même nom. Si l'un matche, l'autre matche
 - je ne vois pas comment cela peut être amélioré.
des objets avec un nom A qui fait partie d'un autre nom plus long AB. Si AB est référencé, A matche aussi
 - peut être amélioré avec de meilleurs regex
des objets de config qui ont un nom trop simple matchent trop. Les scripts vont matcher toutes les text keys "activity", les filtres des styles vont beaucoup matcher une dataset class qui s'appelle "project"
 - exclure certaine classes de la recherche va un peu améliorer les choses. une meilleure regex dédiée en fonction du type d'objet va améliorer les choses. La meilleure regex peut être dépendante de la classes dans laquele on cherche un nom. Ex une text key, dans un script #{...} ou "..."
des objets avec un nom qui matche dans un champ qui n'a pas sensé porter une référence
 - dresser une liste de champs qui faut exclure de la recherche. Le champ :NAME peut être exclu systématiquement (aussi :OBJECT-NUMBER)
 
Il serait peut-être facilitateur d'identifier les classes qui sont cherchable par nom

Il serait tres efficace de dresser un liste de classe qui peuvent être cherchée dans une autre classe. Exemple un attribute setting ne peut appeler que des attributs
(en fait là pour l'algo, c'est ne chercher dans les attributes settings que lors du scan de la classe USER ATTRIBUTE, ADDED ATTRIBUTE like. Et pour le coup ne chercher que le champ name de l'attribut dans le champ name du setting)
