; IMAP for Gmail
(setq mew-ssl-verify-level 0)
(setq mew-prog-ssl "/usr/local/bin/stunnel")

(setq mew-proto "%")
(setq mew-config-alist 
;;Gmail
      '(("default"
         ("name"              . "")
         ("user"              . "")
         ("mail-domain"       . "gmail.com")
         ("proto"             . "%")
         ("imap-server"       . "imap.gmail.com")
         ("imap-ssl"          . t)
         ("imap-ssl-port"     . "993")
         ("imap-user"         . "")
         ("imap-size"         . 0)
         ("smtp-ssl"          . t)
         ("smtp-ssl-port"     . "465")
         ("smtp-auth-list"    . ("PLAIN" "LOGIN" "CRAM-MD5"))
         ("smtp-user"         . "")
         ("smtp-server"       . "smtp.gmail.com")
         ("imap-delete"       . t)
         ("imap-queue-folder" . "%queue") 
         ("imap-trash-folder" . "%[Gmail]/All Mail") ;; This must be in concile with your IMAP box setup
         )
))


(setq mew-use-cached-passwd t)
(setq mew-passwd-timer-unit 1000)
(setq mew-passwd-lifetime 999)

(set-default 'mew-decode-quoted 't) 
(setq mew-auto-flush-queue t)
(setq mew-signature-file "~/.signature")
(setq mew-signature-insert-last t)
;;(setq mew-theme-file "~/.mew-theme.el")
;;(setq mew-imap-size 0) 

;;(setq mew-summary-form '(type (5 date) " " (14 from) " " t (30 subj) "|" (0 body)))
(setq mew-summary-form
      '(type (5 date) " " (-4 size) " " (14 from) " " t (30 subj) "|" (0 body)))

(setq mew-use-full-window t)

;; cite
(setq mew-cite-fields '("From:" "Subject:" "Date:" "Message-ID:"))
(setq mew-cite-format "From: %s\nSubject: %s\nDate: %s\nMessage-ID: %s\n\n")
;;

(setq mew-auto-flush-queue t)
(setq mew-auto-get t)

(condition-case nil
		    (require 'mew-w3m)
		      (file-error nil))

(setq mew-prog-text/html-ext "open")
(setq mew-mime-multipart-alternative-list '("Text/Html" "Text/Plain" "*."))
(setq mew-use-text/html t)
(setq mew-use-text-body t)

;;look
(setq mew-window-use-full t)
(setq mew-underline-lines-use t)
(setq mew-use-fancy-thread t)
(setq mew-use-fancy-highlight-body t)
(setq mew-fancy-highlight-body-prefix-width 10)
;;(setq mew-theme-file "~/.mew-theme.el")
(set-face-foreground   'mew-face-mark-delete    "red") 
(set-face-bold-p       'mew-face-mark-delete  t)
(set-face-foreground   'mew-face-mark-refile    "darkgreen") 
(set-face-bold-p       'mew-face-mark-refile  t)
(set-face-bold-p       'mew-face-mark-review  t)
(set-face-bold-p       'mew-face-mark-unread  t)

(setq mew-use-suffix t)

;;;EOF
