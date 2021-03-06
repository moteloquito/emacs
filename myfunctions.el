;; myfunctions.el --- Some of my functions

;; Copyleft Marcos A. Lewis

;;; Code:

(defun myfunctions-replace-all (r m)
  "replace all r with m"
  (while (re-search-forward r nil t)
    (replace-match m)))

(defun myfunctions-indent-buffer ()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun myfunctions-parse-json ()
  "Parse a json"
  (interactive)
  (goto-char (point-min))
  (myfunctions-replace-all "{" "{\n")
  (goto-char (point-min))
  (myfunctions-replace-all "}" "\n}")
  (goto-char (point-min))
  (myfunctions-replace-all "\\[" "[\n")
  (goto-char (point-min))
  (myfunctions-replace-all "\\]" "\n]")
  (goto-char (point-min))
  (myfunctions-replace-all "," ",\n")
  (indent-buffer)
  )

(defun myfunctions-rename-file-and-buffer ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)))))))

(provide 'myfunctions)
