;; Use C-f during file selection to switch to regular find-file
(ido-mode t)
(ido-everywhere t)
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point nil)
(setq ido-auto-merge-work-directories-length 0)
(setq ido-use-virtual-buffers t)

(when (maybe-require-package 'ido-ubiquitous)
  (ido-ubiquitous-mode t))

;; Use smex to handle M-x
(when (maybe-require-package 'smex)
  ;; Change path for ~/.smex-items
  (setq smex-save-file (expand-file-name ".smex-items" user-emacs-directory))
  (global-set-key [remap execute-extended-command] 'smex))

(require-package 'idomenu)

;; Allow the same buffer to be open in different frames
(setq ido-default-buffer-method 'selected-window)

;; http://www.reddit.com/r/emacs/comments/21a4p9/use_recentf_and_ido_together/cgbprem
(add-hook 'ido-setup-hook (lambda () (define-key ido-completion-map [up] 'previous-history-element)))



;; <shafi> Use ido-vertical-mode
(require-package 'ido-vertical-mode)
(ido-vertical-mode 1)

;; Use, down, left, right to navigate the options and through history/directories
(setq ido-vertical-define-keys 'C-n-C-p-up-down-left-right)
(setq ido-vertical-show-count t)

;; <shafi> flx-ido
(require-package 'flx-ido)
(flx-ido-mode +1)
;; Recommended here https://github.com/lewang/flx
(setq gc-cons-threshold 20000000)


(provide 'init-ido)
