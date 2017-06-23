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

(provide 'myfunctions)
