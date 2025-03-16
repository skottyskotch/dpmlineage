#!/usr/bin/env python
import io
import gzip
import sys
import os
import regex
import hashlib
import argparse

main_directory = 'DPM_OUT'
files_subdirectory = 'FILES'
data_subdirectory = 'DATA'
format_subdirectory = 'FORMAT'
header_subdirectory = 'HEADER'
objects_without_file_directory = '#OTHERS'

#	Dynamic class for objects
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
	# pdf, doc and thumbnail filenames are now managed by checksum, not increment anymore
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
			# output_file = open(output_path, 'w', encoding = 'utf-8')
			output_file = open(output_path, 'w', encoding = 'ISO-8859-1')
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
	plw_formats_instancies = {}
	
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
		plw_format.plw_formats_instancies[format_table_def.decode('utf-8')] = self

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
	classes_instanciees = {}
	
	def print_metaclass():
		for key in Dpm_objects_metaclass.classes_instanciees:
			print("{}\t{}".format(key,len(Dpm_objects_metaclass.classes_instanciees[key].plw_objects_instancies)))
			
	def __new__(cls, name, bases, dict, format_obj):
		return super(Dpm_objects_metaclass, cls).__new__(cls,name, bases, dict)
	
	def __init__(cls_obj, name, bases, dict, format_obj):
		Dpm_objects_metaclass.classes_creees += 1
		Dpm_objects_metaclass.classes_instanciees[name] = cls_obj
		cls_obj.name = name
		cls_obj.keyID = plw_format.plw_formats_instancies[cls_obj.name].keyID
		cls_obj.other_indexes = plw_format.plw_formats_instancies[cls_obj.name].other_indexes

def Process_objects(dpm_text_str,out_dir):
	# Cette fonction va parser la dernière partie du dpm pour trouver les objets environement decrits par blocs
	# Generer une classe python par type d'objet trouve et instancier un objet python pour chaque ligne d'objet d'environement detectee
	# on isole toute la partie des objets, de la premiere classe jusqu'à la dernière (tout en bas du fichier)
	regexp = regex.compile(b':END-OF-FORMAT\n(.*)',regex.DOTALL)
	all_objects_text = regexp.findall(dpm_text_str)[0]
	# on eclate cette partie par blocs (separes par des ^Z$)
	regexp = regex.compile(b'\nZ\n',regex.DOTALL)
	class_object_text = regex.split(regexp,all_objects_text)
	class_object_text.pop();
	# pour chaque classe on separe la 1ere ligne (nom de la classe) du reste (donnees)
	# et on met dans un dico: NOM_DE_LA_CLASSE => bloc texte des objets de la classe
	class_objets_dict = dict()
	# print(len(class_object_text))
	for each in class_object_text:
	### ajouter un \n final enlevé lors de l'éclatement ^Z$
		each = each + b'\n'
		regexp = regex.compile(b'(.*)\n')
		class_name = regex.findall(regexp,each)[0]
		class_objets_dict[class_name] = each
		# print(each)

	# creation des objets
	# print(class_objets_dict.keys());
	for each in class_objets_dict:
	#### <debug>
		# if each.decode('utf-8') == '#%DATABASE-IO:USER-PARAMETER:':
		# if each.decode('utf-8') == '#%GRID:TABLE-STYLE:':
			# class_userparam = each
			# print(class_objets_dict[class_userparam])
			# print(len(class_objets_dict[class_userparam]))
			# for each_obj in class_objets_dict[class_userparam]:
				# print(class_objets_dict[class_userparam][each_obj])
	#### <\debug>
	
		# each est une cle du dico {type d'objet: bloc texte avec tous les objets}
		# on retrouve cette cle dans les plw_formats_instancies qui pointe vers l'objet format
		
		# on eclate les lignes d'objets de la classe
		regexp = regex.compile(b'(.*)\n')
		lines_objects = regex.findall(regexp,class_objets_dict[each])
		# print(len(lines_objects))
	#### <debug>
		# if each.decode('utf-8') == '#%GRID:TABLE-STYLE:':
		# if each.decode('utf-8') == '#%GENERIC-IO:USER-DATASET-USE:':
		# if each.decode('utf-8') == '#%OTHER-TREES:2BS:':
			# for each_lin in lines_objects:
				# print(each_lin)
	#### <\debug>
		lines_objects.pop(0)
		for line in lines_objects:
			my_format = plw_format.plw_formats_instancies[each.decode('utf-8')]
			my_class = Dpm_objects_metaclass.classes_instanciees[each.decode('utf-8')]
			my_obj = my_class(each, my_format.columns, line, my_class)
			# print_object(my_obj)
			# Python object for planisware objects is created
			my_format.objects.append(my_obj)
			# complete attributes plwFile, directory and path of each object
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
			
def Process_classes(dpm_text_bin):
	# parse le bloc "FORMAT" du dpm
	# instancie un objet de de la classe format par type trouve
	# creer une classe d'objet par type trouve dans les formats structure avec ses attributs trouves
	
	# tout le bloc des formats
	regexp = regex.compile(b':BEGIN-OF-FORMAT.*:END-OF-FORMAT',regex.DOTALL)
	format_text = regexp.findall(dpm_text_bin)[0]
	# print(format_text)
	# le bloc texte est eclate dans une liste (un elt par format)
	# check the error in planisware standard definition of format "globalsettings": "Date value (spanish" (missing ending perenthesis)
	regexp = regex.compile(b'"Date value \(spanish"',regex.DOTALL)
	has_the_error = regexp.findall(format_text)
	if len(has_the_error) > 0:
		# print(has_the_error)
		format_text = regexp.sub(b'"Date value (spanish)"',format_text)
		# print(format_text)
	regexp = regex.compile(b'(\(((?>[^()]+)|(?1))*\))',regex.DOTALL)
	format_text_list = regexp.findall(format_text)
	# chaque element de la liste est parse et une nouvelle liste d'objets instancies est generee
	for each in format_text_list:
		# dump version
		# print(len(each))
		if len(each) > 0:
			# print(each[0])
			if regex.search(b':dump-version',each[0]):
				regexp = regex.compile(b':dump-version :([^\)]*)')
				print('DUMP VERSION: ' + regexp.findall(each[0])[0].decode('ascii'))
			else:
				my_format = plw_format(each[0])
				# my_format.print_format()
				
	###############################
	# creation d'une classe par type objet
	###############################
	for each_format in plw_format.plw_formats_instancies:
		# print(each_format)
		class_methods = {
			# '__new__': create_object,
			'__init__': init_object,
			'print': write_object,
			'plw_objects_instancies': [],
		}
		# "format.table_def" est binaire mais on crée la classe python en passant un string (obligé car l'instanciateur de classe veut une string)
		my_format = plw_format.plw_formats_instancies[each_format]
		cls = Dpm_objects_metaclass(my_format.table_def.decode('utf-8'), (DpmHeader,), class_methods, my_format)
		
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
	for each_format in plw_format.plw_formats_instancies:
		for each_object in Dpm_objects_metaclass.classes_instanciees[each_format].plw_objects_instancies:
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
	# print('\n'.join(list(set(path_vect))))

def print_results(output_path):
	# output_file = open(output_path, 'w', encoding = 'utf-8')
	output_file = open(output_path, 'w', encoding = 'ISO-8859-1')
	saveout = sys.stdout
	sys.stdout = output_file
	Dpm_objects_metaclass.print_metaclass()
	sys.stdout = saveout
	output_file.close()

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
		for each_format in plw_format.plw_formats_instancies:
			format_elt_file = os.path.join(format_dir, plw_format.plw_formats_instancies[each_format].dirname)
			output_file = open(format_elt_file, 'wb')
			output_file.write(plw_format.plw_formats_instancies[each_format].table_def + b'\n')
			output_file.write(plw_format.plw_formats_instancies[each_format].txt + b'\n')
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
	for each_format in plw_format.plw_formats_instancies:
		all_object_in_class_have_a_name = 1
		number_of_anonymous_objects = 0
		object_created = 0
		for each_object in Dpm_objects_metaclass.classes_instanciees[each_format].plw_objects_instancies:
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
				print(plw_format.plw_formats_instancies[each_format].name.decode('utf-8'),object_created,'                ' ,end = '\r')
			if object_have_a_name == 0:
				print('##################',each_object.filename)
				all_object_in_class_have_a_name = 0
				number_of_anonymous_objects = number_of_anonymous_objects + 1
		print(plw_format.plw_formats_instancies[each_format].name.decode('utf-8'),object_created,'                ' )
		if number_of_anonymous_objects > 0:
			print(number_of_anonymous_objects,'anonymous object found in class',plw_format.plw_formats_instancies[each_format].table_def.decode('utf-8'),' not extracted. keyID was \''+plw_format.plw_formats_instancies[each_format].keyID.decode('utf-8')+'\'')
		if all_object_in_class_have_a_name == 0:
			print(plw_format.plw_formats_instancies[each_format].table_def, ' pas d\'onb, pas extrait')
			# for each_object in Dpm_objects_metaclass.classes_instanciees[each_format].plw_objects_instancies:
				# write_object(each_object)
				# print(each_object.type)
				# print(each_object.columns)
				# print(each_object.values)
	
def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("dpmFile", help="path/to/...dpm.gz")
    args = parser.parse_args()
    outputPath = os.path.dirname(os.path.realpath(__file__))

    dpmText = b''
    with gzip.open(args.dpmFile, 'rb') as dpmFile:
        dpmText = dpmFile.read()
    
    myHeader = DpmHeader(dpmText,'Dpm1')
    print('Process_classes')
    Process_classes(dpmText)
    print('Process object')
    Process_objects(dpmText,outputPath)
    print('Create directory')
    Create_directory_structure(outputPath, myHeader)
    print('Extract header')
    extract_headers(outputPath)
    print('Extract objects')
	extract_objects(outputPath)
				
if __name__ == '__main__':
    main()