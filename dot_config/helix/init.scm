;; ---------------
;; Vim Keybindings
;; ---------------
(require "vim-hx/init.scm")

;; Add this to your init.scm
(set-vim-keybindings!)

;; ---------------
;; Oil
;; ---------------
(require "oil/oil.scm")

;; Optional: display messages as notify.hx popups.
;; Install notify.hx (see README) and uncomment the next line.
;; (require "oil/oil-notify.scm")

;; Optional: set defaults (both #false by default)
;; (oil-configure! show-dotfiles show-git-ignored)
(oil-configure! #false #false)
