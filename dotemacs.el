(defun add-to-load-path (path) 
  (add-to-list 'load-path path))

(defun abspath (path) 
  ;; Get the absolute path under user-emacs-directory
  (let ((default-directory user-emacs-directory))
;;  (let ((default-directory (file-name-directory load-file-name)))
    (file-truename path)))

;; font
(set-default-font 
 "-unknown-Liberation Mono-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1")


;; package
(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

;; elpy
;; see "./lib/elpy/README.md" for full install instructions
(elpy-enable)
(elpy-use-ipython)

;; color-theme
(add-to-load-path (abspath "./lib/color-theme"))
(require 'color-theme)
(eval-after-load "color-theme" 
  '(progn
     (add-to-list 'custom-theme-load-path 
		  (abspath "./lib/emacs-color-theme-solarized"))
     (add-to-list 'custom-theme-load-path 
		  (abspath "./lib/zenburn-emacs"))
     (color-theme-initialize)
     (load-theme 'zenburn)))

;; markdown-mode
(add-to-load-path (abspath "./lib/markdown-mode"))
(autoload 'markdown-mode "markdown-mode" 
  "major mode for editing markdown files" t)

;; nxhtml-mode
(load (abspath "./lib/nxhtml/autostart.el"))

;; ido-mode
(ido-mode)

;; magnars modes
;; multiple-cursors
(add-to-load-path (abspath "./lib/multiple-cursors.el"))
(require 'multiple-cursors)

;; expand-region
(add-to-load-path (abspath "./lib/expand-region.el"))
(require 'expand-region)


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

;; multiple-cursors
(global-set-key (kbd "M-n M-n") 'mc/edit-lines)
(global-set-key (kbd "M-n C-n") 'mc/mark-next-like-this)
(global-set-key (kbd "M-n C-p") 'mc/mark-previous-like-this)
(global-set-key (kbd "M-n C-x h") 'mc/mark-all-like-this)
(global-set-key (kbd "M-n q") 'mc/keyboard-quit)
(global-set-key (kbd "M-n m n") 'mc/mark-next-lines)

;; expand-region
(global-set-key (kbd "C-@") 'er/expand-region)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("dd4db38519d2ad7eb9e2f30bc03fba61a7af49a185edfd44e020aa5345e3dca7" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
