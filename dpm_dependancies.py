#!/usr/bin/env python
import os
import regex
import argparse
import sys
import signal
import pandas as pd # pip install pandas
import inquirer # pip install inquirer
from rich.progress import Progress, TaskID # pip install rich
from rich.console import Console
from rich.table import Table
from rich.live import Live
from concurrent.futures import ThreadPoolExecutor, as_completed
from collections import defaultdict

main_directory = 'DPM_OUT'
files_subdirectory = 'FILES'
data_subdirectory = 'DATA'
format_subdirectory = 'FORMAT'
header_subdirectory = 'HEADER'
objects_without_file_directory = '#OTHERS'

### utils
def signal_handler(sig, frame):
    print('Thanks')
    sys.exit(0)

def listChooser(sKey, sQuestion, lList):
    questions = [inquirer.List(
        sKey,
        message=sQuestion,
        choices=lList,
        carousel=True
    )]
    answers = inquirer.prompt(questions)  # returns a dict
    return answers

def checkboxChooser(sKey, sQuestion, lList):
    questions = [inquirer.Checkbox(
        sKey,
        message=sQuestion,
        choices=lList,
        carousel=True
    )]
    answers = inquirer.prompt(questions)  # returns a dict
    return answers

def clear():
    if os.name == 'nt': # for windows
        _ = os.system('cls')
    else: # for mac and linux(here, os.name is 'posix')
        _ = os.system('clear')

### classes
class ColumnsDef:
	def __init__(self, text):
		regexp = regex.compile(b':ATT ([^ ]*)')
		ATT = regexp.findall(text)[0]
		regexp = regex.compile(b':DATABASE-TYPE ([^ ]*)')
		DATABASE_TYPE = regexp.findall(text)[0]
		regexp = regex.compile(b':LENGTH ([^ ]*)')
		LENGTH = regexp.findall(text)[0]
		regexp = regex.compile(b':NULLABLE ([^ ]*)')
		NULLABLE = regexp.findall(text)[0]
		regexp = regex.compile(b':COMMENT ([^ ]*)')
		COMMENT = regexp.findall(text)[0]
		regexp = regex.compile(rb':ENCRYPTION ([^ ]*)')
		ENCRYPTION = regexp.findall(text)[0]
		
		self.ATT            = ATT
		self.DATABASE_TYPE  = DATABASE_TYPE
		self.LENGTH         = LENGTH
		self.NULLABLE       = NULLABLE
		self.COMMENT        = COMMENT
		self.ENCRYPTION     = ENCRYPTION

class PlwFormat:
	# Those 'format' objects instances will be in a dictionnary {FORMAT_NAME: object}
	instances = {}
	
	def __init__(self,text,path):
		pattern = regex.compile(rb'^(#%.*)')
		format_table_def = regex.match(pattern,text)[0]
		pattern = regex.compile(rb'^:NAME "(.*)"$',regex.MULTILINE)
		format_name = regex.findall(pattern,text)[0]
		pattern = regex.compile(rb'\((:ATT.*)\)',regex.MULTILINE)
		columns = []
		for columns_text in regex.findall(pattern, text):
			col = ColumnsDef(columns_text)
			columns.append(col)
		pattern = regex.compile(rb':TABLE-INDEX \((.*)\)')
		format_table_index = pattern.findall(text)[0]
		
		pattern = regex.compile(rb':OTHER-INDEXES (\(((?>[^()]+)|(?1))*\))')
		format_other_indexes_brut = pattern.findall(text)
		format_other_indexes = ['']
		if len(format_other_indexes_brut) > 0:
			pattern = regex.compile(rb'\((:.*?)\)',regex.DOTALL)
			format_other_indexes = pattern.findall(format_other_indexes_brut[0][0])
		# objects that comes from a format with an empty :index will be based on the first of the :other indexes
		format_keyID = format_table_index
		if format_keyID == '':
			format_keyID = format_other_indexes[0]
			# user-parameter have  :other-indexes ((:USER :KEY) (:USER))
			if format_table_def.decode('utf-8') == '#%DATABASE-IO:USER-PARAMETER:':
				format_keyID = format_keyID.split(b" ")[0]
		# les clés du hash des formats sont en string car on va les utiliser pour créer des classes avec l'instanciateur de classe python type() qui veut un string en argument
		PlwFormat.instances[format_table_def.decode('utf-8')] = self
		format_dirname = regex.sub(rb'[:\?\*<>\|]',b'_',format_table_def)
		searchedByONB = False
		onb = 0
		if b':OBJECT-NUMBER' in [col.ATT for col in columns]:
			searchedByONB = True
		searchedByNAME = False
		if b':NAME' in [col.ATT for col in columns]:
			searchedByNAME = True
		self.table_def 		= format_table_def
		self.name 			= format_name
		self.columns 		= columns
		self.nb_columns 	= len(self.columns)
		self.table_index 	= format_table_index
		self.other_indexes 	= format_other_indexes
		self.dirname 		= format_dirname.decode('utf-8')
		self.path 			= path
		self.objectPath		= ''
		self.nb_objects		= 0
		self.keyID 			= format_keyID
		self.txt 			= text
		self.searchedByONB	= searchedByONB
		self.searchedByNAME	= searchedByNAME
		self.objects 		= []

class PlwObject:
	instances = {}
	def __init__(self, path):
		text = ''
		with open(path, 'rb') as fin:
			text = fin.read()
		pattern = regex.compile(rb'^(#.*)$',regex.MULTILINE)
		self.path = path
		self.format = PlwFormat.instances[pattern.findall(text)[0].decode('utf-8')]
		self.format.objects.append(self)
		self.callers = []
		self.values = []
		self.id = b'NIL'
		self.name = b''
		self.onb = b''
		tableDefColumns = self.format.columns
		for line in regex.split(b'\n',text)[1:]:
			self.values.append(regex.split(b'\t',line)[1])
		if self.format.keyID != b'NIL' and self.format.keyID != b':BLOB':
			self.id = self.values[[x.ATT for x in tableDefColumns].index(self.format.keyID)]
		elif self.format.keyID == b':BLOB':
			self.id = self.values[[x.ATT for x in tableDefColumns].index(self.format.keyID)] + b'_' + self.values[[x.ATT for x in tableDefColumns].index(b':OFFSET')]
		else:
			obj_identifiers = []
			for eachKey in self.format.other_indexes:
				obj_identifiers.append(self.values[[x.ATT for x in tableDefColumns].index(eachKey)])
			self.id = b"_".join(obj_identifiers)
		if self.format.searchedByNAME:
			self.name = self.values[[col.ATT for col in self.format.columns].index(b':NAME')]
		if self.format.searchedByONB:
			self.onb = self.values[[col.ATT for col in self.format.columns].index(b':OBJECT-NUMBER')]
        # Flatten the attributes to improve the search latter
		self.attributes = {col: val for col, val in zip([c.ATT for c in self.format.columns], self.values)}
		self.valuesConcat = b'|'.join(self.values)
		PlwObject.instances[self.id] = self

	def show(self):
		nMaxAttributeNameLength = max([len(x.ATT) for x in self.format.columns])
		print('****** type: '			+ self.format.table_def.decode('utf-8'))
		print('key: '					+ self.format.keyID.decode('utf-8'))
		print('path: '					+ self.path)
		print('id: '					+ self.id.decode('utf-8'))
		print('attributes/values: ')
		for col in self.format.columns:
			print(col.ATT.ljust(nMaxAttributeNameLength+1) + self.values[self.format.columns.index(col)])

class ObjDependancy:
	instances = []
	def __init__(self, obj1, obj2, col, calledByOnb):
		# obj1 is called by obj2
		self.left = obj1
		self.right = obj2
		self.column = col
		self.calledByOnb = calledByOnb # False = left by the name
		ObjDependancy.instances.append(self)

	def show(self):
		# print(self.left.path)
		print(self.right.path)
		if self.calledByOnb:
			print('\tONB referenced in ' + self.column.decode('utf-8'))
		else:
			print('\tNAME referenced in ' +  self.column.decode('utf-8'))

	@classmethod
	def showAll(cls):
		print(str(len(cls.instances)) + ' dependancies found')
		print('\t'.join(['id_left','onb_left','name_left', 'type_left', 'id_right','onb_right','name_right', 'type_righ', 'column_right','byName','byOnb']))
		msg = []
		for dep in cls.instances:
			line = []
			line.append(dep.left.id.decode('utf-8'))
			line.append(dep.left.onb.decode('utf-8'))
			line.append(dep.left.name.decode('utf-8'))
			line.append(dep.left.format.table_def.decode('utf-8'))
			line.append(dep.right.id.decode('utf-8'))
			line.append(dep.right.onb.decode('utf-8'))
			line.append(dep.right.name.decode('utf-8'))
			line.append(dep.right.format.table_def.decode('utf-8'))
			line.append(dep.column.decode('utf-8'))
			line.append(str(not(dep.calledByOnb)))
			line.append(str(dep.calledByOnb))
			sline = '\t'.join(line)
			msg.append(sline)
		print('\n'.join(msg))
		
	@classmethod
	def findDeps(obj1, obj2):
		deps = []
		for dep in cls.instances:
			if dep.left == obj1 and dep.right == obj2:
				deps.append(dep)
		return deps

def processFormats(formatPath):
	pathList = []
	for fileFormat in os.listdir(formatPath):
		if regex.match('^#%',fileFormat):
			pathList.append(os.path.join(formatPath,fileFormat))
	with Progress() as progress:
		main_task = progress.add_task("[cyan]Processing table definitions...", total = len(pathList))
		for file in pathList:
			progress.advance(main_task, 1)
			with open (file, 'rb') as fin:
				text = fin.read()
				PlwFormat(text,file)

def mapDirectories(filesPath, otherPath):
	tableDefList = [x for x in PlwFormat.instances.keys()]
	tableDefObjectsDirs = []
	if os.path.isdir(filesPath):
		for root, dirs, files in os.walk(filesPath):
			for tableDefObjectDir in dirs:
				for tableDefName in tableDefList:
					if tableDefObjectDir == regex.sub(r'[:\?\*<>\|]','_', tableDefName):
						PlwFormat.instances[tableDefName].objectPath = os.path.join(root,tableDefObjectDir)
						PlwFormat.instances[tableDefName].nb_objects += len(os.listdir(os.path.join(root,tableDefObjectDir)))
	if os.path.isdir(otherPath):
		for root, dirs, files in os.walk(otherPath):
			for tableDefObjectDir in dirs:
				for tableDefName in tableDefList:
					if tableDefObjectDir == regex.sub(r'[:\?\*<>\|]','_', tableDefName):
						tableDefObjectsDirs.append(os.path.join(root,tableDefObjectDir))
						PlwFormat.instances[tableDefName].objectPath = os.path.join(root,tableDefObjectDir)
						PlwFormat.instances[tableDefName].nb_objects += len(os.listdir(os.path.join(root,tableDefObjectDir)))

def processExclusions():
	classList = sorted(PlwFormat.instances.values(), key=lambda o: o.nb_objects, reverse=True)
	dictTableDef = checkboxChooser('Class','Select classes to exclude',[(str(x.nb_objects).ljust(8) + x.name.decode('utf-8'),x) for x in classList])
	for plwFormat in dictTableDef['Class']:
		del PlwFormat.instances[plwFormat.table_def.decode('utf-8')]

def processObjectsWithFiles(filesPath):
	pathList = []
	if os.path.isdir(filesPath):
		for dirFile in os.listdir(filesPath):
			if dirFile != objects_without_file_directory:
				for dirType in os.listdir(os.path.join(filesPath,dirFile)):
					if dirType in [regex.sub(r'[:\?\*<>\|]','_', x) for x in PlwFormat.instances.keys()]:
						for fileObject in os.listdir(os.path.join(dirType,filesPath,dirFile,dirType)):
							pathList.append(os.path.join(dirType,filesPath,dirFile,dirType,fileObject))
		with Progress() as progress:
			main_task = progress.add_task("[cyan]Processing objects with dataset...", total = len(pathList))
			for file in pathList:
				progress.advance(main_task, 1)
				PlwObject(file)

def processObjectsWithoutFiles(otherPath):
	pathList = []
	if os.path.isdir(otherPath):
		for dirOtherType in os.listdir(otherPath):
			if dirOtherType in [regex.sub(r'[:\?\*<>\|]','_', x) for x in PlwFormat.instances.keys()]:
				for fileObject in os.listdir(os.path.join(otherPath,dirOtherType)):
					pathList.append(os.path.join(otherPath,dirOtherType,fileObject))
		with Progress() as progress:
			main_task = progress.add_task("[cyan]Processing objects without dataset...", total = len(pathList))
			for file in pathList:
				progress.advance(main_task, 1)
				PlwObject(file)

def browseObject():
	displayedListHistory = []
	historyCalled = []
	down = True
	searchable = True
	while(True):
		if len(displayedListHistory) == 0:
			# choice of the class
			dictTableDef = listChooser('Class','Browse a table definition',[(str(len(x.objects)).ljust(8) + 'NAME:' + str(x.searchedByNAME).ljust(8) + ' ONB:' + str(x.searchedByONB).ljust(8) + x.name.decode('utf-8').ljust(20) ,x) for x in PlwFormat.instances.values()])
			objectsList = sorted(dictTableDef['Class'].objects, key=lambda o: o.id)
			prompt = 'instances of ' + dictTableDef['Class'].table_def.decode('utf-8')
			displayedListHistory.append((objectsList, prompt))
		# choice of the object
		if down:
			dictObject = listChooser('Object', displayedListHistory[-1][1] , [(x.id.decode('utf-8').ljust(20) + x.format.table_def.decode('utf-8'), x) for x in displayedListHistory[-1][0]])
			historyCalled.append(dictObject['Object'])
		# show
		clear()
		historyCalled[-1].show()
		print('\n')
		if searchable == False:
			print('No callers found for ' + historyCalled[-1].id.decode('utf-8'))
		# possible actions list
		choices = []
		if len(displayedListHistory) > 1:
			choices.append(('Back to called ' + historyCalled[-1].format.table_def.decode('utf-8') + ' ' + historyCalled[-1].id.decode('utf-8'), 1))
			
		if searchable:
			choices.append(('Search callers', 2))
		choices.append(('Browse another object', 3))
		choices.append(('Exit', 4))
		selection = listChooser('Action','Next action',choices)
		# choose the next action
		searchable = True
		if selection['Action'] == 1: # back to called
			down = False
			displayedListHistory.pop()
			historyCalled.pop()
		elif selection['Action'] == 2: # callers
			down = True
			deps = searchDependanciesForOne(historyCalled[-1])
			callers = [dep.right for dep in deps]
			displayedListHistory.append((callers, 'Callers of ' + historyCalled[-1].id.decode('utf-8')))
			if deps == []:
				displayedListHistory.pop()
				down = False
				searchable = False
		elif selection['Action'] == 3:
			down = True
			displayedListHistory = []
			clear()
		elif selection['Action'] == 4:
			clear()
			ObjDependancy.showAll()
			sys.exit(0)

######### search
def searchDependanciesForOne(obj):
	deps = []
	with Progress() as progress:
		main_task = progress.add_task("[cyan]Object " + obj.id.decode('utf-8') + " ...", total = len(PlwFormat.instances))
		sub_task = progress.add_task("[green]Class ...", total = 0)
		for plwFormat in PlwFormat.instances.values():
			progress.update(sub_task, total=len(PlwFormat.instances.values()), completed=0)
			for otherObj in plwFormat.objects:
				if otherObj != obj:
					for index, string in enumerate(otherObj.values):
						if obj.format.searchedByONB:
							if obj.onb in string:
								deps.append(ObjDependancy(obj, otherObj, index, True))
						if obj.format.searchedByNAME:
							if obj.name in string:
								deps.append(ObjDependancy(obj, otherObj, index, False))
				progress.update(sub_task, description = "[green]Class " + plwFormat.table_def.decode('utf-8') + "...", advance=1)
			progress.advance(main_task, 1)
	for dep in deps:
		dep.show()
	return deps

def indexDependancies(globalIndex):
	nMaxClassNameLength = max([len(x) for x in PlwFormat.instances.keys()])
	with Progress() as progress:
		i = 0
		main_task = progress.add_task("[cyan]Objects searched...", total = len(PlwObject.instances))
		for plwFormat in PlwFormat.instances.values():
			for obj in plwFormat.objects:
				i+=1
				for otherPlwFormat in PlwFormat.instances.values():
					# too much false positive with ATV. they all have the same name
					if plwFormat.table_def == b'#%TEMP-TABLE:_ATV_PT_ATT_VAL:' and otherPlwFormat.table_def == b'#%TEMP-TABLE:_ATV_PT_ATT_VAL:':
						continue
					for otherObj in otherPlwFormat.objects:
						if otherObj != obj:
							if obj.format.searchedByONB and obj.onb in otherObj.valuesConcat:
								globalIndex[obj.id].append(otherObj)
							if obj.format.searchedByNAME and obj.name in otherObj.valuesConcat:
								globalIndex[obj.id].append(otherObj)
				progress.update(main_task, description = "[cyan]Object indexation " + str(i) + "/" + str(len(PlwObject.instances)) + ". Found " + str(len(globalIndex.keys())) + "...", advance = 1)

def processDepLinks(globalIndex):
	with Progress() as progress:
		main_task = progress.add_task("[cyan]Processing dependancy...", total = len(ObjDependancy.instances))
		for objectId, callers in globalIndex.items():
			obj = PlwObject.instances[objectId]
			if obj.format.searchedByONB:
				for caller in callers:
					for attribute, value in caller.attributes.items():
						if obj.onb in value:
							ObjDependancy(obj, caller, attribute, True)
			if obj.format.searchedByNAME:
				for caller in callers:
					for attribute, value in caller.attributes.items():
						if obj.name in value:
							ObjDependancy(obj, caller, attribute, False)
			progress.advance(main_task, 1)

def dumpLinks(outputPath):
	id_left = []
	onb_left = []
	name_left = []
	type_left = []
	id_right = []
	onb_right = []
	name_right = []
	type_right = []
	column_right = []
	byName = []
	byOnb = []
	
	with Progress() as progress:
		main_task = progress.add_task("[cyan]Preparing csv...", total = len(ObjDependancy.instances))
		for dep in ObjDependancy.instances:
			id_left.append(dep.left.id.decode('utf-8'))
			onb_left.append(dep.left.onb.decode('utf-8'))
			name_left.append(dep.left.name.decode('utf-8'))
			type_left.append(dep.left.format.table_def.decode('utf-8'))
			id_right.append(dep.right.id.decode('utf-8'))
			onb_right.append(dep.right.onb.decode('utf-8'))
			name_right.append(dep.right.name.decode('utf-8'))
			type_right.append(dep.right.format.table_def.decode('utf-8'))
			column_right.append(dep.column.decode('utf-8'))
			byName.append(str(not(dep.calledByOnb)))
			byOnb.append(str(dep.calledByOnb))
			progress.advance(main_task, 1)

	data = {'id_left' : id_left, 'onb_left': onb_left, 'name_left' : name_left,'type_left' : type_left,'id_right' : id_right,'onb_right' : onb_right,'name_right' : name_right,'type_right' : type_right,'column_right' : column_right,'byName' : byName,'byOnb' : byOnb}
	df = pd.DataFrame(data)
	df.to_csv(os.path.join(outputPath, main_directory + '_callers.csv'), sep = ';')
	print('\n' + os.path.join(outputPath, main_directory + '_callers.csv') + ' exported')
	
def main():
	signal.signal(signal.SIGINT, signal_handler)
	parser = argparse.ArgumentParser()
	parser.add_argument("directory", help="path/to/.../DPM_OUT (created with dpm_extract.py)")
	parser.add_argument("-b", "--browse", action='store_true', help="Prompted for object visualisation")
	parser.add_argument("-x", "--exclude", action='store_true', help="Prompted for selection of classes to exclude")
	args = parser.parse_args()

	inputPath = args.directory
	formatPath = ''
	filesPath = ''
	global main_directory
	if os.path.isdir(inputPath) and main_directory not in os.path.basename(inputPath):
		print(args.directory + ' is not a base directory of an extracted dpm (.../' + main_directory + ')')
		return
	main_directory = os.path.basename(inputPath)
	formatPath = ''
	filesPath = ''
	otherPath = ''
	for root, dirs, files in os.walk(inputPath):
		if format_subdirectory in dirs and files_subdirectory in dirs:
			formatPath = os.path.join(inputPath,format_subdirectory)
			filesPath = os.path.join(inputPath,files_subdirectory)
			otherPath = os.path.join(inputPath,files_subdirectory,objects_without_file_directory)
			break
	processFormats(formatPath)
	if args.exclude:
		mapDirectories(filesPath, otherPath)
		processExclusions()
	processObjectsWithFiles(filesPath)
	processObjectsWithoutFiles(otherPath)
	if args.browse:
		browseObject()
	globalIndex = defaultdict(list)
	indexDependancies(globalIndex)
	# indexDependancies_()
	# parallelIndexation()
	processDepLinks(globalIndex)
	outputPath = os.path.join(os.path.dirname(os.path.realpath(__file__)),'output')
	if os.path.isdir(outputPath):
		dumpLinks(outputPath)
	else:
		print(outputPath + ' not found')

if __name__ == '__main__':
    main()
	
# lab
def indexDependancies_():
	with Progress() as progress:
		main_task = progress.add_task("[red]Objects indexation...", total = len(PlwObject.instances))
		with ThreadPoolExecutor() as executor:
			futures = [executor.submit(indexer_, obj) for obj in PlwObject.instances.values()]
			# with Live(creer_table(executor), refresh_per_second=1) as live:
			for future in as_completed(futures):
				# live.update(creer_table(executor))
				progress.update(main_task, description = "[cyan]Object indexation found " + str(len(globalIndex.keys())) + "...", advance = 100)

def indexer_(obj):
	i = 0
	for plwFormat in PlwFormat.instances:
		for otherObj in PlwObject.instances:
			i+=1
			if otherObj != obj:
				# pass
				if obj.format.searchedByONB and obj.onb in otherObj.valuesConcat:
					globalIndex[obj.id].append(otherObj)
				if obj.format.searchedByNAME and obj.name in otherObj.valuesConcat:
					globalIndex[obj.id].append(otherObj)
	return i

def creer_table(executor):
    table = Table(title="Progression des Tâches")
    table.add_column("ID Tâche", justify="center", style="cyan")
    table.add_column("État", justify="center", style="magenta")
    table.add_column("Résultat", justify="center", style="green")
    # Ajouter les tâches à la table
    for i, future in enumerate(futures):
        etat = "En attente" if not future.running() else "En cours"
        resultat = "" if not future.done() else str(future.result())
        table.add_row(str(i), etat, resultat)
    return table