;;;; <shafi> IRC configurations


(require-package 'circe)

(setq circe-network-options
      `(("Freenode"
         :nick "shafayet"
         :channels ("#emacs" "#emacs-circe")
         :nickserv-password ,(if (boundp 'freenode-password)
                                 freenode-password
                               'nil))))


(provide 'init-irc)
