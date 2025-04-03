#!/usr/bin/env python
import os
import regex

import io
import gzip
import sys
import regex
import hashlib
import argparse
import inquirer # pip install inquirer
from rich.progress import Progress # pip install rich
import signal

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
		self.objects 		= []

class PlwObject:
	# instances = {}
	def __init__(self, text):
		pattern = regex.compile(rb'^(#.*)$',regex.MULTILINE)
		self.format = PlwFormat.instances[pattern.findall(text)[0].decode('utf-8')]
		self.format.objects.append(self)
		self.callers = []
		self.columns = [col.ATT for col in self.format.columns]
		self.values = []
		self.id = b'NIL'
		for line in regex.split(b'\n',text)[1:]:
			self.values.append(regex.split(b'\t',line)[1])
		if self.format.keyID != b'NIL':
			self.id = self.values[self.columns.index(self.format.keyID)]
			
def signal_handler(sig, frame):
    print('Thanks')
    sys.exit(0)

def main():
	signal.signal(signal.SIGINT, signal_handler)
	parser = argparse.ArgumentParser()
	parser.add_argument("directory", help="path/to/.../DPM_OUT (created with dpm_extract.py)")
	parser.add_argument("-b", "--browse", action='store_true', help="Prompted for object visualisation")
	args = parser.parse_args()
	
	inputPath = args.directory
	formatPath = ''
	filesPath = ''
	if os.path.isdir(inputPath) and os.path.basename(inputPath) == main_directory:
		formatPath = ''
		filesPath = ''
		otherPath = ''
		for root, dirs, files in os.walk(inputPath):
			if format_subdirectory in dirs and files_subdirectory in dirs:
				formatPath = os.path.join(inputPath,format_subdirectory)
				filesPath = os.path.join(inputPath,files_subdirectory)
				otherPath = os.path.join(inputPath,files_subdirectory,objects_without_file_directory)
				break
		for fileFormat in os.listdir(formatPath):
			if regex.match('^#%',fileFormat):
				with open (os.path.join(formatPath,fileFormat), 'rb') as fin:
					text = fin.read()
					form = PlwFormat(text)
		for dirFile in os.listdir(filesPath):
			if dirFile != objects_without_file_directory:
				for dirType in os.listdir(os.path.join(filesPath,dirFile)):
					for fileObject in os.listdir(os.path.join(dirType,filesPath,dirFile,dirType)):
						with open (os.path.join(dirType,filesPath,dirFile,dirType,fileObject), 'rb') as fin:
							text = fin.read()
							PlwObject(text)
		for dirOtherType in os.listdir(otherPath):
			for fileObject in os.listdir(os.path.join(otherPath,dirOtherType)):
				with open (os.path.join(otherPath,dirOtherType,fileObject), 'rb') as fin:
					text = fin.read()
					PlwObject(text)
	else:
		print(args.directory + ' is not a base directory of an extracted dpm (.../' + main_directory + ')')


main_directory = 'DPM_OUT'
files_subdirectory = 'FILES'
data_subdirectory = 'DATA'
format_subdirectory = 'FORMAT'
header_subdirectory = 'HEADER'
objects_without_file_directory = '#OTHERS'

if __name__ == '__main__':
    main()


if os.path.isdir(inputPath) and os.path.basename(inputPath) == main_directory:
	for root, dirs, files in os.walk(inputPath):
		if format_subdirectory in dirs and files_subdirectory in dirs:
			formatPath = os.path.join(inputPath,format_subdirectory)
			filesPath = os.path.join(inputPath,files_subdirectory)
			otherPath = os.path.join(inputPath,files_subdirectory,objects_without_file_directory)
			for fileFormat in os.listdir(formatPath):
				if regex.match('^#%',fileFormat):
					with open (os.path.join(formatPath,fileFormat), 'rb') as fin:
						text = fin.read()
						PlwFormat(text)
			for dirFile in os.listdir(filesPath):
				if dirFile != objects_without_file_directory:
					for dirType in os.listdir(os.path.join(filesPath,dirFile)):
						for fileObject in os.listdir(os.path.join(dirType,filesPath,dirFile,dirType)):
							with open (os.path.join(dirType,filesPath,dirFile,dirType,fileObject), 'rb') as fin:
								text = fin.read()
								PlwObject(text)
			for dirOtherType in os.listdir(otherPath):
				for fileObject in os.listdir(os.path.join(otherPath,dirOtherType)):
					with open (os.path.join(otherPath,dirOtherType,fileObject), 'rb') as fin:
						text = fin.read()
						PlwObject(text)
		break
else:
	print(args.directory + ' is not a base directory of an extracted dpm (.../' + main_directory + ')')