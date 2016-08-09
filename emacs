(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (quote ((".*" "/home/marcos/.emacs.d/backup" t))))
 '(backup-by-copying t)
 '(backup-directory-alist (quote ((".*" . "/home/marcos/.emacs.d/backup"))))
 '(column-number-mode 1)
 '(delete-old-versions t)
 '(ediff-merge-split-window-function (quote split-window-vertically))
 '(fci-rule-color "gray20")
 '(fci-rule-column 79)
 '(flymake-start-syntax-check-on-newline nil)
 '(global-linum-mode 1)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-scratch-message ";; scratch")
 '(kept-new-versions 6)
 '(kept-old-versions 2)
 '(mouse-wheel-follow-mouse t)
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount (quote (1 ((shift) . 1))))
 '(py-autopep8-options
   (quote
    ("--ignore=E101,E121,E122,E123,E124,E125,E126,E127,E128")))
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
 '(default ((t (:background "gray10" :foreground "white" :height 130 :width extra-expanded))))
 '(flymake-errline ((((class color)) (:underline "red"))))
 '(flymake-warnline ((((class color)) (:underline "yellow")))))

(add-to-list 'load-path "/opt/emacs/share/emacs/site-lisp")

(package-initialize)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("elpy" . "https://jorgenschaefer.github.io/packages/") t)

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

(global-set-key [C-f11] 'previous-multiframe-window)
(global-set-key [f11] 'next-multiframe-window)
(global-set-key [C-f4] 'kill-buffer-and-window)
(global-set-key [f12] 'sr-speedbar-toggle)
(global-set-key [C-S-f4]
		(lambda()
		 (interactive)
		 (web-mode-set-engine "django")))
(global-set-key (kbd "C-x g") 'magit-status)

;; web-mode
(require 'web-mode)
(add-hook 'web-mode-hook
          (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\'" . web-mode))
(setq-default indent-tabs-mode nil)
(add-hook 'web-mode-hook
	 '(lambda ()
	    (local-set-key (kbd "C-c C-v") 'web-mode-element-close)))
(setq web-mode-engines-alist
      '(("django"    . "\\.dj\\.html\\'")
	)
      )

(add-hook 'local-write-file-hooks
          (lambda ()
	   (delete-trailing-whitespace)
	   nil))

(require 'sr-speedbar)
(add-hook 'speedbar-mode-hook '(lambda () (linum-mode -1)))

(defun insert-coding-utf ()
  "Inserts a encoding in the begining of file"
  (goto-char (point-min))
  (insert "# -*- coding: utf-8 -*-\n"))

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

(require 'fill-column-indicator)
(add-hook 'python-mode-hook 'fci-mode)

(setq auto-mode-alist
           (cons '("\\.po\\'\\|\\.po\\." . po-mode) auto-mode-alist))
(autoload 'po-mode "po-mode" "Major mode for translators to edit PO files" t)

(require 'auto-complete)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)

;; python
(add-hook 'python-mode-hook
	  (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

(add-hook 'python-mode-hook 'flymake-mode)
(add-hook 'python-mode-hook 'flymake-python-pyflakes-load)
(setq flymake-python-pyflakes-executable "flake8")

(add-to-list 'auto-mode-alist '("SConstruct" . python-mode))
(add-to-list 'auto-mode-alist '("SConscript" . python-mode))

(add-hook 'python-mode-hook
          (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

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
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

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
(require 'py-autopep8)
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

;; smartparens
(require 'smartparens-config)
(add-hook 'python-mode-hook #'smartparens-mode)
(add-hook 'web-mode-hook #'smartparens-mode)
(global-set-key (kbd "M-[") 'sp-backward-unwrap-sexp)