;;; expando.el --- Quickly expand macros for easy reading/checking  -*- lexical-binding: t; -*-
;; Copyright 2017-2026 by Dave Pearson <davep@davep.org>

;; Author: Dave Pearson <davep@davep.org>
;; Version: 1.6
;; Keywords: lisp
;; URL: https://github.com/davep/expando.el
;; Package-Requires: ((emacs "25.1"))

;; This program is free software: you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the
;; Free Software Foundation, either version 3 of the License, or (at your
;; option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
;; Public License for more details.
;;
;; You should have received a copy of the GNU General Public License along
;; with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; expando.el provides a simple tool for expanding macros into a different
;; window so that the expansion can be quickly and easily checked and read.

;;; Code:

(defun expando--expander (level)
  "Decide which macro expansion function to use based on LEVEL.

If LEVEL is nil, `macroexpand-1' is used. If LEVEL is 1,
`macroexpad' is used. If LEVEL is any other non-nil value,
`macroexpand-all' is used."
  (if level
      (if (and (numberp level) (= level 1))
          #'macroexpand
        #'macroexpand-all)
    #'macroexpand-1))

(define-derived-mode expando-view-mode emacs-lisp-mode "expando"
  "Major mode for viewing expanded macros.

The key bindings for `expando-view-mode' are:

\\{expando-view-mode-map}")

(defvar expando-view-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "q") #'quit-window)
    map)
  "Mode map for `expando-view-mode'.")

;;;###autoload
(defun expando-macro (&optional level)
  "Attempt to expand the expression before `point'.

By default `macroexpand-1' is used. Pass LEVEL as 1 (or prefix a
call with \\[universal-argument] and 1) to use `macroexpand'.

Pass LEVEL as 2 (or prefix a call with \\[universal-argument] and
2) to use `macroexpand-all'."
  (interactive "P")
  (let ((form (elisp--preceding-sexp)))
    (with-current-buffer-window "*Expando Macro*" nil nil
      (expando-view-mode)
      (pp (funcall (expando--expander level) form)))))

(provide 'expando)

;;; expando.el ends here
