;;;; <shafi> Load secrets

;; Create a secrets.el.gpg file in ~/.emacs.d and setq secret variables

(defvar secret-file (expand-file-name "secrets.el.gpg" user-emacs-directory))

(when (file-exists-p secret-file)
  (load-library secret-file))

(provide 'init-secret)
;;;
