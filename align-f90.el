;; Description: Alignment rules for Fortran 90
;; Author: Jannis Teunissen
;; Copyright (C) 2016 by Jannis Teunissen
;; Last-Updated: Thu Apr 21 19:24:46 2016 (+0200)
;;
;; Usage:
;; (require 'align-f90)
;; (align-f90-load)
;;
;; Then you can call align-current to align the current region.
;;
;; Supported features:
;; Alignment of declarations (those that use ::) and assignments in the current
;; "region". Regions are separated by empty lines or Fortran keywords such as
;; do, subroutine, end etc.
;;
;; TODO:
;; - Incorporate support for labels in regexps
;;
;;; Change Log:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or (at
;; your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar align-f90-modes '(f90-mode))

(defvar align-f90-region-separators
                    (concat
                     "\\(^\\s-*$\\|" ; Empty line
                     "^\\s-*do\\b\\|" ; Fortran keywords for blocks
                     "^\\s-*end\\|"
                     "^\\s-*else\\b\\|"
                     "^\\s-*block\\b\\|"
                     "^\\s-*program\\b\\|"
                     "^\\s-*module\\b\\|"
                     "^\\s-*submodule\\b\\|"
                     "^\\s-*function\\b\\|"
                     "^\\s-*subroutine\\b\\|"
                     "^\\s-*interface\\b\\|"
                     "^\\s-*type\s-+[^(]\\|"
                     "^\\s-*use\\b\\|"
                     "^\\s-*if\\b\\|"
                     "^\\s-*where\\b\\|"
                     "^\\s-*case\\b\\|"
                     "^\\s-*forall\\b\\|"
                     "^\\s-*select\\b\\)")
                    "A list of block delimiters in F90")

(defun align-f90-load ()
  "Enable F90 alignment"
  (interactive)

  ;; Auto load align rules
  (eval-after-load 'align
    '(align-f90-add-rules))

  ;; Add hook to set the region separators
  (add-hook 'f90-mode-hook 'align-f90-region-hook))

(defun align-f90-region-hook ()
  (make-local-variable 'align-region-separate)
  (setq align-region-separate align-f90-region-separators))

(defun align-f90-add-rules ()
  "Add F90 align rules"

  (add-to-list 'align-rules-list
               '(f90-assignment
                 (regexp . "[^=<>/ 	\n]\\(\\s-*[=<>/]*\\)=[>]?\\(\\s-*\\)\\([^= 	\n]\\|$\\)")
                 (group 1 2)
                 (modes . align-f90-modes)
                 (justify . t)))

  (add-to-list 'align-rules-list
               '(f90-declaration
                 (regexp . "[^ 	\n]\\(\\s-*\\)::\\(\\s-*\\)\\([^ 	\n]\\|$\\)")
                 (group 1 2)
                 ;; (separate . "entire")
                 (modes . align-f90-modes)
                 (justify . t)))

  (add-to-list 'align-rules-list
               '(f90-comment
                 (regexp . "[^ 	\n]\\(\\s-*\\)\\(!.*\\)$")
                 (modes . align-f90-modes)))

  (add-to-list 'align-exclude-rules-list
               '(exc-f90-func-params
                (regexp . "(\\([^)\n]+\\))")
                (repeat . t)
                (modes . align-f90-modes)))

  (add-to-list 'align-exclude-rules-list
               '(exc-f90-macro
                (regexp . "^\\s-*#\\s-*\\(if\\w*\\|elif\\|endif\\)\\(.*\\)$")
                (group . 2)
                (modes . align-f90-modes)))

  (add-to-list 'align-exclude-rules-list
               '(exc-f90-do-loops
                 (regexp . "^\\s-*do\\b\\(.+\\)$")
                 (modes . align-f90-modes)))

  (add-to-list 'align-exclude-rules-list
               '(exc-f90-comment
                 (regexp . "!\\(.+\\)$")
                 (modes . align-f90-modes))))

(provide 'align-f90)
