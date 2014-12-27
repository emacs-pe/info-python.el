#!/usr/bin/env bash

set -eo pipefail

PYTHON_VERSION=${PYTHON_VERSION:-$(python -c "import sys; sys.stdout.write('%s.%s' % (sys.version_info[0], sys.version_info[1]))")}
CPYTHON_DIR="cpython-${PYTHON_VERSION}"

[ -d "${CPYTHON_DIR}" ] || wget -O- "https://github.com/python/cpython/archive/${PYTHON_VERSION}.tar.gz" | tar xz

# http://sphinx-doc.org/faq.html#texinfo-faq
# http://sphinx-doc.org/config.html#options-for-texinfo-output
cat >> "${CPYTHON_DIR}/Doc/conf.py" <<EOF
texinfo_documents = [
    ('library/index', 'python-%s' % version, 'The Python Library Reference', _stdauthor, 'Python %s' % version, 'The Python Standard Library', 'Programming', True),
]
# texinfo_appendices = [
#     'glossary',
# ]
EOF

make -C "${CPYTHON_DIR}/Doc" BUILDER=texinfo build
makeinfo --no-split "${CPYTHON_DIR}/Doc/build/texinfo/python-${PYTHON_VERSION}.texi"
