;;; ~/emacs/lisp/efuncs.el

;; Different platforms use different line endings
(defun unix-file ()
  "Change the current buffer to Latin 1 with Unix line-ends."
  (interactive)
  (set-buffer-file-coding-system 'iso-latin-1-unix t))

(defun dos-file ()
  "Change the current buffer to Latin 1 with DOS line-ends."
  (interactive)
  (set-buffer-file-coding-system 'iso-latin-1-dos t))

(defun mac-file ()
  "Change the current buffer to Latin 1 with Mac line-ends."
  (interactive)
  (set-buffer-file-coding-system 'iso-latin-1-mac t))

;; Steve Yegge's syntax highlighting->HTML transformer
;; http://steve.yegge.googlepages.com/saving-time
(defun syntax-highlight-region (start end)
  "Adds <font> tags into the region that correspond to the
current color of the text.  Throws the result into a temp
buffer, so you don't dork the original."
  (interactive "r")
  (let ((text (buffer-substring start end)))
    (with-output-to-temp-buffer "*html-syntax*"
      (set-buffer standard-output)
      (insert "<pre>")
      (save-excursion (insert text))
      (save-excursion (syntax-html-escape-text))
      (while (not (eobp))
	(let ((plist (text-properties-at (point)))
	      (next-change
	       (or (next-single-property-change
		    (point) 'face (current-buffer))
		   (point-max))))
	  (syntax-add-font-tags (point) next-change)
	  (goto-char next-change)))
      (insert "\n</pre>"))))

(defun syntax-add-font-tags (start end)
  "Puts <font> tag around text between START and END."
  (let (face color rgb name r g b)
    (and
     (setq face (get-text-property start 'face))
     (or (if (listp face) (setq face (car face))) t)
     (setq color (face-attribute face :foreground nil t))
     (setq rgb (assoc (downcase color) color-name-rgb-alist))
     (destructuring-bind (name r g b) rgb
       (let ((text (buffer-substring-no-properties start end)))
	 (delete-region start end)
	 (insert (format "<font color=#%.2x%.2x%.2x>" r g b))
	 (insert text)
	 (insert "</font>"))))))

(defun syntax-html-escape-text ()
  "HTML-escapes all the text in the current buffer,
starting at (point)."
  (save-excursion (replace-string "<" "&lt;"))
  (save-excursion (replace-string ">" "&gt;")))

;; Support for copying fontified regions to the Windows clipboard
(require 'htmlize)
(and (eq window-system 'w32)
     (defun w32-fontified-region-to-clipboard (start end)
       "Htmlizes region, saves it as a html file, scripts Microsoft Word to
open in the background and to copy all text to the clipboard, then
quits. Useful if you want to send fontified source code snippets to
your friends using RTF-formatted e-mails.

Version: 0.2

Author:

Mathias Dahl, <mathias@cucumber.dahl.net>. Remove the big, green
vegetable from my e-mail address...

Requirements:

* htmlize.el
* wscript.exe must be installed and enabled
* Microsoft Word must be installed

Usage:

Mark a region of fontified text, run this function and in a number of
seconds you have the whole colorful text on your clipboard, ready to
be pasted into a RTF-enabled application.

"
       (interactive "r")
       (let ((snippet (buffer-substring start end))
	     (buf (get-buffer-create "*htmlized_to_clipboard*"))
	     (script-file-name (expand-file-name "~/tmp/htmlized_to_clipboard.vbs"))
	     (htmlized-file-name (expand-file-name "~/tmp/htmlized.html")))
	 (set-buffer buf)
	 (erase-buffer)
	 (insert snippet)
	 (let ((tmp-html-buf (htmlize-buffer)))
	   (set-buffer tmp-html-buf)
	   (write-file htmlized-file-name)
	   (kill-buffer tmp-html-buf))
	 (set-buffer buf)
	 (erase-buffer)
	 (setq htmlized-file-name 
	       (substitute ?\\ ?/ htmlized-file-name))
	 (insert
	  (concat
	   "Set oWord = CreateObject(\"Word.Application\")\n"
	   "oWord.Documents.Open(\"" htmlized-file-name "\")\n"
	   "oWord.Selection.HomeKey 6\n"
	   "oWord.Selection.EndKey 6,1\n"
	   "oWord.Selection.Copy\n"
	   "oWord.Quit\n"
	   "Set oWord = Nothing\n"))
	 (write-file script-file-name)
	 (kill-buffer nil)
	 (setq script-file-name
	       (substitute ?\\ ?/ script-file-name))
	 (w32-shell-execute nil "wscript.exe" 
			    script-file-name))))

;; Clear shell contents
(defun shell-clear-region ()
  (interactive)
  (delete-region (point-min) (point-max))
  (comint-send-input))

;; Quick and dirty code folding
(defun toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (if selective-display nil (or column 1))))


;;; Slick copy for C-w and M-w to copy and kill current line without selection
;;; http://www.emacswiki.org/emacs/SlickCopy

    (defadvice kill-ring-save (before slick-copy activate compile)
      "When called interactively with no active region, copy a single line instead."
      (interactive
       (if mark-active (list (region-beginning) (region-end))
         (message "Copied line")
         (list (line-beginning-position)
               (line-beginning-position 2)))))

    (defadvice kill-region (before slick-cut activate compile)
      "When called interactively with no active region, kill a single line instead."
      (interactive
       (if mark-active (list (region-beginning) (region-end))
         (list (line-beginning-position)
               (line-beginning-position 2)))))


;;; end ~/emacs/lisp/efuncs.el
