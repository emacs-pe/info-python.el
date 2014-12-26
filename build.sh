#!/usr/bin/env bash

set -eo pipefail

python_version=$(python -c "import sys; sys.stdout.write('%s.%s' % (sys.version_info[0], sys.version_info[1]))")
cpython_dir="cpython-${python_version}"

[ -d "${cpython_dir}" ] || wget -O- "https://github.com/python/cpython/archive/${python_version}.tar.gz" | tar xz

# http://sphinx-doc.org/faq.html#texinfo-faq
# http://sphinx-doc.org/config.html#options-for-texinfo-output
cat >> "${cpython_dir}/Doc/conf.py" <<EOF
texinfo_documents = [
    ('library/index', 'python-%s' % version, 'The Python Library Reference', _stdauthor, 'Python %s' % version, 'The Python Standard Library', 'Programming', True),
]
# texinfo_appendices = [
#     'glossary',
# ]
EOF

make -C "${cpython_dir}/Doc" BUILDER=texinfo build
makeinfo --no-split "${cpython_dir}/Doc/build/texinfo/python-${python_version}.texi"
