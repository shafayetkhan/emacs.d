;; <shafi> Views configuration - Easy access files

;; emacs notes
(setq emacs-help-file "~/org/help/emacs-help.org")

(when (file-exists-p emacs-help-file)
  (defun open-emacs-help ()
    (interactive)
    (view-file-other-window emacs-help-file))
  (global-set-key (kbd "C-c i e") 'open-emacs-help))

;; git notes
(setq git-help-file "~/org/help/git-help.org")

(when (file-exists-p git-help-file)
  (defun open-git-help ()
    (interactive)
    (view-file-other-window git-help-file))
  (global-set-key (kbd "C-c i g") 'open-git-help))


;;  unix notes
(setq unix-help-file "~/org/help/unix-help.org")

(when (file-exists-p unix-help-file)
  (defun open-unix-help ()
    (interactive)
    (view-file-other-window unix-help-file))
  (global-set-key (kbd "C-c i u") 'open-unix-help))


;;  vi notes
(setq vi-help-file "~/org/help/vi-help.org")

(when (file-exists-p vi-help-file)
  (defun open-vi-help ()
    (interactive)
    (view-file-other-window vi-help-file))
  (global-set-key (kbd "C-c i v") 'open-vi-help))


;; work notes
(setq work-help-file "~/org/help/work-help.org")

(when (file-exists-p work-help-file)
  (defun open-work-help ()
    (interactive)
    (view-file-other-window work-help-file))
  (global-set-key (kbd "C-c i w") 'open-work-help))

 ;; learning bash
(setq learn-bash-file "~/org/learn/learning-bash.org")

(when (file-exists-p learn-bash-file)
  (defun open-bash-help ()
    (interactive)
    (view-file-other-window learn-bash-file))
  (global-set-key (kbd "C-c i l b") 'open-bash-help))


;; learning C
(setq learn-c-file "~/org/learn/learning-c.org")

(when (file-exists-p learn-c-file)
  (defun open-c-help ()
    (interactive)
    (view-file-other-window learn-c-file))
  (global-set-key (kbd "C-c i l c") 'open-c-help))



;; learning lisp
(setq learn-lisp-file "~/org/learn/learning-lisp.org")

(when (file-exists-p learn-lisp-file)
  (defun open-lisp-help ()
    (interactive)
    (view-file-other-window learn-lisp-file))
  (global-set-key (kbd "C-c i l l") 'open-lisp-help))


;; learning js
(setq learn-js-file "~/org/learn/learning-js.org")

(when (file-exists-p learn-js-file)
  (defun open-js-help ()
    (interactive)
    (view-file-other-window learn-js-file))
  (global-set-key (kbd "C-c i l j") 'open-js-help))


(provide 'init-views)
