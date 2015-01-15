;;; info-python.el --- Info support for the Python Standard Library. -*- lexical-binding: t -*-

;; Copyright © 2014 Mario Rodas <marsam@users.noreply.github.com>

;; Author: Mario Rodas <marsam@users.noreply.github.com>
;; URL: https://github.com/emacs-pe/info-python.el
;; Keywords: convenience
;; Version: 0.0.1
;; Package-Requires: ((emacs "24"))

;; This file is NOT part of GNU Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;; [![Travis build status](https://travis-ci.org/emacs-pe/info-python.el.png?branch=master)](https://travis-ci.org/emacs-pe/info-python.el)
;;
;; `info-python' provides navigation and search of the info version of
;; the [Python Library Reference][] documentation.
;;
;;; Setup:
;; Choose an info file for your python version from the releases page:
;; https://github.com/emacs-pe/info-python.el/releases and install it
;; somewhere in your INFOPATH:
;;
;;     $ sudo cp python-2.7.info /usr/share/info
;;     $ sudo install-info --info-dir=/usr/share/info python-2.7.info
;;
;; Dump `info-python.el' in your `load-path' somewhere, and add the
;; following code to your `user-init-file' (init.el):
;;
;;     (require 'info-python)
;;
;;     ;; remember to use the complete info filename.
;;     (eval-after-load "info-python"
;;       '(info-python-load "python-2.7.info"))
;;
;;; Related Projects:
;; + [pydoc-info](https://bitbucket.org/jonwaltman/pydoc-info/).
;;
;;   Besides the intallation of the info files, (I think) you can use
;;   `pydoc-info' and `info-python' interchangeably.  **Disclaimer**:
;;   I actually found this project after I wrote the basis of this
;;   package.
;;
;;; Features:
;; + `info-lookup-symbol' (C-h S) support for python mode.
;;
;;; Build info:
;; Currently uses Sphinx [texinfo builder][] to create the info
;; file. The build script **doesn't check the minor version of
;; python** and can build the info documentation for Python>2.5:
;;
;; 1. Clone https://github.com/emacs-pe/info-python.el
;;
;; 2. Install Sphinx:
;;
;;         $ pip install -U 'Sphinx>=1.1'
;;
;; 3. For Python **without minor version** (e.g "3.2"):
;;
;;         $ make PYTHON_VERSION=3.2 dist
;;
;;    For Python **with the minor version** (e.g "2.7.1"), You need to
;;    modify the url of Makefile to download the sources from the Python
;;    website, and build it through:
;;
;;         $ make PYTHON_VERSION=2.7.1 dist
;;
;; [texinfo builder]: http://sphinx-doc.org/builders.html#module-sphinx.builders.texinfo
;; [Python Library Reference]: https://docs.python.org/library/
;;
;;; Code:

(require 'info-look)
(require 'python)

;;; Shamelessly based on `pydoc-info' transform entry function.
(defun info-python--lookup-transform-entry (item)
  "Transform a Python index entry to a help ITEM."
  (let* ((py-re "\\([[:alnum:]_.]+\\)(?)?"))
    (cond
     ;; foo.bar --> foo.bar
     ((string-match (concat "\\`" py-re "\\'") item)
      item)
     ;; keyword; foo --> foo
     ;; statement; foo --> foo
     ((string-match (concat "\\`\\(keyword\\|statement\\);? " py-re) item)
      (replace-regexp-in-string " " "." (match-string 2 item)))
     ;; foo (built-in ...) --> foo
     ((string-match (concat "\\`" py-re " (built-in .+)") item)
      (replace-regexp-in-string " " "." (match-string 1 item)))
     ;; foo.bar (module) --> foo.bar
     ((string-match (concat "\\`" py-re " (module)") item)
      (replace-regexp-in-string " " "." (match-string 1 item)))
     ;; baz (in module foo.bar) --> foo.bar.baz
     ((string-match (concat "\\`" py-re " (in module \\(.+\\))") item)
      (replace-regexp-in-string " " "." (concat (match-string 2 item) " "
                                                (match-string 1 item))))
     ;; Bar (class in foo.bar) --> foo.bar.Bar
     ((string-match (concat "\\`" py-re " (class in \\(.+\\))") item)
      (replace-regexp-in-string " " "." (concat (match-string 2 item) " "
                                                (match-string 1 item))))
     ;; bar (foo.Foo method) --> foo.Foo.bar
     ((string-match
       (concat "\\`" py-re " (\\(.+\\) \\(method\\|attribute\\))") item)
      (replace-regexp-in-string " " "." (concat (match-string 2 item) " "
                                                (match-string 1 item))))
     ;; foo (C ...) --> foo
     ((string-match (concat "\\`" py-re " (C .*)") item)
      (match-string 1 item))
     ;; operator; foo --> foo
     ((string-match "\\`operator; \\(.*\\)" item)
      (match-string 1 item))
     ;; Python Enhancement Proposals; PEP XXX --> PEP XXX
     ((string-match "\\`Python Enhancement Proposals; \\(PEP .*\\)" item)
      (match-string 1 item))
     ;; RFC; RFC XXX --> RFC XXX
     ((string-match "\\`RFC; \\(RFC .*\\)" item)
      (match-string 1 item))
     (t
      item))))

(defun info-python-load (info)
  "Load python INFO to `info-lookup-alist'."
  (info-lookup-reset)
  (info-lookup-add-help :mode 'python-mode
			:parse-rule 'python-info-current-symbol
			:doc-spec (list
				   (list (format "(%s)Index" info) 'info-python--lookup-transform-entry)
				   (list (format "(%s)Python Module Index" info) 'info-python--lookup-transform-entry))))

(provide 'info-python)

;;; info-python.el ends here
