;; <shafi> Project configurations


;; Projectile
(require-package 'projectile)
(projectile-global-mode)


;; Dired jump to projects

;; emacs.d
(setq emacs-dir "~/.emacs.d/lisp")
(when (file-directory-p emacs-dir)
  (global-set-key (kbd "C-c d e") (lambda () (interactive) (dired emacs-dir))))

;; Layer3 TV
(setq l3-project-dir "~/dev/layer3tv")
(when (file-directory-p l3-project-dir)
  (global-set-key (kbd "C-c d l") (lambda () (interactive) (dired l3-project-dir))))

;; org
(setq org-project-dir "~/org")
(when (file-directory-p l3-project-dir)
  (global-set-key (kbd "C-c d o") (lambda () (interactive) (dired org-project-dir))))



(provide 'init-project)
