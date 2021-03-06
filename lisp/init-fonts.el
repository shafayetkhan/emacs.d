;;; Character sets

(defcustom sanityinc/force-default-font-for-symbols nil
  "When non-nil, force Emacs to use your default font for symbols."
  :type 'boolean)

(defun sanityinc/maybe-use-default-font-for-symbols ()
  "Force Emacs to render symbols using the default font, if so configured."
  (when sanityinc/force-default-font-for-symbols
    (set-fontset-font "fontset-default" 'symbol (face-attribute 'default :family))))

(add-hook 'after-init-hook 'sanityinc/maybe-use-default-font-for-symbols)

;; set a default font
;; Download font from here: https://github.com/google/fonts
;; (when (member "Source Code Pro" (font-family-list))
;;   (setq my-font "Source Code Pro-12")
;;   (set-face-attribute 'default nil :font my-font))

(when (member "Input Mono" (font-family-list))
  (setq my-font "Input Mono-12")
  (set-face-attribute 'default nil :font my-font))

;;; Changing font sizes

(require-package 'default-text-scale)
(global-set-key (kbd "C-M-=") 'default-text-scale-increase)
(global-set-key (kbd "C-M--") 'default-text-scale-decrease)

;; <shafi> Advising default-text-scale to reset powerline
(defadvice default-text-scale-increase (after sk/reload-powerline-after-font-increase activate)
  "Reload powerline when increasing font size."
  (when (require 'powerline nil t)
    (powerline-reset)))

(defadvice default-text-scale-decrease (after sk/reload-powerline-after-font-decrease activate)
  "Reload powerline when decreasing font size."
  (when (require 'powerline nil t)
    (powerline-reset)))


(defun sanityinc/maybe-adjust-visual-fill-column ()
  "Readjust visual fill column when the global font size is modified.
This is helpful for writeroom-mode, in particular."
  (if visual-fill-column-mode
      (add-hook 'after-setting-font-hook 'visual-fill-column--adjust-window nil t)
    (remove-hook 'after-setting-font-hook 'visual-fill-column--adjust-window t)))

(add-hook 'visual-fill-column-mode-hook
          'sanityinc/maybe-adjust-visual-fill-column)



(provide 'init-fonts)
