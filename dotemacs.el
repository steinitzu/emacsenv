(defun add-to-load-path (path) 
  (add-to-list 'load-path path))

(defun abspath (path) 
  ;; Get the absolute path under user-emacs-directory
  (let ((default-directory user-emacs-directory))
;;  (let ((default-directory (file-name-directory load-file-name)))
    (file-truename path)))

;; package
(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/") t)

;; color-theme
(add-to-load-path (abspath "./lib/color-theme"))
(require 'color-theme)
(eval-after-load "color-theme" 
  '(progn
     (add-to-list 'custom-theme-load-path 
		  (abspath "./lib/emacs-color-theme-solarized"))
     (color-theme-initialize)
     ;;(load-theme 'solarized-dark t)
     (color-theme-hober)))

;; markdown-mode
(add-to-load-path (abspath "./lib/markdown-mode"))
(autoload 'markdown-mode "markdown-mode" 
  "major mode for editing markdown files" t)

;; nxhtml-mode
(load (abspath "./lib/nxhtml/autostart.el"))

;; ido-mode
(ido-mode)

;; auto-mode-alist
;; assign file types to specific modes
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; utility functions
(defun find-emacs-init-file () 
  "Open the emacs init file in current window" 
  (interactive)
  (find-file (abspath "./dotemacs.el")))

(defun switch-to-scratch () 
  "go to the *scratch* buffer"
  (interactive)
  (switch-to-buffer "*scratch*"))

;; global-key-bindings  
(global-set-key (kbd "<f8>") 'find-emacs-init-file)
(global-set-key (kbd "<f9>") 'switch-to-scratch)
(global-set-key (kbd "<f2>") 'visit-ansi-term)

(global-set-key (kbd "M-s s") 'replace-string)
(global-set-key (kbd "M-s r") 'replace-regexp)
(global-set-key (kbd "M-s M-s") 'query-replace)
(global-set-key (kbd "M-s M-r") 'query-replace-regexp)

(global-set-key (kbd "M-g o") 'occur)
(global-set-key (kbd "M-g M-o") 'multi-occur-in-matching-buffers)

(global-set-key (kbd "M-g s") 'magit-status)
(global-set-key (kbd "C-x 4 o") 'wrap-to-fill-column-mode)

(global-set-key (kbd "C-c #") 'comment-region)
(global-set-key (kbd "C-c C-#") 'uncomment-region)
