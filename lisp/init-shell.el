;;;; <shafi> shell configurations


;; Read history from .zsh_history
(when (file-exists-p "~/.zsh_history")
  (add-hook 'shell-mode-hook
            (lambda ()
              (setq comint-input-ring-file-name "~/.zsh_history")
              (comint-read-input-ring t))))


(provide 'init-shell)
