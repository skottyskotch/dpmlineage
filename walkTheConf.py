import argparse
import os
import re

parser = argparse.ArgumentParser()
parser.add_argument("lspdir", help="lsp directory name (path/to/diffDPM/UNDEFINED)")
args = parser.parse_args()

class objectType:
    instances = {}
    def __init__(self, name):
        self.objectType = name
        self.named = False
        self.regex = b''
        self.objects = []
        objectType.instances[self.objectType] = self


def findNames():
    if os.path.isdir(args.lspdir):
        regex = re.compile(nameRegex, re.MULTILINE)
        refinedRegex1 = re.compile(refinedNameRegex1, re.MULTILINE)
        refinedRegex2 = re.compile(refinedNameRegex2, re.MULTILINE)
        for root, dirs, files in os.walk(args.lspdir, topdown=False):
            for name in dirs:
                objectType(name)
                for file in os.listdir(os.path.join(root,name)):
                    with open(os.path.join(root, name, file), 'rb') as lsp:
                        lspText = lsp.read()
                        if len(re.findall(regex,lspText)) > 0:
                            objectType.instances[name].named = True
                        if len(re.findall(refinedRegex1,lspText)) > 0:
                            objectType.instances[name].regex = '<:NAME "OBJECT_NAME">'
                            objectName = re.findall(refinedRegex1,lspText)[0]
                            objectType.instances[name].objects.append(objectName)
                        elif len(re.findall(refinedRegex2,lspText)) > 0:
                            objectType.instances[name].regex = '<:NAME :OBJECT_NAME>'
                            objectName = re.findall(refinedRegex2,lspText)[0]
                            objectType.instances[name].objects.append(objectName)
    else:
        print(args.lspdir)
        print('not a dir')

def __main__():
    print('Find the names of the objects')                        
    # print ('regex: ' + nameRegex.decode('utf-8'))
    findNames()
    print('Ignored:')
    print('\n'.join(['\t'  + key for key, value in objectType.instances.items() if value.named == False]))
    print('Parsed:')
    print('\n'.join(['\t' + str(len(value.objects)) + '\t' + str(value.regex) + '\t' + key for key, value in objectType.instances.items() if value.named == True]))

nameRegex =        b'^\s*:NAME\s+(.*)$'
refinedNameRegex1 = b'^\s*:NAME\s+"([^"]*)"$'
refinedNameRegex2 = b'^\s*:NAME\s+:([^\s]*)$'

__main__()