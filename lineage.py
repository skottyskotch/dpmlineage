import gzip
import argparse
import os
import re

class TableDef:
    instances = {}
    def __init__(self,sTableDef):
        regex = re.compile(b'([^\s]+)$',re.MULTILINE)
        self.id  = re.findall(regex,sTableDef)[0]
        regex = re.compile(b'^:NAME \"([^\"]+)',re.MULTILINE)
        self.name = re.findall(regex,sTableDef)[0]
        regex = re.compile(b'^:TABLE-INDEX \(([^\)]+)',re.MULTILINE)
        self.tableIndex = re.findall(regex,sTableDef)[0]
        # regex = re.compile(b'^:OTHER-INDEXES \(\(([^\"]+)',re.MULTILINE)
        self.otherIndex = re.findall(regex,sTableDef)[0]
        self.text = sTableDef
        TableDef.instances[self.id] = self

parser = argparse.ArgumentParser()
parser.add_argument("filename", help="Dpm file name (*.dpm.gz)")
args = parser.parse_args()

if (os.path.isfile(args.filename)):
    hTableDef = {}
    sTableDef = b''
    with gzip.open(args.filename, 'rb') as dpm:
        sDpm = dpm.read()
        lTableDef = re.split(b"\(:TABLE-DEF ",sDpm)[1:-1]
for sTableDef in lTableDef:
    TableDef(sTableDef)