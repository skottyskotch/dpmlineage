#!/usr/bin/env python
import os
import regex # pip install regex
import argparse
import sys
import signal
import pandas as pd # pip install pandas
import inquirer # pip install inquirer
from rich.progress import Progress, TaskID # pip install rich
from concurrent.futures import ThreadPoolExecutor, as_completed
from collections import defaultdict
import sqlite3
import csv

main_directory = 'DPM_OUT'
files_subdirectory = 'FILES'
data_subdirectory = 'DATA'
format_subdirectory = 'FORMAT'
header_subdirectory = 'HEADER'
js_subdirectory		= 'JS_L2'
objects_without_file_directory = '#OTHERS'

### utils
def signal_handler(sig, frame):
    print('Thanks')
    sys.exit(0)

def checkArgPath(p):
    if not os.path.exists(p):
        raise argparse.ArgumentTypeError(f"The directory '{p}' does not exist.")
    return p

def listChooser(sKey, sQuestion, lList):
    questions = [inquirer.List(
        sKey,
        message = sQuestion,
        choices = lList,
        carousel = True
    )]
    answers = inquirer.prompt(questions)  # returns a dict
    return answers

def checkboxChooser(sKey, sQuestion, lChoices, lDefault):
    questions = [inquirer.Checkbox(
        sKey,
        message = sQuestion,
        choices = lChoices,
		default = lDefault,
        carousel = True
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
		self.text = text
		self.format = PlwFormat.instances[pattern.findall(text)[0].decode('utf-8')]
		self.format.objects.append(self)
		self.callers = []
		self.values = []
		self.id = b'NIL'
		self.js2 = b''
		self.functions = []
		self.methods = []
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
		self.attributes = {col: val for col, val in zip([c.ATT for c in self.format.columns], self.values)}
		# remove the Name or ONB because those fields aren't intended to reference other objects for sure. For search 'by browsing'
		attributesForSearch = self.attributes.copy()
		attributesForSearch.pop(b':NAME', None)
		attributesForSearch.pop(b':OBJECT-NUMBER', None)
		self.attributesForSearch = attributesForSearch
        # Flatten the attributes to improve the search latter. For 'global search'
		self.valuesConcat = bytes([23]).join(self.attributesForSearch.values())
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
	def __init__(self, obj1, obj2, col, calledByOnb, functionName):
		# obj1 is called by obj2
		self.left = obj1
		self.right = obj2
		self.column = col
		self.calledByOnb = calledByOnb # False = left by the name
		self.functionName = functionName # called by a function or method (function / method name)
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
		print('\t'.join(['id_left','onb_left','name_left', 'type_left', 'id_right','onb_right','name_right', 'type_right', 'column_right','byName','byOnb']))
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
	print(formatPath)
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
						PlwFormat.instances[tableDefName].objectPath = os.path.join(root,tableDefObjectDir)
						PlwFormat.instances[tableDefName].nb_objects += len(os.listdir(os.path.join(root,tableDefObjectDir)))

def processExclusions(outputPath, main_directory):
	exclusionFilePath = os.path.join(outputPath, main_directory + '_dpmdeps_exclusions.txt')
	bLoadExclusions = False
	classList = sorted(PlwFormat.instances.values(), key=lambda o: o.nb_objects, reverse=True)
	choices = [(str(x.nb_objects).ljust(8) + x.name.decode('utf-8'),x) for x in classList]
	default = []
	if os.path.isfile(exclusionFilePath):
		selection = listChooser('Exclusion','An exclusion file has been found. Load it?',['yes','no'])		
		if selection['Exclusion'] == 'yes':
			lines = []
			with open(exclusionFilePath, 'r') as fexcl:
				lines = [line.strip() for line in fexcl]
			default = [PlwFormat.instances[line] for line in lines if line in PlwFormat.instances.keys() ]
			rejected = [line for line in lines if line not in PlwFormat.instances.keys()]
			if len(rejected) > 0:
				print('Table definitions rejected (not found in the dpm): ' + ','.join(rejected))
	dictTableDef = checkboxChooser('Class','Select classes to exclude', choices, default)
	for plwFormat in dictTableDef['Class']:
		del PlwFormat.instances[plwFormat.table_def.decode('utf-8')]
	with open(exclusionFilePath, 'w') as fout:
		fout.write('\n'.join([plwFormat.table_def.decode('utf-8') for plwFormat in dictTableDef['Class']]))

def processObjects(filesPath, otherPath):
	processObjectsWithFiles(filesPath)
	processObjectsWithoutFiles(otherPath)

def processObjectsWithFiles(filesPath):
	pathList = []
	if os.path.isdir(filesPath):
		for dirFile in os.listdir(filesPath):
			if dirFile != objects_without_file_directory:
				for dirType in os.listdir(os.path.join(filesPath,dirFile)):
					if dirType in [regex.sub(r'[:\?\*<>\|]','_', x) for x in PlwFormat.instances.keys()]:
						for fileObject in os.listdir(os.path.join(dirType,filesPath,dirFile,dirType)):
							pathList.append(os.path.join(dirType, filesPath, dirFile,dirType,fileObject))
		with Progress() as progress:
			main_task = progress.add_task("[cyan]Processing objects with dataset...", total = len(pathList))
			for file in pathList:
				progress.advance(main_task, 1)
				if os.path.basename(os.path.dirname(file)) != js_subdirectory:
					PlwObject(file)

def processJS():
	js2Script = {}
	if os.path.isdir(jsPath):
		for jsFile in os.listdir(jsPath):
			with open(jsPath, 'rb') as fin:
				js2Script[file.name] = fin.read()
			for obj in PlwFormat.instances['#%ARCHIVE:ENVIRONMENT-OBJECT:'].objects:
				if obj.id in js2Script:
					obj.js2 = js2Script[obj.id]

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
				if os.path.basename(os.path.dirname(file)) != js_subdirectory:
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
		main_task = progress.add_task("[cyan]Callers of " + obj.id.decode('utf-8') + " ...", total = len(PlwFormat.instances))
		sub_task = progress.add_task("[green]Class ...", total = 0)
		for plwFormat in PlwFormat.instances.values():
			progress.update(sub_task, total=len(PlwFormat.instances.values()), completed=0)
			for otherObj in plwFormat.objects:
				if otherObj != obj:
					for attribute, string in otherObj.attributesForSearch.items():
						if obj.format.searchedByONB:
							if obj.onb in string:
								deps.append(ObjDependancy(obj, otherObj, attribute, True))
						if obj.format.searchedByNAME:
							if obj.name in string:
								deps.append(ObjDependancy(obj, otherObj, attribute, False))
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
					# too much false positive with ATV. they all have the same name. O(n²). see later for other :(
					if plwFormat.table_def == b'#%TEMP-TABLE:_ATV_PT_ATT_VAL:' and otherPlwFormat.table_def == b'#%TEMP-TABLE:_ATV_PT_ATT_VAL:':
						continue
					for otherObj in otherPlwFormat.objects:
						if otherObj != obj:
							if obj.format.searchedByONB and obj.onb in otherObj.valuesConcat:
								globalIndex[obj.id].append(otherObj)
							if obj.format.searchedByNAME and obj.name in otherObj.valuesConcat:
								globalIndex[obj.id].append(otherObj)
							if otherObj.js2 != b'' and not otherObj in globalIndex[obj.id] and obj.name in otherObj.js2:
								globalIndex[obj.id].append(otherObj)
				progress.update(main_task, description = "[cyan]Object indexation " + str(i) + "/" + str(len(PlwObject.instances)) + ". Found " + str(len(globalIndex.keys())) + " objects called by other(s)...", advance = 1)

def indexFunctions(globalIndex):
	jsObjects = []
	functions = []
	methods = []
	for obj in PlwFormat.instances['#%ARCHIVE:ENVIRONMENT-OBJECT:'].objects:
		if obj.js2 != b'':
			jsObjects.append(obj)
	with Progress() as progress:
		main_task = progress.add_task("[cyan]Functions parsing...", total = len(jsObjects))
		for obj in jsObjects:
			regexp = regex.compile(b'^\s*function\s+([^\(]+)\(')
			obj.functions = regexp.findall(obj.js2)
			regexp = regex.compile(b'^\s*method\s+([^\(]+) on')
			obj.methods = regexp.findall(obj.js2)
	with Progress() as progress:
		i=0
		main_task = progress.add_task("[cyan]Functions indexation...", total = len(jsObjects))
		for plwFormat in PlwFormat.instances.values():
			for jsObj in jsObjects:
				i+=1
				for otherPlwFormat in PlwFormat.instances.values():
					if plwFormat.table_def == b'#%TEMP-TABLE:_ATV_PT_ATT_VAL:' and otherPlwFormat.table_def == b'#%TEMP-TABLE:_ATV_PT_ATT_VAL:':
						continue
					for otherObj in otherPlwFormat.objects:
						if otherObj != jsObj:
							for function in jsObj.functions:
								if function in otherObj.valuesConcat:
									globalIndex[jsObj.id].append(otherObj)
							for method in jsObj.methods:
								if method in otherObj.valuesConcat:
									globalIndex[jsObj.id].append(otherObj)
				progress.update(main_task, description = "[cyan]Functions indexation " + str(i) + "/" + str(len(jsObjects)) + ". Found " + str(len(globalIndex.keys())) + " functions called in other objects...", advance = 1)

def processDepLinks(globalIndex):
	with Progress() as progress:
		main_task = progress.add_task("[cyan]Processing dependancies...", total = len(ObjDependancy.instances))
		for objectId, callers in globalIndex.items():
			obj = PlwObject.instances[objectId]
			if obj.format.searchedByONB:
				for caller in callers:
					for attribute, value in caller.attributes.items():
						if obj.onb in value:
							ObjDependancy(obj, caller, attribute, True, '')
			if obj.format.searchedByNAME:
				for caller in callers:
					for attribute, value in caller.attributes.items():
						if obj.name in value:
							ObjDependancy(obj, caller, attribute, False, '')
			progress.advance(main_task, 1)

### dump csv
def dumpEdgesToCSV(outputPath, main_directory):
	csvPath = os.path.join(outputPath, main_directory + '_callers.csv')
	with open(csvPath, mode='w', newline='', encoding='utf-8') as file:
		writer = csv.writer(file, delimiter=';')
		writer.writerow(['id_left', 'onb_left', 'name_left', 'type_left', 
							'id_right', 'onb_right', 'name_right', 'type_right', 
							'column_right', 'byName', 'byOnb'])
		with Progress() as progress:
			main_task = progress.add_task("[cyan]Exporting data to CSV (" + str(len(ObjDependancy.instances)) + ")...", total = len(ObjDependancy.instances))
			for dep in ObjDependancy.instances:
				writer.writerow([
					dep.left.id.decode('utf-8'),
					dep.left.onb.decode('utf-8'),
					dep.left.name.decode('utf-8'),
					dep.left.format.table_def.decode('utf-8'),
					dep.right.id.decode('utf-8'),
					dep.right.onb.decode('utf-8'),
					dep.right.name.decode('utf-8'),
					dep.right.format.table_def.decode('utf-8'),
					dep.column.decode('utf-8'),
					str(not(dep.calledByOnb)),
					str(dep.calledByOnb)
				])
				progress.advance(main_task, 1)
	print('\n' + csvPath + ' exported')

# DB functions
def createEdgesTable(conn):
	conn.execute('DROP TABLE IF EXISTS edges')
	query = '''
	CREATE TABLE IF NOT EXISTS edges (
		SOURCE TEXT,
		TARGET TEXT,
		INATTRIBUTE TEXT,
		BYNAME TEXT,
		BYONB TEXT,
		DATA TEXT
	)
	'''
	conn.execute(query)
	conn.commit()

def createNodesTable(conn):
	conn.execute('DROP TABLE IF EXISTS nodes')
	query = '''
	CREATE TABLE IF NOT EXISTS nodes (
		ID TEXT,
		NAME TEXT,
		TYPE TEXT,
		ATTRIBUTES TEXT,
		DATA TEXT
	)
	'''
	conn.execute(query)
	conn.commit()

def createTableDefTable(conn):
	conn.execute('DROP TABLE IF EXISTS TABLEDEF')
	query = '''
	CREATE TABLE IF NOT EXISTS TABLEDEF (
		ID TEXT,
		TXT TEXT,
		OBJECTS TEXT
	)
	'''
	conn.execute(query)
	conn.commit()

def insertBatch(cursor, table_name, rows, columns):
	placeholders = ', '.join(['?'] * len(columns))
	query = f"INSERT INTO {table_name} ({', '.join(columns)}) VALUES ({placeholders})"
	try:
		cursor.executemany(query, rows)  # Insertion par lots
	except sqlite3.OperationalError as e:
		print(f"Error executing query: {query}")
		print(f"Rows attempted to insert: {rows}")
		raise e

def prepareEdgesAndInsert(db_connection, cursor, batchSize=10000):
	id_left = []
	id_right = []
	column_right = []
	byName = []
	byOnb = []
	with Progress() as progress:
		main_task = progress.add_task('[cyan]Inserting edges in database (batchSize = ' + str(batchSize) + ')...', total=len(ObjDependancy.instances))
		for dep in ObjDependancy.instances:
			id_left.append(dep.left.id.decode('utf-8'))
			id_right.append(dep.right.id.decode('utf-8'))
			column_right.append(dep.column.decode('utf-8'))
			byName.append(str(not dep.calledByOnb))
			byOnb.append(str(dep.calledByOnb))
			if len(id_left) >= batchSize:
				rows = list(zip(id_left, id_right, column_right, byName, byOnb))
				insertBatch(cursor, 'edges', rows, ['SOURCE', 'TARGET', 'INATTRIBUTE', 'BYNAME', 'BYONB'])
				id_left.clear()
				id_right.clear()
				column_right.clear()
				byName.clear()
				byOnb.clear()
				db_connection.commit()
			progress.advance(main_task, 1)
		if id_left:
			rows = list(zip(id_left, id_right, column_right, byName, byOnb))
			insertBatch(cursor, 'edges', rows, ['SOURCE', 'TARGET', 'INATTRIBUTE', 'BYNAME', 'BYONB'])
			db_connection.commit()

def prepareNodesAndInsert(db_connection, cursor, batchSize=1000):
	objId = []
	objName = []
	objType = []
	objAttributes = []
	objValues = []
	with Progress() as progress:
		main_task = progress.add_task('[cyan]Inserting nodes in database...', total=len(PlwObject.instances))
		for obj in PlwObject.instances.values():
			objId.append(obj.id.decode('utf-8'))
			objName.append(obj.name.decode('utf-8'))
			objType.append(obj.format.table_def.decode('utf-8'))
			objAttributes.append(chr(23).join([x.decode('utf-8') for x in obj.attributes.keys()]))
			objValues.append(chr(23).join([x.decode('utf-8', errors='replace') for x in obj.attributes.values()]))
			if len(objId) >= batchSize:
				rows = list(zip(objId, objName, objType, objAttributes, objValues))
				insertBatch(cursor, 'nodes', rows, ['ID', 'NAME', 'TYPE', 'ATTRIBUTES', 'DATA'])
				objId.clear()
				objName.clear()
				objType.clear()
				objAttributes.clear()
				objValues.clear()
				db_connection.commit()
			progress.advance(main_task, 1)
		if objId:
			rows = list(zip(objId, objName, objType, objAttributes, objValues))
			insertBatch(cursor, 'nodes', rows, ['ID', 'NAME', 'TYPE', 'ATTRIBUTES', 'DATA'])
			db_connection.commit()

def dumpTablesToDB(main_directory, outputPath):
	db_name = main_directory + '_graph.db'
	dbPath = os.path.join(outputPath, db_name)

	if os.path.exists(dbPath):
		print(f"Database {db_name} already present. Data will be overwritten.")

	conn = sqlite3.connect(dbPath)
	createEdgesTable(conn)
	createNodesTable(conn)
	createTableDefTable(conn)
	cursor = conn.cursor()

	prepareEdgesAndInsert(conn, cursor)
	print(f"Edges exported into {db_name}")

	prepareNodesAndInsert(conn, cursor)
	print(f"Nodes exported into {db_name}")

	formatID = []
	formatTxt = []
	formatObjectsNumber = []
	with Progress() as progress:
		main_task = progress.add_task('[cyan]Inserting table table definition in database...', total=len(PlwFormat.instances))
		for oFormat in PlwFormat.instances.values():
			formatID.append(oFormat.table_def.decode('utf-8'))
			formatTxt.append(oFormat.txt.decode('utf-8', errors='replace'))
			formatObjectsNumber.append(str(len(oFormat.objects)))
			progress.advance(main_task, 1)

	data = {'ID': formatID, 'TXT': formatTxt, 'OBJECTS': formatObjectsNumber}
	df_tabledef = pd.DataFrame(data)
	insertBatch(cursor, 'TABLEDEF', df_tabledef.to_records(index=False), df_tabledef.columns)
	conn.commit()
	print(f"Table definition exported into {db_name}")
	conn.close()
	print(f"\nDatabase {db_name} exported successfully.")

def main():
	signal.signal(signal.SIGINT, signal_handler)
	parser = argparse.ArgumentParser()
	parser.add_argument('directory', type=checkArgPath, help='path/to/.../DPM_OUT (created with dpm_extract.py)')
	parser.add_argument('-b', '--browse', action='store_true', help='Prompted for object visualisation')
	parser.add_argument('-x', '--exclude', action='store_true', help='Prompted for selection of classes to exclude')
	parser.add_argument('-m', '--mode', choices=['csv', 'db'], default='csv', help="Export mode : 'csv' or 'db' (default : 'csv')")
	args = parser.parse_args()

	global main_directory
	inputPath = args.directory
	formatPath = ''
	filesPath = ''
	jsPath = ''
	main_directory = os.path.basename(inputPath)
	outputPath = os.path.join(os.path.dirname(os.path.realpath(__file__)),'output')
	if not os.path.exists(outputPath):
		os.makedirs(outputPath)

	if os.path.isdir(inputPath) and main_directory not in os.path.basename(inputPath):
		print(args.directory + ' is not a base directory of an extracted dpm (.../' + main_directory + ')')
		return

	for root, dirs, files in os.walk(inputPath):
		if format_subdirectory in dirs and files_subdirectory in dirs:
			formatPath = os.path.join(inputPath,format_subdirectory)
			filesPath = os.path.join(inputPath,files_subdirectory)
			otherPath = os.path.join(inputPath,files_subdirectory,objects_without_file_directory)
			jsPath = os.path.join(inputPath,js_subdirectory)
			break
	processFormats(formatPath)
	if args.exclude:
		mapDirectories(filesPath, otherPath)
		processExclusions(outputPath, main_directory)
	processObjects(filesPath, otherPath)
	if args.browse:
		browseObject()
	globalIndex = defaultdict(list)
	indexDependancies(globalIndex)
	indexFunctions(globalIndex)
	processDepLinks(globalIndex)
	if os.path.isdir(outputPath):
		if args.mode == 'csv':
			dumpEdgesToCSV(outputPath, main_directory)
		else:
			dumpTablesToDB(main_directory, outputPath)
	else:
		print(outputPath + ' not found')

if __name__ == '__main__':
    main()