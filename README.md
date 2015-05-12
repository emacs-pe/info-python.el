# info-python - Info support for the Python Standard Library. -*- lexical-binding: t -*-

*Author:* Mario Rodas <marsam@users.noreply.github.com><br>
*Version:* 0.0.1<br>

[![Travis build status](https://travis-ci.org/emacs-pe/info-python.el.png?branch=master)](https://travis-ci.org/emacs-pe/info-python.el)

`info-python` provides navigation and search of the info version of
the [Python Library Reference][] documentation.

## Features

+ `info-lookup-symbol`: <kbd>C-h S</kbd> support for `python.el`.

## Installation

### Using `package.el` (recommended)

You need to add emacs-pe archive to your `package-archives`:

       (add-to-list 'package-archives
                    '("emacs-pe" . "https://emacs-pe.github.io/packages/"))

and install it trough `M-x package-install RET info-python`.
Or through [use-package][]:

       (use-package info-python
        :ensure t
        :pin emacs-pe)

### Manually

You need to download the info files from
https://github.com/emacs-pe/info-python.el/releases and install it
somewhere in your INFOPATH:

    $ sudo cp python-2.7.info /usr/share/info
    $ sudo install-info --info-dir=/usr/share/info python-2.7.info

Dump `info-python.el` in your `load-path` somewhere, and add the
following code to your init.el:

       (require 'info-python)
       ;; Add your installed info files for `python.el`
       (info-python-load "python-2.7.info" "django.info" "flycheck")

## Related Projects

+ [pydoc-info](https://bitbucket.org/jonwaltman/pydoc-info/).

  Besides the intallation of the info files, (I think) you can use
  `pydoc-info` and `info-python` interchangeably.  **Disclaimer**:
  I actually found this project after I wrote the basis of this
  package.

## Build texinfo

Currently uses Sphinx [texinfo builder][] to create the texinfo
file and can build the info documentation for Python >= 2.6:

1. Clone https://github.com/emacs-pe/info-python.el

2. Install Sphinx:

        $ pip install -U 'Sphinx>=1.1'

3. Build texinfo file:

        $ make PYTHON_VERSION=3.2 dist

[use-package]: https://github.com/jwiegley/use-package "A use-package declaration for simplifying your .emacs"
[texinfo builder]: http://sphinx-doc.org/builders.html#module-sphinx.builders.texinfo
[Python Library Reference]: https://docs.python.org/library/ "The Python Library Reference"


---
Converted from `info-python.el` by [*el2markdown*](https://github.com/Lindydancer/el2markdown).
