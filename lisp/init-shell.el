;;;; <shafi> shell configurations


;; Read history from .zsh_history
(when (file-exists-p "~/.zsh_history")
  (add-hook 'shell-mode-hook
            (lambda ()
              (setq comint-input-ring-file-name "~/.zsh_history")
              (comint-read-input-ring t))))

;; Clear shell
(defun clear-shell ()
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))

(add-hook 'shell-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c l") 'clear-shell)))


(provide 'init-shell)
