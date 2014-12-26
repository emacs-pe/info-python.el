CASK  ?= cask
WGET  ?= wget
EMACS ?= emacs
BATCH  = $(EMACS) --batch -Q -L .
BATCHC = $(BATCH) -f batch-byte-compile

ELS  = info-python.el
ELCS = $(ELS:.el=.elc)

.PHONY: all
all: install README.md

.PHONY: install
install: elpa $(ELCS)

elpa: Cask
	$(CASK) install
	touch $@

build-info:
	./build.sh

%.elc: %.el
	$(CASK) exec $(BATCHC) $<

README.md: make-readme-markdown.el $(ELS)
	$(CASK) exec $(BATCH) --script $< <$(ELS) >$@ 2>/dev/null

make-readme-markdown.el:
	$(WGET) -q -O $@ "https://raw.github.com/mgalgs/make-readme-markdown/master/make-readme-markdown.el"

.INTERMEDIATE: make-readme-markdown.el

clean:
	$(RM) $(ELCS)
