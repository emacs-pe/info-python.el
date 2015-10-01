CASK       ?= cask
CURL       ?= curl
EMACS       = emacs
PYTHON      = python
SPHINXBUILD = sphinx-build

EMACSFLAGS =
EMACSBATCH = $(EMACS) --batch -Q $(EMACSFLAGS)


export EMACS
export PYTHONPATH

SRCS  = info-python.el
OBJS  = $(SRCS:.el=.elc)

PYTHON_VERSION := $(shell $(PYTHON) -c "import sys; sys.stdout.write('%s.%s' % (sys.version_info[0], sys.version_info[1]))")

ifeq ($(words $(subst ., ,$(PYTHON_VERSION))),3)
  TARGZ_URL     = "https://www.python.org/ftp/python/$(PYTHON_VERSION)/Python-$(PYTHON_VERSION).tgz"
  PYTHON_SRCDIR = Python-$(PYTHON_VERSION)
else
  TARGZ_URL     = "https://github.com/python/cpython/archive/$(PYTHON_VERSION).tar.gz"
  PYTHON_SRCDIR = cpython-$(PYTHON_VERSION)
endif

BUILD_DIR = doc
TEXI_DIST = $(BUILD_DIR)/python-$(PYTHON_VERSION).texi
INFO_DIST = $(TEXI_DIST:.texi=.info)

.PHONY: all texi info compile
all: compile README.md

compile: $(OBJS)

%.elc: %.el $(PKGDIR)
	$(CASK) exec $(EMACSBATCH) -f batch-byte-compile $<

$(PKGDIR): Cask
	$(CASK) install
	touch $(PKGDIR)

dist: info
texi: $(TEXI_DIST)
info: $(INFO_DIST)

$(TEXI_DIST): PYTHONPATH=$(PYTHON_SRCDIR)/Doc/tools/extensions:$(PYTHON_SRCDIR)/Doc/tools/sphinxext
$(TEXI_DIST): $(PYTHON_VERSION).stamp
	$(SPHINXBUILD) -c . -b texinfo -d $(BUILD_DIR)/$(PYTHON_VERSION).doctrees $(PYTHON_SRCDIR)/Doc $(BUILD_DIR)

$(PYTHON_VERSION).stamp:
	$(CURL) -sSL $(TARGZ_URL) | tar xz
	touch $@

%.info: %.texi
	makeinfo --no-split -o $@ $<

README.md: el2markdown.el $(SRCS)
	$(CASK) exec $(EMACSBATCH) -l $< $(SRCS) -f el2markdown-write-readme

el2markdown.el:
	$(CURL) -sSL -o $@ "https://github.com/Lindydancer/el2markdown/raw/master/el2markdown.el"

.INTERMEDIATE: el2markdown.el

clean:
	$(RM) $(OBJS)
	$(RM) $(TEXI_DIST)
	$(RM) $(INFO_DIST)
	$(RM) $(PYTHON_VERSION).stamp
