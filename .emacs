;;; ~/.emacs
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'cl)
(require 'linum)
(global-linum-mode t)
(setq-default left-fringe-width  20)
(setq-default right-fringe-width  5)
(setq linum-format "%4d \u2502 ")
(set-face-attribute 'fringe nil :background "black")

(setq x-alt-keysym `meta)
(setq mac-option-key-is-meta t)



(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "https://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))

;; I keep everything under ~/emacs
(defvar emacs-root (cond ((eq system-type 'cygwin) "/home/sumitj/")
			 ((eq system-type 'gnu/linux) "/home/sumitj/")
			 ((eq system-type 'linux) "/home/sumitj/")
			 ((eq system-type 'darwin) "/home/sumitj/")
			 (t "c:/root/"))
  "My home directory -- the root of my personal emacs load-path")


;; Add all the elisp directories under ~/emacs to my load path
(labels ((add-path (p) (add-to-list 'load-path (concat emacs-root p))))
  (add-path "emacs/lisp")            		;; all my personal elisp code
  (add-path "emacs/site-lisp")			;; elisp stuff from the net
  (add-path "emacs/site-lisp/color-theme")	;; http://www.emacswiki.org/cgi-bin/wiki?ColorTheme
  (add-path "emacs/site-lisp/erlang")		;; file:/usr/lib64/erlang/lib/tools-2.5.2/emacs
  (add-path "emacs/site-lisp/git-emacs")	;; git://github.com/tsgates/git-emacs.git
  (add-path "emacs/site-lisp/nxml-mode")	;; http://www.thaiopensource.com/nxml-mode
  (add-path "emacs/site-lisp/ruby-mode")	;; http://svn.ruby-lang.org/repos/ruby/trunk/misc/ruby-mode
  (add-path "emacs/site-lisp/speedbar")		;; http://cedet.sourceforge.net/speedbar.shtml
  (add-path "emacs/site-lisp/dash")             ;; elpa package repository download
  (add-path "emacs/site-lisp/flycheck")         ;; elpa package repository download
  (add-path "emacs/site-lisp/company")         ;; elpa package repository download for company plugin
  (add-path "gocode/src/github.com/dougm/goflymake") ;; flymake for go (uses flycheck).
  (add-path "gocode/src/github.com/nsf/gocode/emacs-company") ;; gocode for go
  )

;; The remainder of my config is in libraries
(load-library "efuncs")				;; custom functions
(load-library "ekeys")				;; key bindings
(load-library "cc-config")			;; C/C++ mode config
(load-library "dired-config")			;; dired-mode config
(load-library "erl-config")			;; Erlang mode config
(load-library "git-config")			;; Git mode config
;;(load-library "irc-config")			;; IRC client config
(load-library "misc-config")			;; miscellaneous one-off config settings
(load-library "p4-config")			;; Perforce config
(load-library "ruby-config")			;; Ruby mode config
(load-library "scons-config")			;; scons-related config
(load-library "screen-config")			;; window config
(load-library "shell-config")			;; shell config
(load-library "skeleton-config")		;; skeleton config
(load-library "xml-config")			;; XML mode config
(load-library "xcscope")			;; cscope config
(load-library "flymake")                        ;; flymake
(load-library "markdown-mode")                  ;; markdown-mode http://jblevins.org/projects/markdown-mode/markdown-mode.el
;;(load-library "flycheck-global")                ;; enable flycheck globally
(load-library "go-config")                      ;; go config 
;;(load-library "flycheck-autoloads")
;;(load-library "go-flymake")
;;(load-library "go-flycheck")
;;(load-library "go-code")
(load-library "sudo-ext")                       ;; sudo extension emacs wiki
(server-start)					;; start the emacs server running

;;; end ~/.emacs
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(grep-command "grep -nH -i -r ")
 '(package-selected-packages (quote (auto-complete))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Extention for finding the particular file in a project folder
;; Project is analysed according to .git file
(require `find-file-in-project)

;; Neotree - a directory view for emacs
;; files folders and everything can be searched
(add-to-list 'load-path "~/emacs/neotree")
(require `neotree)
(global-set-key (kbd "C-c C-d") 'neotree-toggle)

(global-auto-complete-mode t)
(normal-erase-is-backspace-mode)
