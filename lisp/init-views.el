;; <shafi> Views configuration - Easy access files

;; emacs notes
(setq emacs-help-file "~/org/emacs-notes.org")

(when (file-exists-p emacs-help-file)
  (defun open-emacs-help ()
    (interactive)
    (view-file-other-window emacs-help-file))
  (global-set-key (kbd "C-c i e") 'open-emacs-help))

(provide 'init-views)
