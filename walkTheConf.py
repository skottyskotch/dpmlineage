import argparse
import os
import re
import inquirer # non-standard module required 'pip install inquirer'
import pandas as pd

parser = argparse.ArgumentParser()
parser.add_argument("lspdir", help="lsp directory name (path/to/diffDPM/UNDEFINED)")
parser.add_argument("-c", "--choose", action='store_true', help="prompt for selection of one object to search callers")
parser.add_argument("-i", "--info", action='store_true', help="display information on regexp matching Names in lsps")
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
    def __init__(self, nOnb, oObjectType, path, text):
        self.onb = nOnb
        self.name = b''
        self.path = path
        self.objectType = oObjectType
        self.text = text
        self.callers = []
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
                        myObj = objectLsp(int(objectOnb.decode('utf-8')), myObjectType, os.path.join(root, name, file), lspText)
                        if len(re.findall(regexA,lspText)) > 0:
                            objectType.instances[name].named = True
                            objectName = b''
                            if len(re.findall(refinedRegex1,lspText)) > 0:
                                objectType.instances[name].regex = '<:NAME "OBJECT_NAME">'
                                objectName = re.findall(refinedRegex1,lspText)[0]
                            elif len(re.findall(refinedRegex2,lspText)) > 0:
                                objectType.instances[name].regex = '<:NAME :OBJECT_NAME>'
                                objectName = re.findall(refinedRegex2,lspText)[0]
                            myObj.name = objectName
    else:
        print(lspdir)
        print('not a dir')
        return False

    if args.info:
        print(':NAME not found:')
        print('\n'.join(['\t' + str(len(value.objects)) + '\t' + key                            for key, value in objectType.instances.items() if value.named == False]))
        print(':NAME parsed:')
        print('\n'.join(['\t' + str(len(value.objects)) + '\t' + str(value.regex) + '\t' + key  for key, value in objectType.instances.items() if value.named == True]))
        print('number of objects: ' + str(len(list(objectLsp.instances.keys()))))
        input('Type Enter to continue...')
        os.system('cls')
    return True

def chooseObjectToSearch():
    bContinue = True
    sChosenClass = ''
    while bContinue:
        questions = [inquirer.Checkbox(
            'class',
            message="Select one class",
            choices=[value.name + ' (' + str(len(value.objects)) + ')' for key, value in objectType.instances.items()],
            carousel=True
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
            carousel=True
        )]
        answers = inquirer.prompt(questions)  # returns a dict
        if len(answers['object']) == 1:
            bContinue = False
            sChosenOnb = re.findall('\((\d+)\)',answers['object'][0])[0]
            os.system('cls')
            return objectLsp.instances[int(sChosenOnb)]
        else:
            print('Please select only one object')

def searchDependancies(obj, verbose):
    callers = []
    for otherObj in list(objectLsp.instances.values()):
        if obj.onb != otherObj.onb:
            if len(re.findall(str(obj.onb).encode('utf-8'), otherObj.text)) > 0:
                if verbose:
                    print('onb found in ' + otherObj.path)
                callers.append(otherObj)
            if obj.objectType.named == True and len(re.findall(obj.name, otherObj.text)) > 0:
                if verbose:
                    print('name found in ' + otherObj.path)
                callers.append(otherObj)
    obj.callers = callers

def dumpCallers():
    onbs = list(objectLsp.keys())
    data = {'ONB': onbs,
            'NAME': [objectLsp[x].name for x in onbs],
            'CALLERS': [','.join(objectLsp[x].callers) for x in onbs]}
    df = pd.DataFrame(data)
    df.to_csv('callers.csv')

def __main__():
    print('Find the names of the objects')
    lspdir = args.lspdir
    if findNames(lspdir):
        if args.choose:
            print('Search callers for one object')
            myObj = chooseObjectToSearch()
            print(myObj.objectType.name + ' object "' + myObj.name.decode('utf-8') + '" ('+ str(myObj.onb) +') searched in the conf')
            searchDependancies(myObj, True)
            print('\n'+str(len(myObj.callers)) + ' callers:')
            print('\n'.join([x.objectType.name + '\t' + str(x.onb) for x in myObj.callers]))
        else:
            i = 0
            for obj in list(objectLsp.instances.values()):
                i += 1
                print('searching dependencies ' + str(i) + '/' + str(len(list(objectLsp.instances.values()))), end = '\r')
                searchDependancies(obj, False)
            dumpCallers()

nameRegex =         b'^\s*:NAME\s+(.*)$'
refinedNameRegex1 = b'^\s*:NAME\s+"([^"]*)"$'
refinedNameRegex2 = b'^\s*:NAME\s+:([^\s]*)$'
onbRegex = b'^\s*:OBJECT-NUMBER\s+(\d+)'
__main__()