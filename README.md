# align-f90

Align-f90 is my attempt to add alignment support to Fortran 90 in Emacs.

Installation:

    (require 'align-f90)
    (align-f90-load)

Then you can use the built-in align commands to align Fortran 90 (and newer)
code. I have bound the following function to M-r:

    (defun my-align-dwim ()
    (interactive)
    (if (equal mark-active nil)
       (align-current)
      (call-interactively 'align)))

    (global-set-key (kbd "M-r") 'my-align-dwim)

A list of bugs, TODO's and other comments will be kept in the align-f90.el
file.
