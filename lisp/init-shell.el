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

;;(require 'term)
;;(add-hook 'term-mode-hook 'ansi-color-for-comint-mode-on)

;; Open a new shell buffer
;; https://www.quora.com/What-does-Tikhon-Jelviss-Emacs-setup-look-like/answer/Tikhon-Jelvis
(defun new-shell (name)
  "Opens a new shell buffer with the given name in
asterisks (*name*) in the current directory and changes the
prompt to 'name >'."
  (interactive "sName: ")
  (pop-to-buffer (concat "*" name "*"))
  (unless (eq major-mode 'shell-mode)
    (shell (current-buffer))
    (sleep-for 0 200)
    (delete-region (point-min) (point-max))
    (comint-simple-send (get-buffer-process (current-buffer))
                        (concat "export PS1=\"" name " > \""))))

(defun new-ansi-shell (name)
  (interactive "sName: ")
  (let* ((buffer-name  (concat "*" name "*"))
         (program (or (getenv "ESHELL")
                      (getenv "SHELL")
                      "/bin/sh")))
    (ansi-term program name)
    (comint-simple-send (get-buffer-process buffer-name)
                        (concat "export PS1=\"" name " ${PS1}" "\""))))

;; Keybinding
(global-set-key (kbd "C-c s") 'new-ansi-shell)

;; Ignore ASCII codes for colors http://stackoverflow.com/questions/256264/how-do-i-get-emacs-shell-mode-to-either-render-or-ignore-my-colors-instead-of
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'term-mode-hook 'ansi-color-for-comint-mode-on)

;; Disable yasnippets in ansi-term
(add-hook 'term-mode-hook (lambda()
                            (yas-minor-mode -1)))

(provide 'init-shell)
