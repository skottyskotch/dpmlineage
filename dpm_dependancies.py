#!/usr/bin/env python
import os
import regex
import argparse
import inquirer # pip install inquirer
from rich.progress import Progress # pip install rich
import signal

# import io
# import gzip
# import sys
# import hashlib

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
	
	def __init__(self,text):
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
		self.path 			= ''
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
		self.name = ''
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
				PlwFormat(text)

def processObjectsWithFiles(filesPath):
	pathList = []
	for dirFile in os.listdir(filesPath):
		if dirFile != objects_without_file_directory:
			for dirType in os.listdir(os.path.join(filesPath,dirFile)):
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

def browseObject():
	while True:
		dictTableDef = listChooser('Class','Browse a table definition',[(str(len(x.objects)).ljust(8) + x.keyID.decode('utf-8').ljust(20) + x.name.decode('utf-8'),x) for x in PlwFormat.instances.values()])
		objectsList = sorted(dictTableDef['Class'].objects, key=lambda o: o.id)
		dictObject = listChooser('Object','instances of ' + dictTableDef['Class'].table_def.decode('utf-8'), [(x.id.decode('utf-8'), x) for x in objectsList])
		dictObject['Object'].show()
		print('\n')
		input('<Enter> for another one.')
		clear()

def clear():
    if os.name == 'nt': # for windows
        _ = os.system('cls')
    else: # for mac and linux(here, os.name is 'posix')
        _ = os.system('clear')

def searchDependancies(obj, verbose):
	callers = []
	matchByNAME = []
	matchByONB = []
	for plwFormat in PlwFormat.instances.values():
		for otherObj in plwFormat.objects:
			if obj.format.searchedByONB:
				if otherObj != obj:
					matchByNAME = [(index, string)for index, string in enumerate(otherObj.values) if regex.search(obj.name, string)]
					if verbose and len(matchByNAME) > 0:
						print(obj.name)
						print(obj.path)
						print('name found in ' + otherObj.path)
						print(matchByNAME)
						# print([match[0] for match in matchByNAME])
						# print(otherObj.format.columns)
						# print([otherObj.format.columns[index].ATT for index in [match[1] for match in matchByNAME]])
				if otherObj != obj:
					matchByONB = [(index, string)for index, string in enumerate(otherObj.values) if regex.search(obj.onb, string)]
					if verbose and len(matchByONB) > 0:
						print(obj.onb)
						print(obj.path)
						print('onb found in ' + otherObj.path)
						print(matchByONB)
						# print([otherObj.format.columns[index].ATT for index in [match[0] for match in matchByONB]])
				if len(matchByONB) > 0 or len(matchByNAME) > 0:
					callers.append(otherObj)

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
	args = parser.parse_args()
	
	inputPath = args.directory
	formatPath = ''
	filesPath = ''
	if os.path.isdir(inputPath) and os.path.basename(inputPath) != main_directory:
		print(args.directory + ' is not a base directory of an extracted dpm (.../' + main_directory + ')')
	else:
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
		processObjectsWithFiles(filesPath)
		processObjectsWithoutFiles(otherPath)
	if args.browse:
		browseObject()
	i = 0
	for obj in list(PlwObject.instances.values()):
		i += 1
		print('searching dependencies ' + str(i) + '/' + str(len(list(PlwObject.instances.values()))) + ' ' + obj.format.name.decode('utf-8') + '                                                  ', end = '\r')
		searchDependancies(obj, False)

main_directory = 'DPM_OUT'
files_subdirectory = 'FILES'
data_subdirectory = 'DATA'
format_subdirectory = 'FORMAT'
header_subdirectory = 'HEADER'
objects_without_file_directory = '#OTHERS'

if __name__ == '__main__':
    main()