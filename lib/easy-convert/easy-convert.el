;;; easy-convert.el --- Easy unit conversion in the minibuffer

;; Copyright 2012 Free Software Foundation, Inc.

;; Author:  <frozenlock@gmail.com>
;; Keywords: convenience

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

;; If you want to add custom units: 
;;
;; (eval-after-load "calc-units"
;;   '(progn
;;      (setq math-additional-units
;;            '((gpm "gal / min" "Gallons per minute")
;; 	     (Bohr "0.05291772083 * nm" "Atomic unit of distance")
;; 	     (ls "l / s" "Liters per second")
;; 	     (cfm "ft^3 / min" "Cubic feet per minute"))
;;            math-units-table nil)))


;;; Code:

(require 'calc-units)
(require 'ido)

(defun easy-convert (old-value-and-unit new-unit)
  "Convert a value with a unit to its equivalent in another unit"
  (calc-eval 
   (math-convert-units 
    (calc-eval old-value-and-unit 'raw) (calc-eval new-unit 'raw))))

(defun easy-convert-list-all-units ()
  "List every available units available for conversions"
  (mapcar '(lambda (arg) (symbol-name (first arg))) (append math-standard-units math-additional-units)))

(defun easy-convert-ido-list-all-units ()
  "Prompt for a unit available for conversion"
  (ido-completing-read "Units :" (easy-convert-list-all-units)))

(defun easy-convert-interactive ()
  "Convert a value to another unit. Check `calc-view-units-table'
to see every units available and to see how to write them."
  (interactive)
  (let ((temp-keymap (copy-tree minibuffer-local-map)))
    (define-key temp-keymap (kbd "C-z") '(lambda () (interactive)(insert (easy-convert-ido-list-all-units))))
    (let* ((old-value-and-unit
	    (read-from-minibuffer "Old value and unit (type C-z for unit list) : " nil temp-keymap))
	   (new-unit (read-from-minibuffer
		      (concat "Convert " old-value-and-unit " to unit (type C-z for unit list) : ") nil temp-keymap)))
      (message (concat old-value-and-unit " converted to " new-unit " = " 
		       (easy-convert old-value-and-unit new-unit))))))

(provide 'easy-convert)
;;; easy-convert.el ends here
