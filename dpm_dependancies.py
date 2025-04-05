#!/usr/bin/env python
import os
import regex
import argparse
import inquirer # pip install inquirer
from rich.progress import Progress # pip install rich
import signal
import sys

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
		self.onb = ''
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
		PlwObject.instances[self.id] = self

	def show(self):
		nMaxAttributeNameLength = max([len(x.ATT) for x in self.format.columns])
		print('****** type: '			+ self.format.table_def.decode('utf-8'))
		print('key: '					+ self.format.keyID.decode('utf-8'))
		print('path: '					+ self.path)
		print('id: '					+ self.id.decode('utf-8'))
		print('attributes/values: ')
		print(b'\n'.join([col.ATT.ljust(nMaxAttributeNameLength+1) + self.values[self.format.columns.index(col)] for col in self.format.columns]).decode('utf-8'))

class ObjDependancy:
	instances = []
	def __init__(self, obj1, obj2, col, calledByOnb):
		# obj1 is called by obj2
		self.called = obj1
		self.caller = obj2
		self.callerColumn = col
		self.calledByOnb = calledByOnb # False = called by the name
		ObjDependancy.instances.append(self)

	def showThis(self):
		print(self.called.path)
		print(self.caller.path)
	
	@classmethod
	def showAll(cls):
		print(len(cls.instances))

def signal_handler(sig, frame):
    print('Thanks')
    sys.exit(0)

def processFormats(formatPath):
	pathList = []
	for fileFormat in os.listdir(formatPath):
		if regex.match('^#%',fileFormat):
			pathList.append(os.path.join(formatPath,fileFormat))
	with Progress() as progress:
		main_task = progress.add_task("[cyan]Processing table definition...", total = len(pathList))
		for file in pathList:
			progress.advance(main_task, 1)
			with open (file, 'rb') as fin:
				text = fin.read()
				PlwFormat(text,file)

def mapDirectories(filepath, otherpath):
	tableDefList = [x for x in PlwFormat.instances.keys()]
	tableDefObjectsDirs = []
	for root, dirs, files in os.walk(filepath):
		for tableDefObjectDir in dirs:
			for tableDefName in tableDefList:
				if tableDefObjectDir == regex.sub(r'[:\?\*<>\|]','_', tableDefName):
					PlwFormat.instances[tableDefName].objectPath = os.path.join(root,tableDefObjectDir)
					PlwFormat.instances[tableDefName].nb_objects += len(os.listdir(os.path.join(root,tableDefObjectDir)))
	for root, dirs, files in os.walk(otherpath):
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
	for dirFile in os.listdir(filesPath):
		if dirFile != objects_without_file_directory:
			for dirType in os.listdir(os.path.join(filesPath,dirFile)):
				if dirType in [regex.sub(r'[:\?\*<>\|]','_', x) for x in PlwFormat.instances.keys()]:
					for fileObject in os.listdir(os.path.join(dirType,filesPath,dirFile,dirType)):
						pathList.append(os.path.join(dirType,filesPath,dirFile,dirType,fileObject))
	with Progress() as progress:
		main_task = progress.add_task("[cyan]Processing objects with files...", total = len(pathList))
		for file in pathList:
			progress.advance(main_task, 1)
			PlwObject(file)

def processObjectsWithoutFiles(otherPath):
	pathList = []
	for dirOtherType in os.listdir(otherPath):
		if dirOtherType in [regex.sub(r'[:\?\*<>\|]','_', x) for x in PlwFormat.instances.keys()]:
			for fileObject in os.listdir(os.path.join(otherPath,dirOtherType)):
				pathList.append(os.path.join(otherPath,dirOtherType,fileObject))
	with Progress() as progress:
		main_task = progress.add_task("[cyan]Processing objects without files...", total = len(pathList))
		for file in pathList:
			progress.advance(main_task, 1)
			PlwObject(file)

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

def browseObject():
	# dictTableDef = listChooser('Class','Browse a table definition',[(str(len(x.objects)).ljust(8) + x.keyID.decode('utf-8').ljust(20) + x.name.decode('utf-8'),x) for x in PlwFormat.instances.values()])
	dictTableDef = listChooser('Class','Browse a table definition',[(str(len(x.objects)).ljust(8) + 'NAME:' + str(x.searchedByNAME).ljust(8) + ' ONB:' + str(x.searchedByONB).ljust(8) + x.name.decode('utf-8').ljust(20) ,x) for x in PlwFormat.instances.values()])
	objectsList = sorted(dictTableDef['Class'].objects, key=lambda o: o.id)
	dictObject = listChooser('Object','instances of ' + dictTableDef['Class'].table_def.decode('utf-8'), [(x.id.decode('utf-8'), x) for x in objectsList])
	clear()
	dictObject['Object'].show()
	return dictObject['Object']

def clear():
    if os.name == 'nt': # for windows
        _ = os.system('cls')
    else: # for mac and linux(here, os.name is 'posix')
        _ = os.system('clear')

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
		dep.showThis()

def searchDependancies():
	with Progress() as progress:
		main_task = progress.add_task("[red]Objects...", total = len(PlwObject.instances))
		sub_task1 = progress.add_task("[cyan]Object ...", total = 0)
		sub_task2 = progress.add_task("[green]Class ...", total = 0)
		for obj in list(PlwObject.instances.values()):
			for plwFormat in PlwFormat.instances.values():
				progress.update(sub_task2, total=len(PlwFormat.instances.values()), completed=0)
				for otherObj in plwFormat.objects:
					if otherObj != obj:
						for index, string in enumerate(otherObj.values):
							if obj.format.searchedByONB:
								if obj.onb in string:
									ObjDependancy(obj, otherObj, index, True)
							if obj.format.searchedByNAME:
								if obj.name in string:
									ObjDependancy(obj, otherObj, index, False)
					progress.update(sub_task2, description = "[green]Class " + plwFormat.table_def.decode('utf-8') + "...", advance=1)
				progress.update(sub_task1, description = "[cyan]Object " + obj.id.decode('utf-8') + " ...", advance=1)
			progress.advance(main_task, 1)

def dumpCallers():
    onbs = list(objectLsp.instances.keys())
    data = {'ONB': onbs,
    'NAME': [objectLsp.instances[x].name.decode('utf-8') for x in onbs],
    'CLASS': [objectLsp.instances[x].objectType.name for x in onbs],
    # 'CALLERS': [','.join([str(y.onb) for y in objectLsp.instances[x].callers]) for x in onbs],
    '#CALLERS': [str(len(objectLsp.instances[x].callers)) for x in onbs]}
    df = pd.DataFrame(data)
    df.to_csv('callers.csv', sep = ';')
    print('\ncallers.csv exported')
	
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
	if os.path.isdir(inputPath) and os.path.basename(inputPath) != main_directory:
		print(args.directory + ' is not a base directory of an extracted dpm (.../' + main_directory + ')')
		return
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
		bContinue = True
		report = []
		while bContinue:
			obj = browseObject()
			print('\n')
			choices = [('Search callers of this object', 1), ('Browse another object', 2), ('Exit', 3)]
			selection = listChooser('Action','Next action',choices)
			if selection['Action'] == 3:
				sys.exit(0)
			elif selection['Action'] == 1:
				searchDependanciesForOne(obj)
			else:
				# clear()
				pass
			ObjDependancy.showAll()
	searchDependancies()

main_directory = 'DPM_OUT'
files_subdirectory = 'FILES'
data_subdirectory = 'DATA'
format_subdirectory = 'FORMAT'
header_subdirectory = 'HEADER'
objects_without_file_directory = '#OTHERS'

if __name__ == '__main__':
    main()