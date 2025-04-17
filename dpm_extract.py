#!/usr/bin/env python
import io
import gzip
import sys
import os
import regex # pip install regex
import hashlib
import argparse
import inquirer # pip install inquirer
from rich.progress import Progress # pip install rich
import signal
import copy

#######################################
#	Function for dynamic classes
def init_object(self, plwFormat, tableDefColumns, dpmLine, cls):
	# object identifier: value of the attribute marked as INDEX of the table-def, or the concatenation of the OTHER-INDEXES values
	# or BLOB_OFFSET if :BLOB is marked as INDEX
	values = dpmLine.split(b'\t')
	values.pop(0)
	obj_identifier = ''
	if cls.keyID != b'NIL' and cls.keyID != b':BLOB':
		obj_identifier = values[[x.ATT for x in tableDefColumns].index(cls.keyID)]
	elif cls.keyID == b':BLOB':
		obj_identifier = values[[x.ATT for x in tableDefColumns].index(cls.keyID)] + b'_' + values[[x.ATT for x in tableDefColumns].index(b':OFFSET')]
	else:
		obj_identifiers = []
		for eachKey in cls.other_indexes:
			obj_identifiers.append(values[[x.ATT for x in tableDefColumns].index(eachKey)])
		obj_identifier = b"_".join(obj_identifiers)
	filename = obj_identifier.decode('utf-8')
	# for the classes with a :BLOB keyID, this identifier is not unique for the objects. filenames are ':BLOB_' + md5hash
	# if cls.keyID.decode('utf-8') == ':BLOB':
		# md5hash = hashlib.md5(dpmLine).hexdigest()
		# filename = filename + '_' + md5hash
	self.plwFormat = PlwFormat.instances[plwFormat.decode('utf-8')]
	self.type_directory = regex.sub(rb'[:\?\*<>\|]',b'_',plwFormat)
	self.values = values
	self.PlwFile = ''
	self.directory = ''
	cls.instances.append(self)
	self.id = obj_identifier
	self.filename = filename
	if cls.name in ['#%DATABASE-IO:USER-PARAMETER:']:
	# pdf, doc and thumbnail filenames are  managed by checksum, not increment anymore
		self.id = obj_identifier.decode('utf-8')+'-'+str(len(cls.instances))

def show_object(object):
	nMaxAttributeNameLength = max([len(x.ATT) for x in object.plwFormat.columns])
	print('****** type: '			+ object.plwFormat.table_def.decode('utf-8'))
	print('id: '					+ object.id.decode('utf-8'))
	print('filename: '				+ object.filename)
	print('attributes/values: ')
	print(b'\n'.join([col.ATT.ljust(nMaxAttributeNameLength+1) + object.values[object.plwFormat.columns.index(col)] for col in object.plwFormat.columns]).decode('utf-8'))

def write_object(object, object_path=1):
	if object_path != '':
		output_file = open(object_path, 'wb')
	if len(object.plwFormat.columns) == len(object.values):
		output_file.write(object.plwFormat.table_def + b'\n')
		output_file.write(b'\n'.join([col.ATT + b'\t' + object.values[object.plwFormat.columns.index(col)] for col in object.plwFormat.columns]))
	else:
		print("columns/values inconsistent".encode('utf-8'))
	if object_path != '':
		output_file.close()
				
def check_object_attribute(object, attribute):
	# search if object posses the attribute, returns the rank or -1 if not found
	if attribute in [col.ATT for col in object.plwFormat.columns]:
		return [col.ATT for col in object.plwFormat.columns].index(attribute)
	else:
		return -1
	
def print_object_attribute(object, attribute):
# to refine
	attribute_found = -1
	columns=iter(object.columns)
	values=iter(object.values)
	for i in object.values:
		if next(columns)[0][0] == attribute:
			print(next(values))
			attribute_found = 1
		else:
			next(values)
	if attribute_found == -1:
		print('Attribute', attribute,'not found')

######################################
#	Classes
class PlwFile:
	instances = {}
	def __init__(self, plwfile_txt_str, dpmHeader):
		regexp = regex.compile(rb':OBJECT-NUMBER\n? (\d+)')
		file_onb = regexp.findall(plwfile_txt_str)[0]
		# regexp = regex.compile(b':INDEX[^\(\)]+"(@?@?[\w|\&]+)"')
        # E7: project in dpm
		file_index = ''
		regexpNAME = regex.compile(rb':INDEX[^\(\)]+"(@?@?[\w|\&|\s|\+]+)"')
		regexpNONAME = regex.compile(rb':INDEX[^\(\):]+NIL')
		# print(plwfile_txt_str)
		if len(regexpNONAME.findall(plwfile_txt_str)) == 0:
			file_index = regexpNAME.findall(plwfile_txt_str)[0]
		else:
			file_index = regexpNONAME.findall(plwfile_txt_str)[0]
		# print(file_index)
		regexp = regex.compile(rb':PROVIDERS[^\(\)]+\((.+\))\)[^\(\)]')
		file_providers = regexp.findall(plwfile_txt_str)
		if file_providers == []:
			regexp = regex.compile(rb':PROVIDERS\s+(NIL)')
			file_providers = regexp.findall(plwfile_txt_str)
		else:
			file_providers = file_providers[0]
		# print(file_providers)
		regexp = regex.compile(rb':USERS[^\(\)]+\((.+)\)\)',regex.S)
		file_users = regexp.findall(plwfile_txt_str)
		if file_users == []:
			regexp = regex.compile(rb':USERS\s+(NIL)')
			file_users = regexp.findall(plwfile_txt_str)[0]
		else:
			file_users = file_users[0]
			
		# print(file_users)
		
		file_directory = regex.sub(rb'[:\?\*<>\|]',b'_',file_index)

		self.onb = file_onb
		self.index = file_index
		self.providers = file_providers
		self.users = file_users
		self.txt = plwfile_txt_str
		self.directory = file_directory.decode('utf-8')
		self.nb_objects = 0
		
		PlwFile.instances[self.onb] = self
		
	def countObj(self):
		for plwFormat in PlwFormat.instances.values():
			if plwFormat.hasDataset:
				self.nb_objects += b'\t'.join(plwFormat.rawData).count(self.onb)
			
class DpmHeader:
	header_txt = ''
	formats_txt = ''
	data_txt = ''
	def __init__(self, dpm_text_bin, id_str):
		regexp = regex.compile(b'(.*):BEGIN-OF-HEADERS',regex.DOTALL)
		firstlines = regexp.findall(dpm_text_bin)[0];
	
		regexp = regex.compile(b'(:BEGIN-OF-HEADERS.*:END-OF-HEADERS)',regex.DOTALL)
		header_text = regexp.findall(dpm_text_bin)[0]
		
		regexp = regex.compile(b'(:BEGIN-OF-FORMAT.*:END-OF-FORMAT)',regex.DOTALL)
		format_text = regexp.findall(dpm_text_bin)[0]
		
		regexp = regex.compile(b':END-OF-FORMAT(.*)',regex.DOTALL)
		data_text = regexp.findall(dpm_text_bin)[0]
		
		regexp = regex.compile(rb':BEGIN-OF-HEADERS\n\((.*)\)\n:END-OF-CLASSES',regex.S)
		header_classes = regexp.findall(dpm_text_bin)[0].split(b'\n')
		
		regexp = regex.compile(rb':END-OF-CLASSES\n\((.*)\)\n:END-OF-OBJECTS',regex.S)
		header_objects = regexp.findall(dpm_text_bin)[0]
		
		regexp = regex.compile(rb'(\(((?>[^()]+)|(?1))*\))',regex.S)
		header_plwfiles = regexp.findall(header_objects)
		header_files = []
		for plwfile_txt in header_plwfiles:	
			regexp = regex.compile(rb':OBJECT-NUMBER (\d+)')
			onb = regexp.findall(plwfile_txt[0])
			new_file = PlwFile(plwfile_txt[0], self)
			header_files.append(new_file)
			
		self.id = id_str
		self.name = firstlines
		self.classes = header_classes
		self.objects = header_objects
		self.files = header_files
		self.path = ''
		
		DpmHeader.header_txt = header_text
		DpmHeader.formats_txt = format_text
		DpmHeader.data_txt = data_text
		
	def print_header(self,output_path=1):
		if output_path != '':
			output_file = open(output_path, 'w', encoding = 'utf-8')
			# output_file = open(output_path, 'w', encoding = 'ISO-8859-1')
			saveout = sys.stdout
			sys.stdout = output_file

		print('id		'	+ self.id)
		print('name		'	+ self.name)
		# print('text	'	+ self.text)
		# print('classes'    + self.classes)
		print('objects	'	+ self.objects)
		print('path		'	+ self.path)

		if output_path != '':
			sys.stdout = saveout
			output_file.close()

class ColumnsDef:
	def __init__(self, text, format):
		regexp = regex.compile(b'(:.*) :DATABASE-TYPE',regex.DOTALL)
		ATT = regexp.findall(text)[0]
		regexp = regex.compile(b':DATABASE-TYPE (.*) :LENGTH',regex.DOTALL)
		DATABASE_TYPE = regexp.findall(text)[0]
		regexp = regex.compile(b':LENGTH (.*) :NULLABLE',regex.DOTALL)
		LENGTH = regexp.findall(text)[0]
		regexp = regex.compile(b':NULLABLE (.*) :COMMENT',regex.DOTALL)
		NULLABLE = regexp.findall(text)[0]
		regexp = regex.compile(b':COMMENT (.*) :ENCRYPTION',regex.DOTALL)
		COMMENT = regexp.findall(text)[0]
		regexp = regex.compile(rb':ENCRYPTION (.*)\)',regex.DOTALL)
		ENCRYPTION = regexp.findall(text)[0]
		
		self.ATT            = ATT
		self.DATABASE_TYPE  = DATABASE_TYPE
		self.LENGTH         = LENGTH
		self.NULLABLE       = NULLABLE
		self.COMMENT        = COMMENT
		self.ENCRYPTION     = ENCRYPTION
		self.VALUE			= b''
		self.format = format

class PlwFormat:
	# Those 'format' objects instances will be in a dictionnary {FORMAT_NAME: object}
	instances = {}
	
	def __init__(self,one_format_text):
        # E7: now some uppercases
		regexp = regex.compile(b':TABLE-DEF (.*)',regex.I)
		format_table_def = regexp.findall(one_format_text)[0]
		regexp = regex.compile(b':NAME "([^"]*)"')
		format_name = regexp.findall(one_format_text)[0]
		regexp = regex.compile(rb':TABLE-INDEX \((.*)\)')
		format_table_index_brut = regexp.findall(one_format_text)
		if len(format_table_index_brut) > 0:
			format_table_index = format_table_index_brut[0]
		else:
			format_table_index = ''
		regexp = regex.compile(rb':COLUMNS (\(((?>[^()]+)|(?1))*\))',regex.DOTALL)
		format_columns_raw = regexp.findall(one_format_text)[0][0][1:-1]
		regexp = regex.compile(rb':ATT ',regex.DOTALL)
		format_columns_separated = regexp.split(format_columns_raw)
		format_columns_fields = []
		for each in format_columns_separated:
			regexp = regex.compile(b'(:.*) :DATABASE-TYPE',regex.DOTALL)
			if len(regexp.findall(each)) > 0:
				col = ColumnsDef(each, self)
				format_columns_fields.append(col)
		regexp = regex.compile(rb':OTHER-INDEXES (\(((?>[^()]+)|(?1))*\))')
		format_other_indexes_brut = regexp.findall(one_format_text)
		regexp = regex.compile(rb'\((:.*?)\)',regex.DOTALL)
		format_other_indexes = ['']
		if len(format_other_indexes_brut) > 0:
			format_other_indexes = regexp.findall(format_other_indexes_brut[0][0])
		
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
		self.columns 		= format_columns_fields
		self.table_index 	= format_table_index
		self.other_indexes 	= format_other_indexes
		self.dirname 		= format_dirname.decode('utf-8')
		self.path 			= ''
		self.keyID 			= format_keyID
		self.txt 			= one_format_text
		self.rawData		= b''
		self.hasDataset		= b':DATASET' in [col.ATT for col in self.columns]
		self.objects 		= []
		
	def	print_format(self):
		# pass
		print('****** table_def: '			+ self.table_def.decode('utf-8'))
		# print('name: '				+ self.name.decode('utf-8'))
		print('columns: '				+ str(self.columns))
		# print('nb_columns: %6.0f' % self.nb_columns)
		print('table_index: '			+ self.table_index.decode('utf-8'))
		print('other_indexes: '		+ str(self.other_indexes))
		# print('dirname: '				+ self.dirname)
		# print('path: '				+ self.path)
		print('keyID: '				+ self.keyID.decode('utf-8'))

class Dpm_objects_metaclass(type):
	classes_creees = 0
	instances = {}
	def listMetaclass():
		for key in Dpm_objects_metaclass.instances.keys():
			print(str(len(Dpm_objects_metaclass.instances[key].instances)).ljust(8) + key)
			
	def __new__(cls, name, bases, dict, format_obj):
		return super(Dpm_objects_metaclass, cls).__new__(cls,name, bases, dict)
	
	def __init__(cls_obj, name, bases, dict, format_obj):
		Dpm_objects_metaclass.classes_creees += 1
		Dpm_objects_metaclass.instances[name] = cls_obj
		cls_obj.name = name
		cls_obj.keyID = PlwFormat.instances[cls_obj.name].keyID
		cls_obj.other_indexes = PlwFormat.instances[cls_obj.name].other_indexes

######################################
#	functions
def Process_classes(dpm_text_bin):
	# parse ":BEGIN-OF-FORMAT" block in the dpm
	# instancies a PlwFormat object for each type found
    # creates an object class for each type found in the format structure with attributes defined in the format
	
	regexp = regex.compile(b':BEGIN-OF-FORMAT.*:END-OF-FORMAT',regex.DOTALL) # the entire bloc FORMAT
	format_text = regexp.findall(dpm_text_bin)[0]
	# the text bloc is splited into a list (1 elt by format)
	# exception: check the error in planisware standard definition of format "globalsettings": "Date value (spanish" (missing ending perenthesis)
	regexp = regex.compile(rb'"Date value \(spanish"',regex.DOTALL)
	has_the_error = regexp.findall(format_text)
	if len(has_the_error) > 0:
		format_text = regexp.sub(b'"Date value (spanish)"',format_text)
	regexp = regex.compile(rb'(\(((?>[^()]+)|(?1))*\))',regex.DOTALL)
	format_text_list = regexp.findall(format_text)
	for each in format_text_list:
		# dump version
		if len(each) > 0:
			if regex.search(b':dump-version',each[0]):
				regexp = regex.compile(rb':dump-version :([^\)]*)')
				# print('DUMP VERSION: ' + regexp.findall(each[0])[0].decode('ascii'))
			else:
				my_format = PlwFormat(each[0])
				
	#################################################################
	# creating a python class per object type : running the factory #
	#################################################################
	for each_format in PlwFormat.instances:
		class_methods = {
			'__init__': init_object,
			'show': show_object,
			'print': write_object,
			'instances': [],
		}
		# "format.table_def" is binary but we create the python class by passing a string (mandatory because the class instanciator wants a string)
		my_format = PlwFormat.instances[each_format]
		cls = Dpm_objects_metaclass(my_format.table_def.decode('utf-8'), (DpmHeader,), class_methods, my_format)
	print(str(len(PlwFormat.instances)) + ' format(s) instanciated')

def processExclusions():
	# Exclude types
	classList = sorted(PlwFormat.instances.values(), key=lambda o: len(o.rawData), reverse=True)
	dictTableDef = checkboxChooser('Class','Select classes to exclude',[(str(len(x.rawData)).ljust(8) + x.keyID.decode('utf-8').ljust(20) + x.name.decode('utf-8'),x) for x in classList])
	for plwFormat in dictTableDef['Class']:
		del PlwFormat.instances[plwFormat.table_def.decode('utf-8')]
	# Exclude files
	# for plwFile in PlwFile.instances.values():
		# plwFile.countObj()
	# plwFilelist = sorted(PlwFile.instances.values(), key=lambda o: o.nb_objects, reverse = True)
	# dictFile = checkboxChooser('File','Select File to exclude',[(str(x.nb_objects).ljust(8) + x.onb.decode('utf-8').ljust(20) + x.index.decode('utf-8'),x) for x in plwFilelist])
	# for plwFile in dictFile['File']:
		# del PlwFile.instances[plwFile.onb]

def extractDataForFormat(dpm_text_str,out_dir):
	# This function parses the last part of the dpm to find environment objects described by blocks and connect this to the tableDef object
	# Isolate all the objects, from the first class to the last (at the very bottom)
	regexp = regex.compile(b':END-OF-FORMAT\n(.*)',regex.DOTALL)
	all_objects_text = regexp.findall(dpm_text_str)[0]
	# splitted by blocks (separated with ^Z$)
	regexp = regex.compile(b'\nZ\n',regex.DOTALL)
	class_object_text = regex.split(regexp,all_objects_text)
	class_object_text.pop();
	# for each class we separate the 1st line (name of the class) from the rest (data)
	# and we push it into the rawData attribute of the PlwFormat object
	with Progress() as progress:
		main_task = progress.add_task("[red]Split the data...", total = len(class_object_text))
		for each in class_object_text:
			# add a final \n removed when splitted ^Z$
			progress.advance(main_task, 1)
			each = each + b'\n'
			regexp = regex.compile(b'(.*)\n')
			plwFormatName = regex.findall(regexp,each)[0]
			regexp = regex.compile(b'(.*)\n')
			# split the lines
			lines_objects = regex.findall(regexp,each)
			lines_objects.pop(0)
			PlwFormat.instances[plwFormatName.decode('utf-8')].rawData = lines_objects

def Process_objects(dpm_text_str,out_dir):
	# This function parses the last part of the dpm to find environment objects described by blocks
	# Generates a python class per object type found and instances a python object of this class for each environment object found (=line, most of the time)
	# instanciation of the objects
	i = 0
	with Progress() as progress:
		main_task = progress.add_task("[cyan]Instanciating objects...", total = len(PlwFormat.instances))
		sub_task = progress.add_task("[green]Class ...", total = 0)
		for my_format in PlwFormat.instances.values():
			progress.update(sub_task, total=len(my_format.rawData), completed=0)
			for dpmLine in my_format.rawData: # for each format, describing the class
				my_class = Dpm_objects_metaclass.instances[my_format.table_def.decode('utf-8')] # search the class, describing the object
				my_obj = my_class(my_format.table_def, my_format.columns, dpmLine, my_class) # instanciate the object on this class
				i+=1
				# a Python object for a planisware object is created!
				my_format.objects.append(my_obj)
				# completion of attributes PlwFile, directory and path of each object
				# some object without dataset
				rank = check_object_attribute(my_obj, b':DATASET')
				if my_format.table_def.decode('utf-8') == '#%GENERIC-IO:OPX2-USER:' or my_format.table_def.decode('utf-8') == '#%GENERIC-IO:USER-GROUP:' or my_format.table_def.decode('utf-8') == '#%GENERIC-IO:USER-IN-GROUP:':
				# For these classes, there is a dataset but is not relevant (onb = 1)
					rank = -1;
				if rank > -1:
					my_obj.PlwFile = PlwFile.instances[my_obj.values[rank]]  # PlwFile is a python object
					my_obj.path = os.path.join(out_dir, main_directory, files_subdirectory, my_obj.PlwFile.directory, my_format.dirname, my_obj.filename)
					my_obj.directory = os.path.join(out_dir, main_directory, files_subdirectory, my_obj.PlwFile.directory, my_format.dirname)
				else:
					my_obj.PlwFile = ''
					my_obj.path = os.path.join(out_dir, main_directory, files_subdirectory, objects_without_file_directory, my_format.dirname, my_obj.filename)
					my_obj.directory = os.path.join(out_dir, main_directory, files_subdirectory, objects_without_file_directory, my_format.dirname)
				progress.update(sub_task, description = "[green]Class " + my_format.table_def.decode('utf-8') + "...", advance=1)
			progress.advance(main_task, 1)
	print(str(i) + ' object(s) instanciated')
	
def Create_directory_structure (output_path, dpm):
	# creation of the folders
	i = 0
	filename 	= main_directory
	dpm.path 	= os.path.join(output_path, filename)
	header_path = os.path.join(dpm.path, header_subdirectory)
	format_path = os.path.join(dpm.path, format_subdirectory)
	data_path 	= os.path.join(dpm.path, data_subdirectory)
	files_path  = os.path.join(dpm.path, files_subdirectory)
	if not(os.path.isdir(dpm.path)):
		os.mkdir(dpm.path)
		i+=1
	if os.path.isdir(dpm.path):
		if not(os.path.isdir(header_path)):
			os.mkdir(header_path)
			i+=1
		if not(os.path.isdir(format_path)):
			os.mkdir(format_path)
			i+=1
		if not(os.path.isdir(data_path)):
			os.mkdir(data_path)
			i+=1
		if not(os.path.isdir(files_path)):
			os.mkdir(files_path)
			i+=1

		# Creation of folders <PLW_FILE_NAME>
		for each in PlwFile.instances:
			PlwFile_path = os.path.join(files_path, PlwFile.instances[each].directory)
			if not(os.path.isdir(PlwFile_path)):
				os.mkdir(PlwFile_path)
				i+=1

	#creation of objects treestructure
	path_vect = []
	with Progress() as progress:
		main_task = progress.add_task("[red]Creation of directories...", total = len(PlwFormat.instances))
		for each_format in PlwFormat.instances:
			progress.advance(main_task, 1)
			for each_object in Dpm_objects_metaclass.instances[each_format].instances:
				object_type_path = os.path.join(files_path, each_object.directory)
				if each_object.PlwFile == '':
					without_file_path = os.path.join(files_path, objects_without_file_directory)
					if not(os.path.isdir(without_file_path)):
						os.mkdir(without_file_path)
						i+=1
					if os.path.isdir(without_file_path) and not(os.path.isdir(object_type_path)):
						os.mkdir(object_type_path)
						i+=1
				else:
					if not(os.path.isdir(object_type_path)):
						os.mkdir(object_type_path)
						i+=1
				path_vect.append(object_type_path)
	print(str(i) + ' directories created')

def extract_headers(output_path):
	header_dir 	= os.path.join(output_path, main_directory, header_subdirectory)
	format_dir 	= os.path.join(output_path, main_directory, format_subdirectory)
	data_dir	= os.path.join(output_path, main_directory, data_subdirectory)
	if os.path.isdir(header_dir):
		header_file = os.path.join(header_dir, 'header.txt')
		# output_file = open(header_file, 'w', encoding = 'utf-8')
		# output_file = open(header_file, 'w', encoding = 'ISO-8859-1')
		output_file = open(header_file, 'wb')
		output_file.write(DpmHeader.header_txt)
		output_file.close()
		for each_file in PlwFile.instances:
			file_file = os.path.join(header_dir, each_file.decode('utf-8'))
			output_file = open(file_file, 'wb')
			output_file.write(PlwFile.instances[each_file].txt)
			output_file.close()
			
	if os.path.isdir(format_dir):
		format_file = os.path.join(format_dir, 'formats.txt')
		# output_file = open(format_file, 'w', encoding = 'utf-8')
		# output_file = open(format_file, 'w', encoding = 'ISO-8859-1')
		output_file = open(format_file, 'wb')
		output_file.write(DpmHeader.formats_txt)
		output_file.close()
		for each_format in PlwFormat.instances:
			format_elt_file = os.path.join(format_dir, PlwFormat.instances[each_format].dirname)
			output_file = open(format_elt_file, 'wb')
			output_file.write(PlwFormat.instances[each_format].table_def + b'\n')
			output_file.write(PlwFormat.instances[each_format].txt + b'\n')
			output_file.close()
			
	if os.path.isdir(data_dir):
		data_file = os.path.join(data_dir, 'data.txt')
		# output_file = open(data_file, 'w', encoding = 'utf-8')
		# output_file = open(data_file, 'w', encoding = 'ISO-8859-1')
		output_file = open(data_file, 'wb')
		# output_file.write(str(DpmHeader.data_txt.encode('utf-8')))
		output_file.write(DpmHeader.data_txt)
		output_file.close()	
			
def extract_objects(output_path):
	for each_format in PlwFormat.instances:
		all_object_in_class_have_a_name = 1
		number_of_anonymous_objects = 0
		object_created = 0
		bSkip = 'n'
		if len(Dpm_objects_metaclass.instances[each_format].instances) > 400000:
			bSkip = input(each_format + ' ' + str(len(Dpm_objects_metaclass.instances[each_format].instances)) + ' objects... skip? y/n:')
		if bSkip == 'y':
			pass
		else:
			for each_object in Dpm_objects_metaclass.instances[each_format].instances:
				object_have_a_name = 0
				# gestion des users parameters (indexés via 2 champs, USER/KEY). Chaque users parameters d'un user seront sauvés dans un fichier txt nommé "onb_de_l'user-N°increment"
				# a définir
				if len(each_object.filename) > 50:
					object_have_a_name = 0
				else:
					if output_path != '':
						object_path = os.path.join(output_path, main_directory, files_subdirectory, each_object.path, each_object.filename)
					else:
						object_path = os.path.join(main_directory, files_subdirectory, each_object.path, each_object.filename)
					if not(os.path.isfile(each_object.path)):
						write_object(each_object, each_object.path)
					object_have_a_name = 1
					object_created = object_created + 1
					print(PlwFormat.instances[each_format].name.decode('utf-8'),object_created,'                ' ,end = '\r')
				if object_have_a_name == 0:
					print('##################',each_object.filename)
					all_object_in_class_have_a_name = 0
					number_of_anonymous_objects = number_of_anonymous_objects + 1
		print(PlwFormat.instances[each_format].name.decode('utf-8'),object_created,'                ' )
		# if number_of_anonymous_objects > 0:
			# print(number_of_anonymous_objects,'anonymous object found in class',PlwFormat.instances[each_format].table_def.decode('utf-8'),' not extracted. keyID was \''+PlwFormat.instances[each_format].keyID.decode('utf-8')+'\'')
		# if all_object_in_class_have_a_name == 0:
			# print(PlwFormat.instances[each_format].table_def, ' no onb, no extract')

def print_results(output_path):
	# output_file = open(output_path, 'w', encoding = 'utf-8')
	output_file = open(output_path, 'w', encoding = 'ISO-8859-1')
	saveout = sys.stdout
	sys.stdout = output_file
	Dpm_objects_metaclass.listMetaclass()
	sys.stdout = saveout
	output_file.close()

def checkboxChooser(sKey, sQuestion, lList):
    questions = [inquirer.Checkbox(
        sKey,
        message=sQuestion,
        choices=lList,
        carousel=True
    )]
    answers = inquirer.prompt(questions)  # returns a dict
    return answers
	
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
		dictTableDef = listChooser('Class','Browse a table definition',[(str(len(tableDef.instances)).ljust(8) + tableDef.name, tableDef) for tableDef in Dpm_objects_metaclass.instances.values()])
		objectsList = sorted(dictTableDef['Class'].instances, key=lambda o: o.id)
		dictObject = listChooser('Object','instances of ' + dictTableDef['Class'].name, [(obj.id.decode('utf-8'), obj) for obj in objectsList])
		dictObject['Object'].show()
		print('\n')
		choices = [('Another object', 1), ('Exit', 2)]
		selection = listChooser('Action','Next action',choices)
		if selection['Action'] == 2:
			sys.exit(0)
		clear()

def clear():
    if os.name == 'nt': # for windows
        _ = os.system('cls')
    else: # for mac and linux(here, os.name is 'posix')
        _ = os.system('clear')

def signal_handler(sig, frame):
    print('Thanks')
    sys.exit(0)

def main():
	signal.signal(signal.SIGINT, signal_handler)
	parser = argparse.ArgumentParser()
	parser.add_argument("dpmFile", help="path/to/...dpm.gz")
	parser.add_argument("-b", "--browse", action='store_true', help="Prompted for object visualisation")
	parser.add_argument("-x", "--exclude", action='store_true', help="Prompted for selection of classes to exclude")
	args = parser.parse_args()
	
	outputPath = os.path.join(os.path.dirname(os.path.realpath(__file__)),'output')
	dpmText = b''
	with gzip.open(args.dpmFile, 'rb') as dpmFile:
		dpmText = dpmFile.read()
	myHeader = DpmHeader(dpmText,'Dpm1')
	Process_classes(dpmText)
	extractDataForFormat(dpmText,outputPath)
	if args.exclude:
		processExclusions()
	Process_objects(dpmText, outputPath)
	# Dpm_objects_metaclass.listMetaclass()
	if args.browse:
		browseObject()
	# print('3-Create directory structure')
	Create_directory_structure(outputPath, myHeader)
	extract_headers(outputPath)
    # print('4-Extract objects')
	extract_objects(outputPath)
				
main_directory = 'DPM_OUT'
files_subdirectory = 'FILES'
data_subdirectory = 'DATA'
format_subdirectory = 'FORMAT'
header_subdirectory = 'HEADER'
objects_without_file_directory = '#OTHERS'

if __name__ == '__main__':
    main()