# -*- coding: utf-8 -*-
import os
import sys
import time

_stdauthor = r'Guido van Rossum\\and the Python development team'

# XXX: The `pyspecific' package live inside CPYTHON_SRC/Doc/tools/sphinxext
extensions = ['sphinx.ext.coverage',
              'sphinx.ext.doctest',
              'pyspecific']

project = 'Python'
copyright = '1990-%s, Python Software Foundation' % time.strftime('%Y')

today = ''
_stdauthor = r'Guido van Rossum\\and the Python development team'
today_fmt = '%B %d, %Y'
refcount_file = 'data/refcounts.dat'
python_version = os.getenv('PYTHON_VERSION', '%s.%s' % (sys.version_info[0], sys.version_info[1]))
texinfo_documents = [
    ('library/index', 'python-%s' % python_version, 'The Python Library Reference', _stdauthor, 'Python', 'The Python Standard Library', 'Programming', True),
]
texinfo_appendices = [
    'glossary',
    'about',
]
