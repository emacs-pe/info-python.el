CASK       ?= cask
WGET       ?= wget
EMACS      ?= emacs
PYTHON     ?= python
SPHINXBUILD = sphinx-build
BATCH       = $(EMACS) --batch -Q -L .
BATCHC      = $(BATCH) -f batch-byte-compile

ELS  = info-python.el
ELCS = $(ELS:.el=.elc)

PYTHON_VERSION = $(shell $(PYTHON) -c "import sys; sys.stdout.write('%s.%s' % (sys.version_info[0], sys.version_info[1]))")
PYTHON_SRCDIR  = cpython-$(PYTHON_VERSION)

BUILD_DIR = build
TEXI_DIST = $(BUILD_DIR)/python-$(PYTHON_VERSION).texi
INFO_DIST = $(TEXI_DIST:.texi=.info)

export PYTHONPATH

.PHONY: all
all: install README.md

.PHONY: dist
dist: $(INFO_DIST)

.PHONY: install
install: elpa $(ELCS)

elpa: Cask
	$(CASK) install
	touch $@

$(TEXI_DIST): PYTHONPATH=$(PYTHON_SRCDIR)/Doc/tools/extensions:$(PYTHON_SRCDIR)/Doc/tools/sphinxext
$(TEXI_DIST): $(PYTHON_VERSION).stamp
	$(SPHINXBUILD) -c . -b texinfo -d $(BUILD_DIR)/$(PYTHON_VERSION).doctrees $(PYTHON_SRCDIR)/Doc $(BUILD_DIR)

$(PYTHON_VERSION).stamp:
	wget -O- "https://github.com/python/cpython/archive/$(PYTHON_VERSION).tar.gz" | tar xz
	touch $@

%.info: %.texi
	makeinfo --no-split -o $@ $<

%.elc: %.el
	$(CASK) exec $(BATCHC) $<

README.md: make-readme-markdown.el $(ELS)
	$(CASK) exec $(BATCH) --script $< <$(ELS) >$@ 2>/dev/null

make-readme-markdown.el:
	$(WGET) -q -O $@ "https://raw.github.com/mgalgs/make-readme-markdown/master/make-readme-markdown.el"

.INTERMEDIATE: make-readme-markdown.el

clean:
	$(RM) $(ELCS)
	$(RM) $(TEXI_DIST)
	$(RM) $(INFO_DIST)
	$(RM) $(PYTHON_VERSION).stamp
