;; <shafi> Views configuration - Easy access files

;; emacs notes
(setq emacs-help-file "~/org/help/emacs-help.org")

(when (file-exists-p emacs-help-file)
  (defun sk/open-emacs-help ()
    (interactive)
    (view-file-other-window emacs-help-file))
  (global-set-key (kbd "C-c i e") 'sk/open-emacs-help))

;; git notes
(setq git-help-file "~/org/help/git-help.org")

(when (file-exists-p git-help-file)
  (defun sk/open-git-help ()
    (interactive)
    (view-file-other-window git-help-file))
  (global-set-key (kbd "C-c i g") 'sk/open-git-help))


;;  unix notes
(setq unix-help-file "~/org/help/unix-help.org")

(when (file-exists-p unix-help-file)
  (defun sk/open-unix-help ()
    (interactive)
    (view-file-other-window unix-help-file))
  (global-set-key (kbd "C-c i u") 'sk/open-unix-help))


;;  osx notes
(setq osx-help-file "~/org/help/osx-help.org")

(when (file-exists-p osx-help-file)
  (defun sk/open-osx-help ()
    (interactive)
    (view-file-other-window osx-help-file))
  (global-set-key (kbd "C-c i o") 'sk/open-osx-help))



;;  vi notes
(setq vi-help-file "~/org/help/vi-help.org")

(when (file-exists-p vi-help-file)
  (defun sk/open-vi-help ()
    (interactive)
    (view-file-other-window vi-help-file))
  (global-set-key (kbd "C-c i v") 'sk/open-vi-help))


;; work notes
(setq work-help-file "~/org/help/work-help.org")

(when (file-exists-p work-help-file)
  (defun sk/open-work-help ()
    (interactive)
    (view-file-other-window work-help-file))
  (global-set-key (kbd "C-c i w") 'sk/open-work-help))

 ;; learning bash
(setq learn-bash-file "~/org/learn/learning-bash.org")

(when (file-exists-p learn-bash-file)
  (defun sk/open-bash-help ()
    (interactive)
    (view-file-other-window learn-bash-file))
  (global-set-key (kbd "C-c i l b") 'sk/open-bash-help))


;; learning C
(setq learn-c-file "~/org/learn/learning-c.org")

(when (file-exists-p learn-c-file)
  (defun sk/open-c-help ()
    (interactive)
    (view-file-other-window learn-c-file))
  (global-set-key (kbd "C-c i l c") 'sk/open-c-help))



;; learning lisp
(setq learn-lisp-file "~/org/learn/learning-lisp.org")

(when (file-exists-p learn-lisp-file)
  (defun sk/open-lisp-help ()
    (interactive)
    (view-file-other-window learn-lisp-file))
  (global-set-key (kbd "C-c i l l") 'sk/open-lisp-help))


;; learning js
(setq learn-js-file "~/org/learn/learning-js.org")

(when (file-exists-p learn-js-file)
  (defun sk/open-js-help ()
    (interactive)
    (view-file-other-window learn-js-file))
  (global-set-key (kbd "C-c i l j") 'sk/open-js-help))


(provide 'init-views)
