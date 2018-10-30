(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)
(setq use-package-always-ensure t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (quote ((".*" "/home/marcos/.emacs.d/backup" t))))
 '(backup-by-copying t)
 '(backup-directory-alist (quote ((".*" . "/home/marcos/.emacs.d/backup"))))
 '(c-basic-offset 4)
 '(c-default-style "linux")
 '(column-number-mode 1)
 '(delete-old-versions t)
 '(ediff-merge-split-window-function (quote split-window-vertically))
 '(ediff-split-window-function (quote split-window-horizontally))
 '(fci-rule-color "gray20")
 '(fci-rule-column 79)
 '(flymake-start-syntax-check-on-newline nil)
 '(gdb-many-windows t)
 '(git-gutter:update-interval 2)
 '(global-linum-mode t)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-scratch-message ";; scratch")
 '(kept-new-versions 6)
 '(kept-old-versions 2)
 '(magit-diff-hide-trailing-cr-characters t)
 '(magit-diff-refine-hunk (quote all))
 '(mouse-wheel-follow-mouse t)
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount (quote (1 ((shift) . 1))))
 '(package-selected-packages
   (quote
    (typescript-mode editorconfig flymake-python-pyflakes magit hungry-delete aggressive-indent swiper-helm markdown-mode helm smartparens web-mode sr-speedbar use-package)))
 '(projectile-globally-ignored-files (quote ("TAGS" "*.pyc")))
 '(py-autopep8-options
   (quote
    ("--ignore=E101,E121,E122,E123,E124,E125,E126,E127,E128,F821")))
 '(safe-local-variable-values (quote ((encoding . utf-8))))
 '(scroll-bar-mode nil)
 '(scroll-step 1)
 '(show-paren-delay 0)
 '(show-paren-mode t)
 '(speedbar-show-unknown-files t)
 '(speedbar-use-images nil)
 '(speedbar-use-imenu-flag nil)
 '(sr-speedbar-right-side nil)
 '(tool-bar-mode nil)
 '(version-control t)
 '(visible-bell t)
 '(web-mode-code-indent-offset 2)
 '(web-mode-disable-css-colorization t)
 '(web-mode-indent-style 2)
 '(web-mode-markup-indent-offset 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "gray10" :foreground "white" :height 120 :width extra-expanded))))
 '(flymake-errline ((((class color)) (:underline "red"))))
 '(flymake-warnline ((((class color)) (:underline "yellow")))))

(fset 'yes-or-no-p 'y-or-n-p)

(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'auto-mode-alist '("\\emacs\\'" . emacs-lisp-mode))

;; backup files
(message "Deleting old backup files...")
(let ((week (* 60 60 24 7))
      (current (float-time (current-time))))
  (dolist (file (directory-files temporary-file-directory t))
    (when (and (backup-file-name-p file)
               (> (- current (float-time (fifth (file-attributes file))))
                  week))
      (message file)
      (delete-file file))))

;; coding
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; keys
(global-set-key [f2] 'split-window-vertically)
(global-set-key [f3] 'split-window-horizontally)
(global-set-key [f4] 'delete-window)

(global-set-key [f5] 'copy-region-as-kill)
(global-set-key [C-S-f5] 'revert-buffer)
(global-set-key [f6] 'kill-region)
(global-set-key [f7] 'yank)
(global-set-key [f8] 'goto-line)

;; (global-set-key [C-f11] 'previous-multiframe-window)
;; (global-set-key [f11] 'next-multiframe-window)
(global-set-key [f9] 'kill-buffer-and-window)
(global-set-key [f11] 'sr-speedbar-toggle)

(add-hook 'local-write-file-hooks
          (lambda ()
            (delete-trailing-whitespace)
            nil))
(defun insert-coding-utf ()
  "Inserts a encoding in the begining of file"
  (goto-char (point-min))
  (insert "# -*- coding: utf-8 -*-\n")
  (goto-char (point-min))
  (forward-line 1))

(defun has-coding ()
  "Checks if file has encoding inserted"
  (goto-char (point-min))
  (if (string= (thing-at-point 'line t) "# -*- coding: utf-8 -*-\n") t))

(defun check-and-insert-coding ()
  "Checks if file has encoding and insert it if not"
  (interactive
   (save-excursion
     (if (not (has-coding)) (insert-coding-utf)))))

(global-set-key [C-S-f9] 'check-and-insert-coding)

(setq auto-mode-alist
      (cons '("\\.po\\'\\|\\.po\\." . po-mode) auto-mode-alist))
(autoload 'po-mode "po-mode" "Major mode for translators to edit PO files" t)


;; flymake-python-pyflakes
(use-package flymake-python-pyflakes)

;; magit
(use-package magit
  :bind ("C-x g" . magit-status)
  )

;; web-mode
(use-package web-mode
  :mode ("\\.as[cp]x\\'" "\\.djhtml\\'" "\\.erb\\'"
         "\\.html?\\'" "\\.js\\'" "\\.json\\'"
         "\\.jsp\\'" "\\.mustache\\'" "\\.php\\'"
         "\\.phtml\\'" "\\.tpl\\'")
  :bind ("C-c C-v" . web-mode-element-close)
  :config
  (add-hook 'web-mode-hook
            (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))
  (setq-default indent-tabs-mode nil)
  (setq web-mode-engines-alist
        '(("django"    . "\\.dj\\.html\\'")
          )
        )
  (global-set-key [C-S-f4]
                  (lambda()
                    (interactive)
                    (web-mode-set-engine "django")))
  )

;; fill-column-indicator
(use-package fill-column-indicator
  :config
  (add-hook 'python-mode-hook 'fci-mode)
  (add-hook 'yaml-mode-hook 'fci-mode)
  (add-hook 'markdown-mode-hook 'fci-mode)
  )

(use-package auto-complete
  :config
  ;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
  (ac-config-default)
  (global-auto-complete-mode t)
  )

;; python
(add-hook 'python-mode-hook
	  (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

(add-hook 'python-mode-hook 'flymake-mode)
(add-hook 'python-mode-hook 'flymake-python-pyflakes-load)
(setq flymake-python-pyflakes-executable "flake8")

(add-to-list 'auto-mode-alist '("SConstruct" . python-mode))
(add-to-list 'auto-mode-alist '("SConscript" . python-mode))


;; flymake
(defvar my-flymake-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map "\M-p" 'flymake-goto-prev-error)
    (define-key map "\M-n" 'flymake-goto-next-error)
    map)
  "Keymap for my flymake minor mode.")

(defun my-flymake-err-at (pos)
  (let ((overlays (overlays-at pos)))
    (remove nil
            (mapcar (lambda (overlay)
                      (and (overlay-get overlay 'flymake-overlay)
                           (overlay-get overlay 'help-echo)))
                    overlays))))

(defun my-flymake-err-echo ()
  (message "%s" (mapconcat 'identity (my-flymake-err-at (point)) "\n")))

(defadvice flymake-goto-next-error (after display-message activate compile)
  (my-flymake-err-echo))

(defadvice flymake-goto-prev-error (after display-message activate compile)
  (my-flymake-err-echo))

(define-minor-mode my-flymake-minor-mode
  "Simple minor mode which adds some key bindings for moving to the next and previous errors.

Key bindings:

\\{my-flymake-minor-mode-map}"
  nil
  nil
  :keymap my-flymake-minor-mode-map)

;; Enable this keybinding (my-flymake-minor-mode) by default
;; Added by Hartmut 2011-07-05
(add-hook 'python-mode-hook 'my-flymake-minor-mode)

;; move line
(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (defvar myemacs-col)
  (defvar myemacs-start)
  (defvar myemacs-end)
  (setq myemacs-col (current-column))
  (beginning-of-line) (setq myemacs-start (point))
  (end-of-line) (forward-char) (setq myemacs-end (point))
  (let ((line-text (delete-and-extract-region myemacs-start myemacs-end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char myemacs-col)))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

;; toggle split
(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(global-set-key (kbd "M-<right>") 'toggle-window-split)

;; autopep
(use-package py-autopep8
  :config
  (add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
  (setq py-autopep8-options
   (quote
    ("--ignore=E101,E121,E122,E123,E124,E125,E126,E127,E128,F821 --aggressive --aggressive")))
  )

;; smartparens
(use-package smartparens
  :config
  (add-hook 'python-mode-hook #'smartparens-mode)
  (add-hook 'web-mode-hook #'smartparens-mode)
  :bind ("M-[" . sp-backward-unwrap-sexp)
  )

;; helm
(use-package helm
  :ensure t
  :config
  (helm-mode 1)
  ;; (define-key global-map [remap find-file] 'helm-find-files)
  (define-key global-map [remap occur] 'helm-occur)
  (define-key global-map [remap list-buffers] 'helm-buffers-list)
  (define-key global-map [remap dabbrev-expand] 'helm-dabbrev)
  (unless (boundp 'completion-in-region-function)
    (define-key lisp-interaction-mode-map [remap completion-at-point] 'helm-lisp-completion-at-point)
    (define-key emacs-lisp-mode-map       [remap completion-at-point] 'helm-lisp-completion-at-point))
  :bind ("M-x" . helm-M-x)
  )

;; markdown
(use-package markdown-mode
  :config
  (autoload 'markdown-mode "markdown-mode"
    "Major mode for editing Markdown files" t)
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
  (autoload 'gfm-mode "markdown-mode"
    "Major mode for editing GitHub Flavored Markdown files" t)
  (add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
  )

;; sr-speedbar
(use-package sr-speedbar
  :config
  (add-hook 'speedbar-mode-hook '(lambda () (linum-mode -1)))
  )

;; swiper
(use-package swiper-helm
  :bind ("C-s" . swiper)
  )

;; aggresive-indent
;; (use-package aggressive-indent
;;   :config
;;   (global-aggressive-indent-mode 1)
;;   ;; (add-to-list 'aggressive-indent-excluded-modes 'html-mode)
;;   (add-to-list 'aggressive-indent-excluded-modes 'sql-mode)
;;   )

;; hungry delete
(use-package hungry-delete
  :config
  (global-hungry-delete-mode)
  )

;; Editor config
(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))

;; Typescript
(use-package typescript-mode
  :mode "\\.ts\\'"
  )

;; Docker
(use-package dockerfile-mode
  :mode "Dockerfile\\'"
  )

;; yaml
(use-package yaml-mode
  :mode "\\.yaml\\'"
  )

(add-hook 'yaml-mode-hook
          (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

;; git gutter
(use-package git-gutter
  :config
  (global-git-gutter-mode t)
  (git-gutter:linum-setup)
  ;; Stage current hunk
  (global-set-key (kbd "C-x v s") 'git-gutter:stage-hunk)
  )

(use-package s)
(use-package powerline)

(require 'spaceline-config)
(spaceline-emacs-theme)

;; (require 'spacemacs-dark-theme)
(require 'helm)
(use-package projectile
  :ensure t
  :init
  (setq projectile-completion-system 'helm)
  (setq projectile-enable-caching t)
  :config
  (projectile-global-mode)
  )

;; ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)
(setq ibuffer-saved-filter-groups
      (quote (("default"
               ("dired" (mode . dired-mode))
               ("org" (name ."^.*org$"))
               ("web" (mode . web-mode))
               ("shell" (or (mode . eshell-mode) (mode . shell-mode)))
               ("programming" (or
                               (mode . python-mode)
                               (mode . c++-mode)
                               (mode . c-mode)
                               ))
               ("emacs" (or
                         (name . "^\\*scratch\\*$")
                         (name . "^\\*Messages\\*$")
                         (mode . emacs-lisp-mode)))
               ))))
(add-hook 'ibuffer-mode-hook
          (lambda ()
            (ibuffer-auto-mode 1)
            (ibuffer-switch-to-saved-filter-groups "default")))

(global-set-key (kbd "C-c C-S-r")  'myfunctions-rename-file-and-buffer)

(require 'myfunctions)
(global-set-key [C-F9] 'myfunctions-parse-json)

(defvar sanityinc/fci-mode-suppressed nil)
(defadvice popup-create (before suppress-fci-mode activate)
  "Suspend fci-mode while popups are visible"
  (set (make-local-variable 'sanityinc/fci-mode-suppressed) fci-mode)
  (when fci-mode
    (turn-off-fci-mode)))
(defadvice popup-delete (after restore-fci-mode activate)
  "Restore fci-mode when all popups have closed"
  (when (and (not popup-instances) sanityinc/fci-mode-suppressed)
    (setq sanityinc/fci-mode-suppressed nil)
    (turn-on-fci-mode)))

(use-package visual-regexp
  :bind (
         ("C-c r" . vr/replace)
         ("C-c q" . vr/query-replace)
         )
  )

(use-package switch-window
  :ensure t
  :bind (
         ([f12] . switch-window)
         )
  )

