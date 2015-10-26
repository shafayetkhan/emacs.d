(when (< emacs-major-version 24)
  (require-package 'color-theme))

(require-package 'color-theme-sanityinc-solarized)
(require-package 'color-theme-sanityinc-tomorrow)
(require-package 'sublime-themes)
(require-package 'base16-theme)

;;------------------------------------------------------------------------------
;; Old-style color theming support (via color-theme.el)
;;------------------------------------------------------------------------------
(defcustom window-system-color-theme 'color-theme-sanityinc-tomorrow-night
  "Color theme to use in window-system frames.
If Emacs' native theme support is available, this setting is
ignored: use `custom-enabled-themes' instead."
  :type 'symbol)

(defcustom tty-color-theme 'color-theme-terminal
  "Color theme to use in TTY frames.
If Emacs' native theme support is available, this setting is
ignored: use `custom-enabled-themes' instead."
  :type 'symbol)

(unless (boundp 'custom-enabled-themes)
  (defun color-theme-terminal ()
    (interactive)
    (color-theme-sanityinc-tomorrow-night))

  (defun apply-best-color-theme-for-frame-type (frame)
    (with-selected-frame frame
      (funcall (if window-system
                   window-system-color-theme
                 tty-color-theme))))

  (defun reapply-color-themes ()
    (interactive)
    (mapcar 'apply-best-color-theme-for-frame-type (frame-list)))

  (set-variable 'color-theme-is-global nil)
  (add-hook 'after-make-frame-functions 'apply-best-color-theme-for-frame-type)
  (add-hook 'after-init-hook 'reapply-color-themes)
  (apply-best-color-theme-for-frame-type (selected-frame)))


;;------------------------------------------------------------------------------
;; New-style theme support, in which per-frame theming is not possible
;;------------------------------------------------------------------------------

;; If you don't customize it, this is the theme you get.
(setq-default custom-enabled-themes '(sanityinc-tomorrow-night))

;; Ensure that themes will be applied even if they have not been customized
(defun reapply-themes ()
  "Forcibly load the themes listed in `custom-enabled-themes'."
  (dolist (theme custom-enabled-themes)
    (unless (custom-theme-p theme)
      (load-theme theme)))
  (custom-set-variables `(custom-enabled-themes (quote ,custom-enabled-themes))))

(add-hook 'after-init-hook 'reapply-themes)


;;------------------------------------------------------------------------------
;; Toggle between light and dark
;;------------------------------------------------------------------------------
(defun light ()
  "Activate a light color theme."
  (interactive)
  (color-theme-sanityinc-solarized-light)
  (powerline-reset))

(defun dark ()
  "Activate a dark color theme."
  (interactive)
  (color-theme-sanityinc-tomorrow-night)
  (powerline-reset))



;;------------------------------------------------------------------------------
;; Activate powerline
;;------------------------------------------------------------------------------
(require-package 'powerline)
(add-hook 'after-init-hook 'powerline-default-theme)

;;------------------------------------------------------------------------------
;; Setup theme for Org-mode
;; Taken from: https://github.com/howardabrams/dot-files/blob/6433f7593b6a2832ddd5806ff14cea1451fd0261/emacs-client.org
;; and https://github.com/jonnay/emagicians-starter-kit/blob/master/themes/org-beautify-theme.el
;;------------------------------------------------------------------------------
(defun org-src-color-blocks-light ()
  "Colors the block headers and footers to make them stand out more for lighter themes"
  (interactive)
  (custom-set-faces
   '(org-block-begin-line
     ((t (:underline "#A7A6AA" :foreground "#008ED1" :background "#EAEAFF"))))
   '(org-block-background
     ((t (:background "#FFFFEA"))))
   '(org-block-end-line
     ((t (:overline "#A7A6AA" :foreground "#008ED1" :background "#EAEAFF"))))

   '(mode-line-buffer-id ((t (:foreground "#005000" :bold t))))
   '(which-func ((t (:foreground "#008000")))))

  ;; Looks like the minibuffer issues are only for v23
                                        ; (set-face-foreground 'minibuffer "black")
                                        ; (set-face-foreground 'minibuffer-prompt "red")
  )

(defun org-src-color-blocks-dark ()
  "Colors the block headers and footers to make them stand out more for dark themes"
  (interactive)
  (custom-set-faces
   '(org-block-begin-line
     ((t (:foreground "#008ED1" :background "#002E41"))))
   '(org-block-background
     ((t (:background "#111111"))))
   '(org-block-end-line
     ((t (:foreground "#008ED1" :background "#002E41"))))

   '(mode-line ((t (:foreground "#3A85BD"))))
   ;;'(mode-line ((t (:background "#292B2D" :foreground "#3A85BD"))))
   '(mode-line-buffer-id ((t (:foreground "SpringGreen3" :bold t))))
   '(which-func ((t (:foreground "green")))))

  ;; Looks like the minibuffer issues are only for v23
  ;; (set-face-foreground 'minibuffer "white")
  ;; (set-face-foreground 'minibuffer-prompt "white")
  )

(deftheme sk/org-theme "Sub-theme to beautify org mode")

(defun sk/change-theme (theme org-block-style)
  "Changes the color scheme and reset the mode line."
  (funcall theme)
  ;; TODO: This is a hack. Figure out a better way to run powerline-reset
  (require 'powerline)
  (powerline-reset)
  (funcall org-block-style)

  (let* ((sans-font (cond ((x-list-fonts "Input Mono") '(:font "Input Mono"))
                          ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
                          ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
                          ((x-list-fonts "Verdana")         '(:font "Verdana"))
                          ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
                          (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
         (base-font-color  (face-foreground 'default nil 'default))
         (background-color (face-background 'default nil 'default))
         (primary-color    (face-foreground 'mode-line nil))
         (secondary-color  (face-background 'secondary-selection nil 'region))
         (headline         `(:inherit default :weight bold :foreground,base-font-color))
         (headline2        `(:inherit default :weight bold :foreground "#bf616a"))
         (headline3        `(:inherit default :weight bold :foreground, base-font-color)))
    (custom-theme-set-faces 'sk/org-theme
                            `(org-agenda-structure ((t (:inherit default ,@sans-font :height 2.0 :underline nil))))
                            `(org-level-8 ((t (,@headline ,@sans-font))))
                            `(org-level-7 ((t (,@headline ,@sans-font))))
                            `(org-level-6 ((t (,@headline ,@sans-font))))
                            `(org-level-5 ((t (,@headline ,@sans-font))))
                            `(org-level-4 ((t (,@headline ,@sans-font))))
                            `(org-level-3 ((t (,@headline ,@sans-font))))
                            `(org-level-2 ((t (,@headline2 ,@sans-font :height 1.25))))
                            `(org-level-1 ((t (,@headline ,@sans-font :height 1.5))))
                            `(org-document-title ((t (,@headline ,@sans-font :height 2.0 :underline nil)))))))


;; <shafi> Always start with dark theme
(defun sk/light ()
  "Activate a dark color theme."
  (interactive)
  (sk/change-theme 'color-theme-sanityinc-solarized-light
                   'org-src-color-blocks-light))

(defun sk/dark ()
  "Activate a dark color theme."
  (interactive)
  (sk/change-theme 'color-theme-sanityinc-tomorrow-night
                   'org-src-color-blocks-dark)
  (load-theme 'base16-default-dark 't)
  (load-theme 'brin 't))

(add-hook 'after-init-hook 'sk/dark)


(provide 'init-themes)
