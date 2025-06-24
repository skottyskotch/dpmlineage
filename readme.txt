 - install on a linux VM with node.js and python3
unzip everything somewhere or git init
chmod +x install.sh
chmod +x start.sh

 - windows
 unzip everything somewhere or git init
 install.bat
 start.bat
 Le install.bat vérifie que Python, git, Node.js & npm sont installés. Si un outil manque, il demande de l’installer (pas d’install automatique Windows car plus compliqué).
 
 - Manual installation
install python
pip install pandas
pip install inquirer
pip install rich
pip install regex
graph visualization feature:
install node.js
go in www
npm install

 - use:
download a dpm.gz
dpm_extract ...dpm.gz
	with -x (recommended): you will be prompted to exclude some tables, please do your selection. The selection is stored in a text file in the current directory for further attempt. (prompted to be applied at the next exclude step)
It will create the directory structure in ./output/DPM_OUT
dpm_dependancies.py .../DMP_OUT
	with -b: you will be prompted for a session browsing from object to callers
	without -b: it will generate a csv of links called/caller/attribute in output
	with "-m db" (recommended): it will generate a db with 3 tables edges, nodes, tabledef in output. use a db client like dbeaver and do your joins. (sqlite)
graph visualization: open a command line in www
node server.js
open your navigator to localhost:3000
api endpoint at localhost:3000/api/graph-data

# todo:
color arrows the same as the edge
on click a link on class graph: lists the objects in the right panel
on click a graph node: 
	expand will replace the node by a subgrpah of objects in the class
	run will draw the object graph from this class + link to other classes

# flaws:
javascript l2: 
 - fixer la conversion des blob base85 en text
 - dépendances fonctions de script - objets
trouvé par nom
des objets de config qui ont le même nom. Si l'un matche, l'autre matche
 - je ne vois pas comment cela peut être amélioré.
des objets avec un nom A qui fait partie d'un autre nom plus long AB. Si AB est référencé, A matche aussi
 - peut être amélioré avec de meilleurs regex
des objets de config qui ont un nom trop simple matchent trop. Les scripts vont matcher toutes les text keys "activity", les filtres des styles vont beaucoup matcher une dataset class qui s'appelle "project"
 - exclure certained classes de la recherche va un peu améliorer les choses. une meilleure regex dédiée en fonction du type d'objet va améliorer les choses. La meilleure regex peut être dépendante de la classes dans laquele on cherche un nom. Ex une text key, dans un script #{...} ou "..."
des objets avec un nom qui matche dans un champ qui n'a pas sensé porter une référence
 - dresser une liste de champs qui faut exclure de la recherche. Le champ :NAME peut être exclu systématiquement (aussi :OBJECT-NUMBER)
 
Il serait peut-être facilitateur d'identifier les classes qui sont cherchable par nom

Il serait tres efficace de dresser un liste de classe qui peuvent être cherchée dans une autre classe. Exemple un attribute setting ne peut appeler que des attributs
(en fait là pour l'algo, c'est ne chercher dans les attributes settings que lors du scan de la classe USER ATTRIBUTE, ADDED ATTRIBUTE like. Et pour le coup ne chercher que le champ name de l'attribut dans le champ name du setting)

Il faudrait arréter les dpm et faire ça directement en base

graph improvement:
 - nodes from same class are colored with a generated color, one color per class
 - double click selects all nodes from the same class
 - control click: multi selection
 - way to cluster the selection
 - allow the moving the cluster
 - try other layout
 - try a graph where nodes are tabldefinition, an edge is created if at least one edge between objects exists. The number of objects to objects edges is a label for this tabledef to tabledef edge