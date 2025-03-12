import argparse
import os
import re
import inquirer # pip install inquirer

parser = argparse.ArgumentParser()
parser.add_argument("lspdir", help="lsp directory name (path/to/diffDPM/UNDEFINED)")
args = parser.parse_args()

class objectType:
    instances = {}
    def __init__(self, name):
        self.name = name
        self.named = False
        self.regex = b''
        self.objects = []
        objectType.instances[self.name] = self

class objectLsp:
    instances = {}
    def __init__(self, nOnb, oObjectType, path):
        self.onb = nOnb
        self.name = b''
        self.path = path
        self.objectType = oObjectType
        objectLsp.instances[self.onb] = self
        oObjectType.objects.append(self)

def findNames(lspdir):
    if os.path.isdir(lspdir):
        regexA = re.compile(nameRegex, re.MULTILINE)
        refinedRegex1 = re.compile(refinedNameRegex1, re.MULTILINE)
        refinedRegex2 = re.compile(refinedNameRegex2, re.MULTILINE)
        regexB = re.compile(onbRegex, re.MULTILINE)
        for root, dirs, files in os.walk(lspdir, topdown=False):
            for name in dirs:
                myObjectType = objectType(name)
                for file in os.listdir(os.path.join(root,name)):
                    with open(os.path.join(root, name, file), 'rb') as lsp:
                        lspText = lsp.read()
                        objectOnb = re.findall(regexB,lspText)[0]
                        myObj = objectLsp(int(objectOnb.decode('utf-8')), myObjectType, os.path.join(root, name, file))
                        if len(re.findall(regexA,lspText)) > 0:
                            objectType.instances[name].named = True
                        if len(re.findall(refinedRegex1,lspText)) > 0:
                            objectType.instances[name].regex = '<:NAME "OBJECT_NAME">'
                            objectName = re.findall(refinedRegex1,lspText)[0]
                            myObj.name = objectName
                        elif len(re.findall(refinedRegex2,lspText)) > 0:
                            objectType.instances[name].regex = '<:NAME :OBJECT_NAME>'
                            objectName = re.findall(refinedRegex2,lspText)[0]
                            myObj.name = objectName
    else:
        print(lspdir)
        print('not a dir')
        return False
    print('Ignored:')
    print('\n'.join(['\t'  + key for key, value in objectType.instances.items() if value.named == False]))
    print('Parsed:')
    print('\n'.join(['\t' + str(len(value.objects)) + '\t' + str(value.regex) + '\t' + key for key, value in objectType.instances.items() if value.named == True]))
    return True

def chooseObjectToSearch():
    bContinue = True
    sChosenClass = ''
    while bContinue:
        questions = [inquirer.Checkbox(
            'class',
            message="Select one class",
            choices=[value.name + ' (' + str(len(value.objects)) + ')' for key, value in objectType.instances.items()],
        )]
        answers = inquirer.prompt(questions)  # returns a dict
        if len(answers['class']) == 1:
            bContinue = False
            sChosenClass = re.sub('\s\(\d*\)','',answers['class'][0])
            os.system('cls')
        else:
            print('Please select only one class')
    bContinue = True
    sChosenObject = ''
    while bContinue:
        questions = [inquirer.Checkbox(
            'object',
            message="Select one object",
            choices=[myObj.name.decode('utf-8') + ' (' + str(myObj.onb) + ')'for myObj in objectType.instances[sChosenClass].objects],
        )]
        answers = inquirer.prompt(questions)  # returns a dict
        if len(answers['object']) == 1:
            bContinue = False
            sChosenOnb = re.findall('\((\d+)\)',answers['object'][0])[0]
            os.system('cls')
            return objectLsp.instances[int(sChosenOnb)]
        else:
            print('Please select only one object')

def searchDependancies(obj, lspdir):
    print(obj.objectType.name + ' object ' + obj.name.decode('utf-8') + ' ('+ str(obj.onb) +') searched in the conf')
    callers = []
    for root, dirs, files in os.walk(lspdir, topdown=False):
        for name in dirs:
            for fileName in files:
                for file in os.listdir(os.path.join(root,name)):
                    with open(os.path.join(root, name, file), 'rb') as lsp:
                        if obj.path != os.path.join(root, name, file):
                            text = lsp.read()
                            if len(re.findall(str(obj.onb).encode('utf-8'), text)) > 0:
                                print('onb found in ' + os.path.join(root, name, file))
                            if obj.objectType.named == True and len(re.findall(obj.name, text)) > 0:
                                print('name found in ' + os.path.join(root, name, file))

def __main__():
    print('Find the names of the objects')
    lspdir = args.lspdir
    if findNames(lspdir):
        print('Search dependencies for one object')
        myObj = chooseObjectToSearch()
        searchDependancies(myObj, lspdir)

nameRegex =         b'^\s*:NAME\s+(.*)$'
refinedNameRegex1 = b'^\s*:NAME\s+"([^"]*)"$'
refinedNameRegex2 = b'^\s*:NAME\s+:([^\s]*)$'
onbRegex = b'^\s*:OBJECT-NUMBER\s+(\d+)'
__main__()