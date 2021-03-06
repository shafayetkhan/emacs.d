(when (< emacs-major-version 24)
  (require-package 'org))
(require-package 'org-fstree)
(when *is-a-mac*
  (require-package 'org-mac-link)
  (autoload 'org-mac-grab-link "org-mac-link" nil t)
  (require-package 'org-mac-iCal))

(add-to-list 'load-path "~/.emacs.d/site-lisp/org-mode/lisp")
(add-to-list 'load-path "~/.emacs.d/site-lisp/org-mode/contrib/lisp" t)


(define-key global-map (kbd "C-c l") 'org-store-link)
(define-key global-map (kbd "C-c a") 'org-agenda)

;; Various preferences
(setq org-log-done t
      org-completion-use-ido t
      org-edit-timestamp-down-means-later t
      org-archive-mark-done nil
      org-catch-invisible-edits 'show
      org-export-coding-system 'utf-8
      org-fast-tag-selection-single-key 'expert
      org-html-validation-link nil
      org-export-kill-product-buffer-when-displayed t
      org-tags-column 80)


;; Lots of stuff from http://doc.norang.ca/org-mode.html

(defun sanityinc/grab-ditaa (url jar-name)
  "Download URL and extract JAR-NAME as `org-ditaa-jar-path'."
  ;; TODO: handle errors
  (message "Grabbing " jar-name " for org.")
  (let ((zip-temp (make-temp-name "emacs-ditaa")))
    (unwind-protect
        (progn
          (when (executable-find "unzip")
            (url-copy-file url zip-temp)
            (shell-command (concat "unzip -p " (shell-quote-argument zip-temp)
                                   " " (shell-quote-argument jar-name) " > "
                                   (shell-quote-argument org-ditaa-jar-path)))))
      (when (file-exists-p zip-temp)
        (delete-file zip-temp)))))

(after-load 'ob-ditaa
  (unless (file-exists-p org-ditaa-jar-path)
    (let ((jar-name "ditaa0_9.jar")
          (url "http://jaist.dl.sourceforge.net/project/ditaa/ditaa/0.9/ditaa0_9.zip"))
      (setq org-ditaa-jar-path (expand-file-name jar-name (file-name-directory user-init-file)))
      (unless (file-exists-p org-ditaa-jar-path)
        (sanityinc/grab-ditaa url jar-name)))))



(define-minor-mode prose-mode
  "Set up a buffer for prose editing.
This enables or modifies a number of settings so that the
experience of editing prose is a little more like that of a
typical word processor."
  nil " Prose" nil
  (if prose-mode
      (progn
        (setq truncate-lines nil)
        (setq word-wrap t)
        (setq cursor-type 'bar)
        (when (eq major-mode 'org)
          (kill-local-variable 'buffer-face-mode-face))
        (buffer-face-mode 1)
        ;;(delete-selection-mode 1)
        (set (make-local-variable 'blink-cursor-interval) 0.6)
        (set (make-local-variable 'show-trailing-whitespace) nil)
        (flyspell-mode 1)
        (when (fboundp 'visual-line-mode)
          (visual-line-mode 1)))
    (kill-local-variable 'truncate-lines)
    (kill-local-variable 'word-wrap)
    (kill-local-variable 'cursor-type)
    (kill-local-variable 'show-trailing-whitespace)
    (buffer-face-mode -1)
    ;; (delete-selection-mode -1)
    (flyspell-mode -1)
    (when (fboundp 'visual-line-mode)
      (visual-line-mode -1))))

;;(add-hook 'org-mode-hook 'buffer-face-mode)


(setq org-support-shift-select t)

;;; Capturing

(setq org-default-notes-file "~/org/notes.org")

(global-set-key (kbd "C-c c") 'org-capture)

(setq org-capture-templates
      `(("t" "todo")
        ("tw" "work" entry (file+headline "~/org/gtd.org" "Inbox")
         "* JIRA %?\n   SCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+1d\"))\n%U\n" :clock-resume t :prepend t)
        ("tt" "task" entry (file+headline "~/org/gtd.org" "Inbox")
         "* NEXT %?\n   SCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+1d\"))\n%U\n" :clock-resume t :prepend t)
        ("n" "note" entry (file+headline "" "Bank") ; "" => org-default-notes-file
         "* %? :@note:\n%U\n%a\n" :clock-resume t :prepend t)
        ("m" "meeting" entry (file+headline "~/org/gtd.org" "Meetings")
         "* MEETING with %? :@meeting:\n%U" :clock-in t :clock-resume t :prepend t)
        ))



;;; Effort
(setq org-global-properties
      '(("Effort_ALL". "0 0:10 0:30 1:00 2:00 3:00 4:00")))

(add-hook 'org-clock-in-prepare-hook
          'my-org-mode-ask-effort)

(defun my-org-mode-ask-effort ()
  "Ask for an effort estimate when clocking in."
  (unless (org-entry-get (point) "Effort")
    (let ((effort
           (completing-read
            "Effort: "
            (org-entry-get-multivalued-property (point) "Effort"))))
      (unless (equal effort "")
        (org-set-property "Effort" effort)))))

;;; Refiling

(setq org-refile-use-cache nil)

; Targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets '((nil :maxlevel . 5)
                           ("~/org/notes.org" :maxlevel . 2)
                           ("~/org/gtd.org" :maxlevel . 2)
                           ("~/org/help/work-help.org" :maxlevel . 3)
                           ("~/org/help/osx-help.org" :maxlevel . 2)
                           ("~/org/help/git-help.org" :maxlevel . 2)
                           ("~/org/help/unix-help.org" :maxlevel . 2)
                           ("~/org/help/emacs-help.org" :maxlevel . 3)
                           ("~/org/learn/learning-bash.org" :maxlevel . 2)
                           ("~/org/learn/learning-js.org" :maxlevel . 2)))

(after-load 'org-agenda
  (add-to-list 'org-agenda-after-show-hook 'org-show-entry))

;; Exclude DONE state tasks from refile targets
(defun sk/verify-refile-target ()
  "Exclude todo keywords with a done state and emacs keybindings from refile targets."
  (and (not (member (nth 2 (org-heading-components)) org-done-keywords))
       (not (string-match-p "^\".*?\"" (nth 4 (org-heading-components))))))
(setq org-refile-target-verify-function 'sk/verify-refile-target)

(defun sanityinc/org-refile-anywhere (&optional goto default-buffer rfloc msg)
  "A version of `org-refile' which suppresses `org-refile-target-verify-function'."
  (interactive "P")
  (let ((org-refile-target-verify-function))
    (org-refile goto default-buffer rfloc msg)))

;; Targets start with the file name - allows creating level 1 tasks
;;(setq org-refile-use-outline-path (quote file))
(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)

;; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes 'confirm)

;; Tags
(setq org-tag-alist '((:startgroup . nil)
                      ("@work" . nil)
                      (:grouptags . nil)
                      ("@debug" . ?d)
                      ("@feat" . ?f)
                      ("@grok" . ?g)
                      ("@jira" . ?j)
                      ("@ops" . ?o)
                      (:endgroup . nil)
                      (:startgroup . nil)
                      ("@life" . nil)
                      (:grouptags . nil)
                      ("@health" . ?h)
                      ("@finance" . ?f)
                      ("@errand" . ?x)
                      (:endgroup . nil)
                      ("@emacs" . ?e)
                      ("@refile" . ?r)))



;;; To-do settings

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!/!)")
              (sequence "JIRA(j)" "NEXT(n)" "DOING(i)" "DELEGATED(h@/!)" "|" "DONE(d!/!)" "CANCELLED(c@/!)")
              (sequence "PROJECT(p)" "|" "DONE(d!/!)" "CANCELLED(c@/!)")
              (sequence "WAITING(w@/!)" "HOLD(h)" "|" "CANCELLED(c@/!)" "MEETING"))))

(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING") ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

(setq org-todo-keyword-faces
      (quote (("NEXT" :inherit warning)
              ("PROJECT" :inherit font-lock-string-face))))



;;; Agenda views

(setq-default org-agenda-clockreport-parameter-plist '(:link t :maxlevel 3))

(setq org-agenda-files
      (delq nil
            (mapcar (lambda (x) (and (file-exists-p x) x))
                    '("~/.emacs.d/site-lisp/org-todoist/todoist.org"
                      "~/org/notes.org"
                      "~/org/gtd.org"
                      "~/org/gtd2.org"
                      "~/org/help/emacs-help.org"
                      "~/org/help/work-help.org"))))


(let ((active-project-match "-INBOX/PROJECT"))

  (setq org-stuck-projects
        `(,active-project-match ("NEXT")))

  (setq org-agenda-compact-blocks t
        org-agenda-sticky t
        org-agenda-start-on-weekday nil
        org-agenda-span 'day
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-reverse-note-order t
        org-agenda-include-diary nil
        org-agenda-sorting-strategy
        '((agenda habit-down time-up user-defined-up effort-up category-keep)
          (todo category-up effort-up)
          (tags category-up effort-up)
          (search category-up))
        org-agenda-window-setup 'current-window
        org-agenda-custom-commands
        `(("N" "Notes" tags "@note"
           ((org-agenda-overriding-header "Notes")
            (org-tags-match-list-sublevels t)))
          ("R" "Refile" tags "@refile"
           ((org-agenda-overriding-header "Refile")
            (org-tags-match-list-sublevels t)
            (org-agenda-skip-function
             '(org-agenda-skip-entry-if 'regexp "\\* Bank\\|\\* Inbox"))))
          ("g" "GTD"
           ((agenda "" nil)
            (tags "INBOX"
                  ((org-agenda-overriding-header "Inbox")
                   (org-tags-match-list-sublevels nil)))
            (stuck ""
                   ((org-agenda-overriding-header "Stuck Projects")
                    (org-agenda-tags-todo-honor-ignore-options t)
                    (org-tags-match-list-sublevels t)
                    (org-agenda-todo-ignore-scheduled 'future)))
            (tags-todo "-INBOX/NEXT"
                       ((org-agenda-overriding-header "Next Actions")
                        (org-agenda-tags-todo-honor-ignore-options t)
                        (org-agenda-todo-ignore-scheduled 'future)
                        ;; TODO: skip if a parent is WAITING or HOLD
                        (org-tags-match-list-sublevels t)
                        (org-agenda-sorting-strategy
                         '(todo-state-down effort-up category-keep))))
            (tags-todo ,active-project-match
                       ((org-agenda-overriding-header "Projects")
                        (org-tags-match-list-sublevels t)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            (tags-todo "-INBOX/-NEXT"
                       ((org-agenda-overriding-header "Orphaned Tasks")
                        (org-agenda-tags-todo-honor-ignore-options t)
                        (org-agenda-todo-ignore-scheduled 'future)
                        ;; TODO: skip if a parent is a project
                        (org-agenda-skip-function
                         '(lambda ()
                            (or (org-agenda-skip-subtree-if 'todo '("PROJECT" "HOLD" "WAITING"))
                                (org-agenda-skip-subtree-if 'nottododo '("TODO")))))
                        (org-tags-match-list-sublevels t)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            (tags-todo "/WAITING"
                       ((org-agenda-overriding-header "Waiting")
                        (org-agenda-tags-todo-honor-ignore-options t)
                        (org-agenda-todo-ignore-scheduled 'future)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            (tags-todo "/DELEGATED"
                       ((org-agenda-overriding-header "Delegated")
                        (org-agenda-tags-todo-honor-ignore-options nil)
                        (org-agenda-todo-ignore-scheduled 'future)
                        (org-agenda-sorting-strategy
                         '(category-keep))
                        ))
            (tags-todo "-INBOX/HOLD"
                       ((org-agenda-overriding-header "On Hold")
                        ;; TODO: skip if a parent is WAITING or HOLD
                        (org-tags-match-list-sublevels nil)
                        (org-agenda-sorting-strategy
                         '(category-keep))))
            ;; (tags-todo "-NEXT"
            ;;            ((org-agenda-overriding-header "All other TODOs")
            ;;             (org-match-list-sublevels t)))
            )))))


(add-hook 'org-agenda-mode-hook 'hl-line-mode)


;;; Org clock

;; Save the running clock and all clock history when exiting Emacs, load it on startup
(after-load 'org
  (org-clock-persistence-insinuate))
(setq org-clock-persist t)
(setq org-clock-in-resume t)

;; Save clock data and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Save state changes in the LOGBOOK drawer
(setq org-log-into-drawer t)
;; Removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;; Show clock sums as hours and minutes, not "n days" etc.
(setq org-time-clocksum-format
      '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))



;;; Show the clocked-in task - if any - in the header line
(defun sanityinc/show-org-clock-in-header-line ()
  (setq-default header-line-format '((" " org-mode-line-string " "))))

(defun sanityinc/hide-org-clock-from-header-line ()
  (setq-default header-line-format nil))

(add-hook 'org-clock-in-hook 'sanityinc/show-org-clock-in-header-line)
(add-hook 'org-clock-out-hook 'sanityinc/hide-org-clock-from-header-line)
(add-hook 'org-clock-cancel-hook 'sanityinc/hide-org-clock-from-header-line)

(after-load 'org-clock
  (define-key org-clock-mode-line-map [header-line mouse-2] 'org-clock-goto)
  (define-key org-clock-mode-line-map [header-line mouse-1] 'org-clock-menu))



(when (and *is-a-mac* (file-directory-p "/Applications/org-clock-statusbar.app"))
  (add-hook 'org-clock-in-hook
            (lambda () (call-process "/usr/bin/osascript" nil 0 nil "-e"
                                (concat "tell application \"org-clock-statusbar\" to clock in \"" org-clock-current-task "\""))))
  (add-hook 'org-clock-out-hook
            (lambda () (call-process "/usr/bin/osascript" nil 0 nil "-e"
                                "tell application \"org-clock-statusbar\" to clock out"))))



;; Remove empty LOGBOOK drawers on clock out
(defun sanityinc/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at "LOGBOOK" (point))))

(after-load 'org-clock
  (add-hook 'org-clock-out-hook 'sanityinc/remove-empty-drawer-on-clock-out 'append))



;; TODO: warn about inconsistent items, e.g. TODO inside non-PROJECT
;; TODO: nested projects!



;;; Archiving

(setq org-archive-mark-done nil)
(setq org-archive-location "%s_archive::* Archive")





(require-package 'org-pomodoro)
(setq org-pomodoro-keep-killed-pomodoro-time t)
(after-load 'org-agenda
  (define-key org-agenda-mode-map (kbd "P") 'org-pomodoro))


;; ;; Show iCal calendars in the org agenda
;; (when (and *is-a-mac* (require 'org-mac-iCal nil t))
;;   (setq org-agenda-include-diary t
;;         org-agenda-custom-commands
;;         '(("I" "Import diary from iCal" agenda ""
;;            ((org-agenda-mode-hook #'org-mac-iCal)))))

;;   (add-hook 'org-agenda-cleanup-fancy-diary-hook
;;             (lambda ()
;;               (goto-char (point-min))
;;               (save-excursion
;;                 (while (re-search-forward "^[a-z]" nil t)
;;                   (goto-char (match-beginning 0))
;;                   (insert "0:00-24:00 ")))
;;               (while (re-search-forward "^ [a-z]" nil t)
;;                 (goto-char (match-beginning 0))
;;                 (save-excursion
;;                   (re-search-backward "^[0-9]+:[0-9]+-[0-9]+:[0-9]+ " nil t))
;;                 (insert (match-string 0))))))


(after-load 'org
  (define-key org-mode-map (kbd "C-M-<up>") 'org-up-element)
  (when *is-a-mac*
    (define-key org-mode-map (kbd "M-h") nil)
    (define-key org-mode-map (kbd "C-c g") 'org-mac-grab-link)))

(after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   `((R . t)
     (ditaa . t)
     (dot . t)
     (emacs-lisp . t)
     (gnuplot . t)
     (haskell . nil)
     (latex . t)
     (ledger . t)
     (ocaml . nil)
     (octave . t)
     (python . t)
     (ruby . t)
     (screen . nil)
     (,(if (locate-library "ob-sh") 'sh 'shell) . t)
     (sql . nil)
     (sqlite . t)
     (js . t))))


;; Use fancy bullets
(require-package 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

;; Make code pretty
(setq org-src-fontify-natively t)

;; <shafi> Require init-todoist
(when (require 'org-todoist nil t)
  (message "ORG-TODOIST prototype has been loaded for testing."))

(provide 'init-org)
