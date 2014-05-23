(defun add-to-load-path (path) 
  (add-to-list 'load-path path))

(defun initabspath (path) 
  ;; Get the absolute path under user-emacs-directory
  (let ((default-directory user-emacs-directory))
;;  (let ((default-directory (file-name-directory load-file-name)))
    (file-truename path)))

;; source: http://steve.yegge.googlepages.com/my-dot-emacs-file
(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file name new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

;; font
(set-default-font 
 "-unknown-Liberation Mono-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1")

;; hide menu bar
(menu-bar-mode -1)
(tool-bar-mode -1)

;; package
(require 'package)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives 
	     '("elpy" . "http://jorgenschaefer.github.io/packages/"))
(package-initialize)

;; elpy
;; see "./lib/elpy/README.md" for full install instructions
(elpy-enable)
;; (elpy-use-ipython)


(add-to-load-path (initabspath "./lib"))

;; python
(defun py-occur-doc ()
  "show occur of classes, function defs, docstrings n such. (a bit broken)"
  (interactive)
  (setq spattern "\\(^def .+\\)\\|\\( +def .+\\)\\|\\(^class .+\\)\\|\\(\"\"\".+\"\"\"\\)\\|\\(^[_A-Z].+=\\)")
  (setq list-matching-lines-face nil)
  (occur spattern))

;; easy-convert (units)
(add-to-load-path (initabspath "./lib/easy-convert"))
(require 'easy-convert)
(global-set-key (kbd "C-c u") (quote easy-convert-interactive))



;; markdown-mode
(add-to-load-path (initabspath "./lib/markdown-mode"))
(autoload 'markdown-mode "markdown-mode" 
  "major mode for editing markdown files" t)

;; nxhtml-mode
(load (initabspath "./lib/nxhtml/autostart.el"))
(require 'jinja)

(add-to-list 'auto-mode-alist '("\\.jinja2$" . nxhtml-mode))

;; nxml
;; html5-el
(add-to-load-path (initabspath "./lib/html5-el"))
(eval-after-load "rng-loc"
  '(add-to-list 'rng-schema-locating-files "~/code/html5-el/schemas.xml"))

(require 'whattf-dt)

;; (add-to-list 'auto-mode-alist
;; 	     (cons (concat "\\." (regexp-opt '("xml" "html" "htm") t) "\\'")
;; 		   'nxml-mode))

;; ido-mode
(ido-mode)

;; php-mode
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))

(defun php-insert-open-tag () 
(interactive)
(insert "<?php"))

(defun php-insert-close-tag () 
(interactive)
(insert "?>"))
(add-hook 'php-mode-hook 
	  '(lambda () 
	     (define-key php-mode-map "\M-o" 'php-insert-open-tag)))
(add-hook 'php-mode-hook 
	  '(lambda () 
	     (define-key php-mode-map "\M-p" 'php-insert-close-tag)))

;; yaml-mode
(add-to-load-path (initabspath "./lib/yaml-mode"))
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))
(add-hook 'yaml-mode-hook 
	  '(lambda () 
	     (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; chuck-mode
(add-to-load-path (initabspath "./lib/chuck-mode"))
(require 'chuck-mode)

;; magit-mode
(defun magit-stage-all-also-untracked () 
  (interactive)
  (magit-stage-all t))

;; midnight-mode
(require 'midnight)
(midnight-delay-set 'midnight-delay "4:30am")

;; smart-mode-line
(add-to-load-path (initabspath "./lib/smart-mode-line"))
(require 'smart-mode-line)
(if after-init-time (sml/setup)
  (add-hook 'after-init-hook 'sml/setup))

;; magnars modes
;; multiple-cursors
(add-to-load-path (initabspath "./lib/multiple-cursors.el"))
(require 'multiple-cursors)

;; expand-region
(add-to-load-path (initabspath "./lib/expand-region.el"))
(require 'expand-region)

;; term

(add-hook 'term-mode-hook 
	  (lambda ()	    
	    (define-key term-raw-map 
	      (kbd "C-y") 'term-paste)
	    (define-key term-raw-map 
	      (kbd "C-<backspace>") 'term-send-raw-meta)))  

(defun visit-ansi-term ()
  (interactive)
  (let ((is-term (string="term-mode" major-mode))
	(is-running (term-check-proc (buffer-name)))
	(term-cmd "/bin/bash")
	(anon-term (get-buffer "*ansi-term*")))
    (if is-term
	(if is-running
	    (if (string="*ansi-term*" (buffer-name))
		(call-interactively 'rename-buffer)
	      (if anon-term
		  (switch-to-buffer "*ansi-term*")
		(ansi-term term-cmd)))
	  (kill-buffer (buffer-name))
	  (ansi-term term-cmd))
      (if anon-term
	  (if (term-check-proc "*ansi-term*")
	      (switch-to-buffer "*ansi-term*")
	    (kill-buffer "*ansi-term*")
	    (ansi-term term-cmd))
	(ansi-term term-cmd)))))

;;;; Start a dummy terminal buffer and kill it 
;;;; to load all term-mode functions
(ansi-term "/bin/bash" "tempterminal")
(defun volatile-kill-buffer (buffername) 
  "kill buffer unconditionally"
  (set-process-query-on-exit-flag (get-buffer-process buffername) nil)
  (let ((buffer-modified-p nil))
    (kill-buffer buffername)))
(volatile-kill-buffer "*tempterminal*")

;; some cool hooks

;; auto make-directory when saving buffer in non-existant dir
(add-hook 'before-save-hook 
          (lambda () 
            (when buffer-file-name 
              (let ((dir (file-name-directory buffer-file-name)))
                (when (and (not (file-exists-p dir))
                           (make-directory dir t)))))))




;; auto-mode-alist
;; assign file types to specific modes
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; utility functions
(defun find-emacs-init-file () 
  "Open the emacs init file in current window" 
  (interactive)
  (find-file (initabspath "./dotemacs.el")))

(defun switch-to-scratch () 
  "go to the *scratch* buffer"
  (interactive)
  (switch-to-buffer "*scratch*"))

(defun select-next-window ()
  (interactive)
  (select-window (next-window)))

(defun select-previous-window ()
  (interactive)
  (select-window (previous-window)))

;; global-key-bindings  
(global-set-key (kbd "<f8>") 'find-emacs-init-file)
(global-set-key (kbd "<f9>") 'switch-to-scratch)
(global-set-key (kbd "<f2>") 'visit-ansi-term)
(global-set-key (kbd "<f6>") 'visual-line-mode)

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

(global-set-key (kbd "M-g f d e") 'flymake-display-err-menu-for-current-line)

(global-set-key (kbd "M-]") 'select-next-window)
(global-set-key (kbd "M-[") 'select-previous-window)

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
 '(backup-directory-alist (quote (("." . "~/emacs-meta/backups"))))
 '(clean-buffer-list-kill-buffer-names (quote ("*Help*" "*Apropos*" "*Man " "*Buffer List*" "*Compile-Log*" "*info*" "*vc*" "*vc-diff*" "*diff*")))
 '(clean-buffer-list-kill-regexps (quote ("^.+\\.\\(\\(py\\)\\|\\(yaml\\)\\|\\(el\\)\\|\\(ini\\)\\|\\(html\\)\\|\\(js\\)\\)\\($\\|\\(<[0-9+]>$\\)\\)" "^*magit-.+*$")))
 '(custom-safe-themes (quote ("dd4db38519d2ad7eb9e2f30bc03fba61a7af49a185edfd44e020aa5345e3dca7" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
 '(elpy-rpc-backend "rope")
 '(elpy-rpc-python-command "/usr/bin/python")
 '(inhibit-startup-screen t)
 '(nxml-slash-auto-complete-flag t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; color-theme
(add-to-load-path (initabspath "./lib/color-theme"))
(require 'color-theme)
(eval-after-load "color-theme" 
  '(progn
     (add-to-list 'custom-theme-load-path 
		  (initabspath "./lib/emacs-color-theme-solarized"))
     (add-to-list 'custom-theme-load-path 
		  (initabspath "./lib/zenburn-emacs"))
     (color-theme-initialize)
     (load-theme 'zenburn)))


(server-start)
