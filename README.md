# emacs_setup
Put .emacs and emacs/ in home directory and change /home/sumitj to correct path of home directory in .emacs

# autocompletion mode
a. Alt-x list-packages
b. select company from melpa and install it
c. Add following to .emacs :
   (add-hook 'after-init-hook 'global-company-mode)
   
This will enable auto-completion in all buffers.

