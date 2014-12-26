;;; info-python.el --- Info support for the Python Standard Library. -*- lexical-binding: t -*-

;; Copyright © 2014 Mario Rodas <marsam@users.noreply.github.com>

;; Author: Mario Rodas <marsam@users.noreply.github.com>
;; URL: https://github.com/emacs-pe/info-python.el
;; Keywords: convenience
;; Version: 0.0.1
;; Package-Requires: ((emacs "24.3"))

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
;; Currently uses sphinx [texinfo builder][] to build the texinfo.
;;
;;; Setup
;; Add to your `init.el' the following:
;;
;;     (require 'info-python)
;;     (info-python-update)
;;
;;; TODO
;; + [ ] Improve function to update `info-lookup-alist'
;;       + Support python submodules.
;; + [ ] Add support for different python versions.
;; + [ ] Add support for python virtualenv.
;;
;; [texinfo builder]: http://sphinx-doc.org/builders.html#module-sphinx.builders.texinfo

;;; Code:

(require 'info-look)
(require 'python)

(defgroup info-python nil
  "Info support for the Python Standard Library."
  :prefix "info-python-"
  :group 'applications)

(defun info-python--executable-version ()
  "Calculate current python executable version."
  (let* ((process-environment (python-shell-calculate-process-environment))
         (exec-path (python-shell-calculate-exec-path))
         (python-exec (executable-find python-shell-interpreter))
         (python-args "-c \"import sys; sys.stdout.write('%s.%s' % (sys.version_info[0], sys.version_info[1]))\"")
         (python-version (shell-command-to-string (format "%s %s" python-exec python-args))))
    (if (= (length python-version) 3)
        python-version
      (error python-version))))

;;;###autoload
(defun info-python-update (&optional maybe)
  "Load info to `info-lookup-alist'"
  (interactive (list (y-or-n-p "Update maybe? ")))
  (info-lookup-add-help* maybe
                         :mode 'python-mode
                         :doc-spec '(("(python-2.7.info)Index"))))

(provide 'info-python)

;;; info-python.el ends here
