"""
Database and output locations for Hecatomb
Ensures consistent variable names and file locations for the pipeline.
"""


### OUTPUT DIRECTORY
if config['Output'] is None:
    OUTPUT = 'Emu_Output'
else:
    OUTPUT = config['Output']


### OUTPUT DIRs
LOGS = os.path.join(OUTPUT, 'LOGS')
TMP = os.path.join(OUTPUT, 'TMP')
EMU = os.path.join(OUTPUT, 'EMU')
KRONA = os.path.join(OUTPUT, 'KRONA')
NANOPLOT = os.path.join(OUTPUT, 'NANOPLOT')








