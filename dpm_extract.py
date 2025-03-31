#!/usr/bin/env python
import io
import gzip
import sys
import os
import regex
import hashlib
import argparse
from rich.progress import Progress

#######################################
#	Function for dynamic classes
def create_object(cls, type, columns, values, clas):
	print('classe creee')
	return type.__new__()
	
def init_object(self, type, columns, line, cls):
	values = line.split(b'\t')
	values.pop(0)
	# object identifier
	obj_identifier = ''
	if cls.keyID != b'NIL':
		attribute_names=iter(columns)
		attribute_values=iter(values)
		for i in columns:
			if next(attribute_names)[0][1] == cls.keyID:
				obj_identifier = next(attribute_values)
				break
			else:
				next(attribute_values)
	else:
		obj_identifiers = []
		for eachKey in cls.other_indexes:
			attribute_names=iter(columns)
			attribute_values=iter(values)
			for i in columns:
				if next(attribute_names)[0][1] == eachKey:
					obj_identifiers.append(next(attribute_values))
					break
				else:
					next(attribute_values)
		obj_identifier = b"_".join(obj_identifiers)
	filename = obj_identifier.decode('utf-8')
	# for the classes with a :BLOB keyID, this identifier is not unique for the objects. filenames are ':BLOB_' + md5hash
	if cls.keyID.decode('utf-8') == ':BLOB':
		md5hash = hashlib.md5(line).hexdigest()
		filename = filename + '_' + md5hash
	self.type = type
	type_directory = regex.sub(b'[:\?\*<>\|]',b'_',type)
	self.type_directory = type_directory
	self.columns = columns
	self.values = values
	self.plwFile = ''
	self.directory = ''
	cls.plw_objects_instancies.append(self)
	# self.id = obj_identifier.decode('utf-8')
	self.id = obj_identifier
	self.filename = filename
	if cls.name in ['#%DATABASE-IO:USER-PARAMETER:']:
	# pdf, doc and thumbnail filenames are  managed by checksum, not increment anymore
		self.id = obj_identifier.decode('utf-8')+'-'+str(len(cls.plw_objects_instancies))

def print_object(object):
	# pass
	print('****** type: '			+ object.type.decode('utf-8'))
	# print('id: '					+ object.id.decode('utf-8'))
	print('filename: '				+ object.filename)
	# print('columns: '				+ str(object.columns))
	# print('values: '				+ str(object.values))

def write_object(object, object_path=1):
	if object_path != '':
		output_file = open(object_path, 'wb')
	if len(object.columns) == len(object.values):
		columns=iter(object.columns)
		values=iter(object.values)
		# print(object.type)
		output_file.write(object.type + b'\n')
		for i in object.values:
			bin_col = next(columns)[0][1]
			bin_val = next(values)
			line = bin_col + b'\t' + bin_val + b'\n'
			output_file.write(line)
	else:
		print("columns/values inconsistent".encode('utf-8'))
	if object_path != '':
		output_file.close()
				
def check_object_attribute(object, attribute):
	attribute_found = -1
	i = -1
	for each_col in object.columns:
		i = i + 1
		if each_col[0][1] == attribute:
			attribute_found = 1
			break
	if attribute_found == 1:
		return i
	else:
		return attribute_found
	
def print_object_attribute(object, attribute):
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
class plwFile:
	instances = {}
	def __init__(self, plwfile_txt_str, dpmHeader):
		regexp = regex.compile(b':OBJECT-NUMBER\n? (\d+)')
		file_onb = regexp.findall(plwfile_txt_str)[0]
		# regexp = regex.compile(b':INDEX[^\(\)]+"(@?@?[\w|\&]+)"')
        # E7: project in dpm
		file_index = ''
		regexpNAME = regex.compile(b':INDEX[^\(\)]+"(@?@?[\w|\&|\s|\+]+)"')
		regexpNONAME = regex.compile(b':INDEX[^\(\):]+NIL')
		# print(plwfile_txt_str)
		if len(regexpNONAME.findall(plwfile_txt_str)) == 0:
			file_index = regexpNAME.findall(plwfile_txt_str)[0]
		else:
			file_index = regexpNONAME.findall(plwfile_txt_str)[0]
		# print(file_index)
		regexp = regex.compile(b':PROVIDERS[^\(\)]+\((.+\))\)[^\(\)]')
		file_providers = regexp.findall(plwfile_txt_str)
		if file_providers == []:
			regexp = regex.compile(b':PROVIDERS\s+(NIL)')
			file_providers = regexp.findall(plwfile_txt_str)
		else:
			file_providers = file_providers[0]
		# print(file_providers)
		regexp = regex.compile(b':USERS[^\(\)]+\((.+)\)\)',regex.S)
		file_users = regexp.findall(plwfile_txt_str)
		if file_users == []:
			regexp = regex.compile(b':USERS\s+(NIL)')
			file_users = regexp.findall(plwfile_txt_str)[0]
		else:
			file_users = file_users[0]
			
		# print(file_users)
		
		file_directory = regex.sub(b'[:\?\*<>\|]',b'_',file_index)

		self.onb = file_onb
		self.index = file_index
		self.providers = file_providers
		self.users = file_users
		self.txt = plwfile_txt_str
		self.directory = file_directory.decode('utf-8')
		
		plwFile.instances[self.onb] = self
			
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
		
		regexp = regex.compile(b':BEGIN-OF-HEADERS\n\((.*)\)\n:END-OF-CLASSES',regex.S)
		header_classes = regexp.findall(dpm_text_bin)[0].split(b'\n')
		
		regexp = regex.compile(b':END-OF-CLASSES\n\((.*)\)\n:END-OF-OBJECTS',regex.S)
		header_objects = regexp.findall(dpm_text_bin)[0]
		
		regexp = regex.compile(b'(\(((?>[^()]+)|(?1))*\))',regex.S)
		header_plwfiles = regexp.findall(header_objects)
		header_files = []
		for plwfile_txt in header_plwfiles:	
			regexp = regex.compile(b':OBJECT-NUMBER (\d+)')
			onb = regexp.findall(plwfile_txt[0])
			new_file = plwFile(plwfile_txt[0], self)
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

class plw_format:
	formats_crees = 0;
	#tous les objets formats seront dans un dico {NOM_DU_FORMAT: objet}
	instances = {}
	
	def __init__(self,one_format_text):
		plw_format.formats_crees += 1
		# print(one_format_text)
        # E7: now some uppercases
		regexp = regex.compile(b':TABLE-DEF (.*)',regex.I)
		format_table_def = regexp.findall(one_format_text)[0]
		# print(format_table_def)
		# if format_table_def == []:
			# print(one_format_text)
		regexp = regex.compile(b':NAME "([^"]*)"')
		format_name = regexp.findall(one_format_text)[0]
		# print(format_name)
		regexp = regex.compile(b':TABLE-INDEX \((.*)\)')
		format_table_index_brut = regexp.findall(one_format_text)
		if len(format_table_index_brut) > 0:
			format_table_index = format_table_index_brut[0]
		else:
			format_table_index = ''
		# print(format_table_index)
		
		regexp = regex.compile(b':COLUMNS (\(((?>[^()]+)|(?1))*\))',regex.DOTALL)
		format_columns_brut = regexp.findall(one_format_text)[0][0][1:-1]
		regexp = regex.compile(b':ATT ',regex.DOTALL)
		format_columns_separated = regexp.split(format_columns_brut)
		# print(format_columns_separated)
		format_columns_fields = []
		for each in format_columns_separated:
			regexp = regex.compile(b':DATABASE-TYPE')
			if len(regexp.findall(each)) == 0:
				pass
				# print('rejected')
			else:
				each_without_parenthesis = each[1:-1]
				# print(each_without_parenthesis)
				column_vect=[[]]
				
				regexp = regex.compile(b'(:.*) :DATABASE-TYPE',regex.DOTALL)
				attribute = regexp.findall(each)[0]
				column_vect = [[b':ATT',attribute]]
				
				regexp = regex.compile(b':DATABASE-TYPE (.*) :LENGTH',regex.DOTALL)
				databasetype = regexp.findall(each)[0]
				column_vect.append([b':DATABASE-TYPE',databasetype])
				
				regexp = regex.compile(b':LENGTH (.*) :NULLABLE',regex.DOTALL)
				length = regexp.findall(each)[0]
				column_vect.append([b':LENGTH',length])
				
				regexp = regex.compile(b':NULLABLE (.*) :COMMENT',regex.DOTALL)
				nullable = regexp.findall(each)[0]
				column_vect.append([b':NULLABLE',nullable])
				
				regexp = regex.compile(b':COMMENT (.*) :ENCRYPTION',regex.DOTALL)
				comment = regexp.findall(each)[0]
				column_vect.append([b':COMMENT',comment])
				
				regexp = regex.compile(b':ENCRYPTION (.*)\)',regex.DOTALL)
				encryption = regexp.findall(each)[0]
				column_vect.append([b':ENCRYPTION',encryption])
				
				format_columns_fields.append(column_vect)
		# print(format_columns_fields)
		
		regexp = regex.compile(b':OTHER-INDEXES (\(((?>[^()]+)|(?1))*\))')
		format_other_indexes_brut = regexp.findall(one_format_text)
		regexp = regex.compile(b'\((:.*?)\)',regex.DOTALL)
		format_other_indexes = ['']
		if len(format_other_indexes_brut) > 0:
			format_other_indexes = regexp.findall(format_other_indexes_brut[0][0])
		# print(format_other_indexes)
		
		# objects that comes from a format with an empty :index will be based on the first of the :other indexes
		format_keyID = format_table_index
		if format_keyID == '':
			format_keyID = format_other_indexes[0]
			# user-parameter have  :other-indexes ((:USER :KEY) (:USER))
			if format_table_def.decode('utf-8') == '#%DATABASE-IO:USER-PARAMETER:':
				format_keyID = format_keyID.split(b" ")[0]
		
		# les clés du hash des formats sont en string car on va les utiliser pour créer des classes avec l'instanciateur de classe python type() qui veut un string en argument
		plw_format.instances[format_table_def.decode('utf-8')] = self

		format_dirname = regex.sub(b'[:\?\*<>\|]',b'_',format_table_def)
		
		self.table_def 		= format_table_def
		self.name 			= format_name
		self.columns 		= format_columns_fields
		self.nb_columns 	= len(self.columns)
		self.table_index 	= format_table_index
		self.other_indexes 	= format_other_indexes
		self.dirname 		= format_dirname.decode('utf-8')
		self.path 			= ''
		self.keyID 			= format_keyID
		self.txt 			= one_format_text
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
	
	def print_metaclass():
		for key in Dpm_objects_metaclass.instances:
			print("{}\t{}".format(key,len(Dpm_objects_metaclass.instances[key].plw_objects_instancies)))
			
	def __new__(cls, name, bases, dict, format_obj):
		return super(Dpm_objects_metaclass, cls).__new__(cls,name, bases, dict)
	
	def __init__(cls_obj, name, bases, dict, format_obj):
		Dpm_objects_metaclass.classes_creees += 1
		Dpm_objects_metaclass.instances[name] = cls_obj
		cls_obj.name = name
		cls_obj.keyID = plw_format.instances[cls_obj.name].keyID
		cls_obj.other_indexes = plw_format.instances[cls_obj.name].other_indexes

######################################
#	functions
def Process_classes(dpm_text_bin):
	# parse ":BEGIN-OF-FORMAT" block in the dpm
	# instancies a plw_format object for each type found
    # creates an object class for each type found in the format structure with attributes defined
	
	regexp = regex.compile(b':BEGIN-OF-FORMAT.*:END-OF-FORMAT',regex.DOTALL) # the entire bloc FORMAT
	format_text = regexp.findall(dpm_text_bin)[0]
	# the text bloc is splited into a list (1 elt by format)
	# exception: check the error in planisware standard definition of format "globalsettings": "Date value (spanish" (missing ending perenthesis)
	regexp = regex.compile(b'"Date value \(spanish"',regex.DOTALL)
	has_the_error = regexp.findall(format_text)
	if len(has_the_error) > 0:
		format_text = regexp.sub(b'"Date value (spanish)"',format_text)
	regexp = regex.compile(b'(\(((?>[^()]+)|(?1))*\))',regex.DOTALL)
	format_text_list = regexp.findall(format_text)
	for each in format_text_list:
		# dump version
		if len(each) > 0:
			if regex.search(b':dump-version',each[0]):
				regexp = regex.compile(b':dump-version :([^\)]*)')
				# print('DUMP VERSION: ' + regexp.findall(each[0])[0].decode('ascii'))
			else:
				my_format = plw_format(each[0])
				
	#################################################################
	# creating a python class per object type : running the factory #
	#################################################################
	for each_format in plw_format.instances:
		class_methods = {
			# '__new__': create_object,
			'__init__': init_object,
			'print': write_object,
			'plw_objects_instancies': [],
		}
		# "format.table_def" is binary but we create the python class by passing a string (mandatory because the class instanciator wants a string)
		my_format = plw_format.instances[each_format]
		cls = Dpm_objects_metaclass(my_format.table_def.decode('utf-8'), (DpmHeader,), class_methods, my_format)

def Process_objects(dpm_text_str,out_dir):
	# This function parses the last part of the dpm to find environment objects described by blocks
	# Generates a python class per object type found and instances a python object of this class for each environment object found (=line, most of the time)
	
	# Isolate all the objects, from the first class to the last (at the very bottom)
	regexp = regex.compile(b':END-OF-FORMAT\n(.*)',regex.DOTALL)
	all_objects_text = regexp.findall(dpm_text_str)[0]
	# splitted by blocks (separated with ^Z$)
	regexp = regex.compile(b'\nZ\n',regex.DOTALL)
	class_object_text = regex.split(regexp,all_objects_text)
	class_object_text.pop();
	# for each class we separate the 1st line (name of the class) from the rest (data)
	# and we push in a dict: b'Name of the class' => block text of the objects
	class_objets_dict = dict()
	with Progress() as progress:
		main_task = progress.add_task("[cyan]Split the data...", total = len(class_object_text))
		for each in class_object_text:
			# add a final \n removed when splitted ^Z$
			progress.advance(main_task, 1)
			each = each + b'\n'
			regexp = regex.compile(b'(.*)\n')
			class_name = regex.findall(regexp,each)[0]
			regexp = regex.compile(b'(.*)\n')
			# split the lines
			lines_objects = regex.findall(regexp,each)
			lines_objects.pop(0)
			class_objets_dict[class_name] = lines_objects

	# instanciation of the objects
	with Progress() as progress:
		main_task = progress.add_task("[cyan]Instanciating objects...", total = len(class_objets_dict))
		sub_task = progress.add_task("[green]Class ...", total = 0)
		for eachClass in class_objets_dict:
			progress.update(sub_task, total=15, completed=0)
			str = eachClass.decode('utf-8')
			progress.advance(main_task, 1)
			for line in class_objets_dict[eachClass]:
				my_format = plw_format.instances[eachClass.decode('utf-8')] # search the format, describing the class
				my_class = Dpm_objects_metaclass.instances[eachClass.decode('utf-8')] # search the class, describing the object
				my_obj = my_class(eachClass, my_format.columns, line, my_class) # instanciate the object
				# Python object for planisware objects is created!
				my_format.objects.append(my_obj)
				# completion of attributes plwFile, directory and path of each object
				# some object without dataset
				rank = check_object_attribute(my_obj, b':DATASET')
				if my_format.table_def.decode('utf-8') == '#%GENERIC-IO:OPX2-USER:' or my_format.table_def.decode('utf-8') == '#%GENERIC-IO:USER-GROUP:' or my_format.table_def.decode('utf-8') == '#%GENERIC-IO:USER-IN-GROUP:':
				# For these classes, the dataset is not relevant (onb = 1)
					rank = -1;
				if rank > -1:
					my_obj.plwFile = plwFile.instances[my_obj.values[rank]]  # plwFile is a python object
					my_obj.path = os.path.join(out_dir, main_directory, files_subdirectory, my_obj.plwFile.directory, my_format.dirname, my_obj.filename)
					my_obj.directory = os.path.join(out_dir, main_directory, files_subdirectory, my_obj.plwFile.directory, my_format.dirname)
				else:
					my_obj.plwFile = ''
					my_obj.path = os.path.join(out_dir, main_directory, files_subdirectory, objects_without_file_directory, my_format.dirname, my_obj.filename)
					my_obj.directory = os.path.join(out_dir, main_directory, files_subdirectory, objects_without_file_directory, my_format.dirname)
				progress.update(sub_task, description = "[green]Class completion " + eachClass.decode('utf-8') + "...", advance=1)

def Create_directory_structure (output_path, dpm):
	# creation du dossier principal et ses sous-dossiers
	filename 	= main_directory
	dpm.path 	= os.path.join(output_path, filename)
	header_path = os.path.join(dpm.path, header_subdirectory)
	format_path = os.path.join(dpm.path, format_subdirectory)
	data_path 	= os.path.join(dpm.path, data_subdirectory)
	files_path  = os.path.join(dpm.path, files_subdirectory)
	if not(os.path.isdir(dpm.path)):
		os.mkdir(dpm.path)
	if os.path.isdir(dpm.path):
		if not(os.path.isdir(header_path)):
			os.mkdir(header_path)
		if not(os.path.isdir(format_path)):
			os.mkdir(format_path)
		if not(os.path.isdir(data_path)):
			os.mkdir(data_path)
		if not(os.path.isdir(files_path)):
			os.mkdir(files_path)

		# Creation des dossiers NOM_DU_FICHIER_PLW
		for each in plwFile.instances:
			plwFile_path = os.path.join(files_path, plwFile.instances[each].directory)
			if not(os.path.isdir(plwFile_path)):
				os.mkdir(plwFile_path)

	#creation de l'arbo des objets
	path_vect = []
	for each_format in plw_format.instances:
		for each_object in Dpm_objects_metaclass.instances[each_format].plw_objects_instancies:
			object_type_path = os.path.join(files_path, each_object.directory)
			if each_object.plwFile == '':
				without_file_path = os.path.join(files_path, objects_without_file_directory)
				if not(os.path.isdir(without_file_path)):
					os.mkdir(without_file_path)
				if os.path.isdir(without_file_path) and not(os.path.isdir(object_type_path)):
					os.mkdir(object_type_path)
			else:
				if not(os.path.isdir(object_type_path)):
					os.mkdir(object_type_path)
			path_vect.append(object_type_path)

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
		for each_file in plwFile.instances:
			file_file = os.path.join(header_dir, each_file.decode('utf-8'))
			output_file = open(file_file, 'wb')
			output_file.write(plwFile.instances[each_file].txt)
			output_file.close()
			
	if os.path.isdir(format_dir):
		format_file = os.path.join(format_dir, 'formats.txt')
		# output_file = open(format_file, 'w', encoding = 'utf-8')
		# output_file = open(format_file, 'w', encoding = 'ISO-8859-1')
		output_file = open(format_file, 'wb')
		output_file.write(DpmHeader.formats_txt)
		output_file.close()
		for each_format in plw_format.instances:
			format_elt_file = os.path.join(format_dir, plw_format.instances[each_format].dirname)
			output_file = open(format_elt_file, 'wb')
			output_file.write(plw_format.instances[each_format].table_def + b'\n')
			output_file.write(plw_format.instances[each_format].txt + b'\n')
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
	for each_format in plw_format.instances:
		all_object_in_class_have_a_name = 1
		number_of_anonymous_objects = 0
		object_created = 0
		for each_object in Dpm_objects_metaclass.instances[each_format].plw_objects_instancies:
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
					# print(each_object.path)
					# print('exists: ' + str(os.path.exists(each_object.path)))
					write_object(each_object, each_object.path)
				object_have_a_name = 1
				object_created = object_created + 1
				print(plw_format.instances[each_format].name.decode('utf-8'),object_created,'                ' ,end = '\r')
			if object_have_a_name == 0:
				print('##################',each_object.filename)
				all_object_in_class_have_a_name = 0
				number_of_anonymous_objects = number_of_anonymous_objects + 1
		print(plw_format.instances[each_format].name.decode('utf-8'),object_created,'                ' )
		if number_of_anonymous_objects > 0:
			print(number_of_anonymous_objects,'anonymous object found in class',plw_format.instances[each_format].table_def.decode('utf-8'),' not extracted. keyID was \''+plw_format.instances[each_format].keyID.decode('utf-8')+'\'')
		if all_object_in_class_have_a_name == 0:
			print(plw_format.instances[each_format].table_def, ' pas d\'onb, pas extrait')

def print_results(output_path):
	# output_file = open(output_path, 'w', encoding = 'utf-8')
	output_file = open(output_path, 'w', encoding = 'ISO-8859-1')
	saveout = sys.stdout
	sys.stdout = output_file
	Dpm_objects_metaclass.print_metaclass()
	sys.stdout = saveout
	output_file.close()
	
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("dpmFile", help="path/to/...dpm.gz")
    args = parser.parse_args()
    outputPath = os.path.join(os.path.dirname(os.path.realpath(__file__)),'output')
    dpmText = b''
    with gzip.open(args.dpmFile, 'rb') as dpmFile:
        dpmText = dpmFile.read()
    myHeader = DpmHeader(dpmText,'Dpm1')
    print('1-Process_classes')
    Process_classes(dpmText)
    print('2-Process object')
    Process_objects(dpmText, outputPath)
    print('Create directory structure')
    Create_directory_structure(outputPath, myHeader)
    # print('Extract header')
    extract_headers(outputPath)
    print('Extract objects')
    extract_objects(outputPath)
				
main_directory = 'DPM_OUT'
files_subdirectory = 'FILES'
data_subdirectory = 'DATA'
format_subdirectory = 'FORMAT'
header_subdirectory = 'HEADER'
objects_without_file_directory = '#OTHERS'

if __name__ == '__main__':
    main()