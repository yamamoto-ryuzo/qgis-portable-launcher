import os

def version():
    metadata = os.path.abspath(os.path.join(__file__, '..', 'metadata.txt'))
    with open(metadata) as f:
        for line in f.readlines():
            if line.startswith('version='):
                return line.split('=')[1].strip()
