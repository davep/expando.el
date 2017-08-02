;;; expando.el --- Quickly expand macros for easy reading/checking
;; Copyright 2017 by Dave Pearson <davep@davep.org>

;; Author: Dave Pearson <davep@davep.org>
;; Version: 1.4
;; Keywords: lisp
;; URL: https://github.com/davep/expando.el

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
;; window so they can be quickly and easily checked and read.
;;
;; NOTE: This code makes use of `elisp--preceding-sexp' from elisp-mode.
;; This is, obviously, considered to be an "internal" function. Which is a
;; bit of shame really as it's a very handy thing that I think we'd normally
;; want to be doing in elisp, when doing elisp-oriented things. So, rather
;; than reinvent the wheel, I'll risk calling an internal and worry later
;; when things get broken.

;;; Code:

(defun expando-expander (level)
  "Decide which macro expansion function to use based on LEVEL.

If LEVEL is nil, `macroexpand-1' is used. If LEVEL is 1,
`macroexpad' is used. If LEVEL is any other non-nil value,
`macroexpand-all' is used."
  (if level
      (if (and (numberp level) (= level 1))
          #'macroexpand
        #'macroexpand-all)
    #'macroexpand-1))

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
      (emacs-lisp-mode)
      (pp (funcall (expando-expander level) form)))))

(provide 'expando)

;;; expando.el ends here
