;;make sure ansi colour character escapes are honoured
(require 'ansi-color)
(ansi-color-for-comint-mode-on)

(setq font-lock-maximum-decoration t
      color-theme-is-global t)

;; Line-wrapping
(set-default 'fill-column 72)
;;(global-visual-line-mode t)

;get rid of clutter
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;remove bells
(setq ring-bell-function 'ignore)

;; TH: this causes the custom-set-faces code to fail when changing font size
(cond
 ((and (window-system) (eq system-type 'darwin))
  (add-to-list 'default-frame-alist '(font . "Menlo-13"))))

;; TH: set font for presenting
;; (set-default-font "Menlo-20")
;; reset
;; (set-default-font "Menlo-13")

;; TH: trying out Source Code Pro
;; (set-default-font "Source Code Pro-15")

;; make fringe smaller
(if (fboundp 'fringe-mode)
    (fringe-mode 4))

(setq ring-bell-function 'ignore)

(global-linum-mode 1)


;; TH: fix issue with line number getting cut off
;; http://www.emacswiki.org/LineNumbers
(setq linum-format " %d ")


(setq split-height-threshold 99999)

;;
;; fonts
;;
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:inherit nil :stipple nil :background nil :foreground nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 180 :width normal :foundry "apple" :family "Menlo")))))
;; ;; :height 110

;; ;; (set-face-attribute 'default nil :height 120)
;; ;; (set-face-attribute 'default nil :foundry "apple")
;; ;; (set-face-attribute 'default nil :family "Menlo")
;; ;; (setq-default line-spacing 1) ;; 1 pixel
;; (setq-default line-spacing 0.1) ;; 10% of line-height
;; (set-face-attribute 'default nil :height 180)

;; ;; desperately trying something
;; ;; http://www.linuxquestions.org/questions/linux-software-2/emacs-changing-default-font-size-and-font-type-489000/
;; ;; (set-default-font "-adobe-courier-medium-r-normal--18-180-75-75-m-110-iso8859-1")

;; ;; fontifying *clime-compilation is a killer http://random-state.net/log/3512630740.html
;; (setq font-lock-verbose nil)
