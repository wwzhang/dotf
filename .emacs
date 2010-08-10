;;Load path
(add-to-list 'load-path "~/emacs/elisp/")
(add-to-list 'load-path "~/emacs/elisp/Config/")
(add-to-list 'load-path "~/emacs/elisp/muse/")
(add-to-list 'load-path "~/emacs/elisp/remember/")
;;(add-to-list 'load-path "~/emacs/elisp/emms/")
(add-to-list 'load-path "~/emacs/elisp/color-theme-6.6.0/")
(add-to-list 'load-path "~/emacs/elisp/mew")
(add-to-list 'load-path "~/emacs/elisp/jabber")
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/texlive/2009/bin/universal-darwin"))
(setq exec-path (append exec-path '("/usr/local/texlive/2009/bin/universal-darwin")))
(setenv "PATH" (concat (getenv "PATH") "~/bin"))
(setq exec-path (append exec-path '("~/bin")))
(add-to-list 'load-path "~/emacs/elisp/auctex")
(add-to-list 'load-path "~/emacs/elisp/nav")


;;(add-to-list 'load-path "~/emacs/elisp/goby/")
;; ;;Load my config
(load-file "~/emacs/elisp/Config/myautorun.elc")
(load-file "~/emacs/elisp/Config/mydired.elc")
(load-file "~/emacs/elisp/Config/myenv.elc")
(load-file "~/emacs/elisp/Config/mylatex.el")
(load-file "~/emacs/elisp/Config/mymuse.el")
(load-file "~/emacs/elisp/Config/hippie-config.elc")
(load-file "~/emacs/elisp/Config/myorg.elc")
;;(load-file "~/emacs/elisp/twit.el")
;;(load-file "~/emacs/elisp/my_emms.elc")

(add-to-list 'load-path "~/emacs/elisp/emacs-w3m/")
(if (= emacs-major-version 23)
	(require 'w3m-ems)
  (require 'w3m))
;;(require 'mime-w3m)

(require 'nav)
;; ;;default dir
 (setq default-directory "~/emacs/")
 (setq user-full-name "Wen Zhang")



(add-to-list 'default-frame-alist '(height . 100))
(add-to-list 'default-frame-alist '(width . 100))

;; ;;sentence and Chinese
(setq sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")


;; ;;keys
 (setq mac-option-modifier 'meta) ;;Sets the alt/opetion key as Meta

;; ;;flyspell
(setq-default ispell-program-name "/usr/local/bin/aspell") 
 (require 'flyspell)
 (add-hook 'text-mode-hook 'flyspell-mode)
 (setq major-mode 'text-mode)
 (setq text-mode-hook
       '(lambda nil
 	 ;;(setq fill-column 76)
 	 ;;(auto-fill-mode 1)
                                      (flyspell-mode 1)))
 (autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)
 (autoload 'flyspell-delay-command "flyspell" "Delay on command." t) 
 (autoload 'tex-mode-flyspell-verify "flyspell" "" t) 
 (add-hook 'LaTeX-mode-hook 'flyspell-mode) ;;LaTeX 
;; ;;(dolist (hook '(text-mode-hook))
;; ;;      (add-hook hook (lambda () (flyspell-mode 1))))
;; ;;    (dolist (hook '(change-log-mode-hook log-edit-mode-hook))
;; ;;      (add-hook hook (lambda () (flyspell-mode -1))))

;; ;;Notes Mode
;; (load "notesmode.el")

;; ;;Chinese;;;
;;(create-fontset-from-fontset-spec
;;   "-apple-andale mono-medium-r-normal--*-*-*-*-*-*-fontset-mac,
;;    ascii:-apple-andale mono-medium-r-normal--*-*-*-*-m-*-mac-roman,
;;    latin-iso8859-1:-apple-andale mono-medium-r-normal--*-*-*-*-m-*-mac-roman,
;;    mule-unicode-0100-24ff:-apple-andale mono-medium-r-normal--*-*-*-*-m-*-mac-roman")
;; (set-frame-font "-apple-andale mono-medium-r-normal--*-*-*-*-*-*-fontset-mac" 'keep)
;; (add-to-list 'default-frame-alist '(font . "-apple-andale mono-medium-r-normal--*-*-*-*-*-*-fontset-mac"))
(set-frame-font "Monaco-14")
;;(set-fontset-font (frame-parameter nil 'font)
;;				  'unicode '("STHeiti" . "unicode-bmp"))
(setq ns-antialias-text t)
;; (set-language-environment "Chinese-GB")
 (set-default-coding-systems 'utf-8)
 (set-keyboard-coding-system 'utf-8)
 (set-clipboard-coding-system 'utf-8)
 (set-terminal-coding-system 'utf-8)
 (prefer-coding-system 'utf-8)
;; (prefer-coding-system 'zh_CN.utf-8)
 (setq default-input-method 'MacOSX)
;;(set-fontset-font "fontset-default"
;;     'unicode '("WenQuanYi Zen Hei" . "utf-8"))

;;(eval-after-load "mime-edit"
;;  '(defadvice mime-edit-choose-charset (around my-choose-charset activate)
;;     ad-do-it
;;     (or (eq ad-return-value 'us-ascii)
;;	 (eq ad-return-value 'chinese-gb2312)
;;	 (eq ad-return-value 'iso-2022-jp)
;;	 ;;(eq ad-return-value 'iso-8859-1)
;;	 ;;(eq ad-return-value 'iso-8859-15)
;;	 (setq ad-return-value 'utf-8))
;;     ;;
;;     ))

;; ;;输入法
 ;;(mac-input-method-mode 1)
 ;;(setq default-input-method 'MacOSX)
;;(require 'wcy-pinyin)
;; (add-to-list 'load-path "~/emacs/elisp/eim")
;; (autoload 'eim-use-package "eim" "Another emacs input method")

;; ;; (register-input-method
;; ;;  "eim-wb" "euc-cn" 'eim-use-package
;; ;;  "五笔" "汉字五笔输入法" "~/elisp/eim/wb.txt")
;; (register-input-method
;;  "eim-py" "euc-cn" 'eim-use-package
;;  "拼音" "汉字拼音输入法" "~/emacs/elisp/eim/py.txt")

;; ;;使用输入法的命令为 C-x RET C-\ eim-py

;;Calendar
;; (setq calendar-latitude +31.2477)
;; (setq calendar-longitude +121.4726)
;; (setq calendar-location-name "Shanghai")
;; (require 'chinese-calendar)

;;
(show-paren-mode t)
(setq show-paren-style 'parentheses)

;;AbbrevMode
(setq abbrev-file-name             ;; tell emacs where to read abbrev
        "~/emacs/elisp/abbrev_defs")    ;; definitions from...
(setq save-abbrevs t)  
;;(abbrev-mode 1)    ;;OR below 
(setq abbrev-mode t)
(quietly-read-abbrev-file)       ;; reads the abbreviations file on startup

;;PDF-Preview
(load "pdf-preview")
;; make Command-P work to print (pdf-preview-buffer)
;;(global-set-key [(hyper p)] "\M-x pdf-preview-buffer")
;;(global-set-key [(shift hyper p)] "\M-x pdf-preview-buffer-with-faces")
;;(pdf-preview-ps2pdf-command "perl ~/bin/cjkps2pdf.pl --keepmetrics")

;; TURN off tool bar and scroll bar
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;;(tool-bar-mode -1)

;;fast browse 		
;;(setq lazy-lock-defer-on-scrolling t)
;;(setq font-lock-support-mode 'lazy-lock-mode)
;;(setq font-lock-maximum-decoration t)

;;html-view
(autoload 'htmlize-view-buffer "htmlize-view" nil t)


;;Mew
  (if (boundp 'read-mail-command)
      (setq read-mail-command 'mew))
  (autoload 'mew-user-agent-compose "mew" nil t)
  (if (boundp 'mail-user-agent)
      (setq mail-user-agent 'mew-user-agent))
  (if (fboundp 'define-mail-user-agent)
      (define-mail-user-agent
         'mew-user-agent
         'mew-user-agent-compose
         'mew-draft-send-message
         'mew-draft-kill
         'mew-send-hook))
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)

;;skeletons
(load-file "~/emacs/elisp/skel-html.el")

;;html-help-mode
(setq html-helper-build-new-buffer nil) 


(put 'dired-find-alternate-file 'disabled nil)

;;autocompile
(defun byte-compile-init-file ()
   (when (equal user-init-file buffer-file-name)
     (when (file-exists-p (concat user-init-file ".elc"))
       (delete-file (concat user-init-file ".elc")))
     (byte-compile-file user-init-file)))
 (add-hook 'after-save-hook 'byte-compile-init-file)

;;Ido 
(require 'ido)
(ido-mode t)
(add-to-list 'ido-ignore-files "\.DS_Store")


(setq major-mode 'text-mode)
;;(add-hook 'text-mode-hook 'turn-on-auto-fill)

(setq auto-compression-mode 1)

;;Form happierbee@SMTH to remove ANSI-color in file
(require 'ansi-color)
(defun my-ansi-color-filter-region (beg end)
  (interactive "r")
  (ansi-color-filter-region beg end))

;;color-theme
(require 'color-theme)
(color-theme-initialize)
(color-theme-dark-laptop)

;;Transparency
(modify-frame-parameters (selected-frame) '((alpha . 89)))

(require 'remember)
(setq remember-data-file "~/emacs/notes.txt")  ;; (2)
(global-set-key (kbd "C-c r") 'remember) ;; (3)

(defun wicked/remember-review-file ()
 "Open `remember-data-file'."
 (interactive)
 (find-file-other-window remember-data-file))
(global-set-key (kbd "C-c R") 'wicked/remember-review-file) ;; (4)

(require 'tramp)
(setq tramp-default-method "ssh")

;;设定文档上次保存的信息
;;只要里在你得文档里有Time-stamp:的设置，就会自动保存时间戳
;;启用time-stamp
(setq time-stamp-active t)
;;去掉time-stamp的警告？
(setq time-stamp-warn-inactive t)
;;设置time-stamp的格式，我如下的格式所得的一个例子：<hans 05/18/2004 12:01:12>
(setq time-stamp-format "%02m-%02d-%04y")
;;将修改时间戳添加到保存文件的动作里。
(add-hook 'write-file-hooks 'time-stamp)

;;Markdown-mod
     (autoload 'markdown-mode "markdown-mode.el"
        "Major mode for editing Markdown files" t)
     (setq auto-mode-alist
        (cons '("\\.text" . markdown-mode) auto-mode-alist))

;;ECB
;;(add-to-list 'load-path
;;	     "$HOME/emacs/elisp/ecb-snap")
;;(load-file "$HOME/emacs/elisp/ecb-snap/ecb.el")
;;(require 'ecb-autoloads)


(server-start)
(require 'nav)

