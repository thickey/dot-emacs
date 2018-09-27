(live-add-pack-lib "color-theme")
(require 'color-theme)

(global-hl-line-mode 1)

;; use blackbored colour theme
(load-file (concat (live-pack-lib-dir) "cyberpunk.el"))
(load-file (concat (live-pack-lib-dir) "gandalf.el"))
;; (load-file (concat (live-pack-lib-dir) "color-theme-tomorrow.el"))

(color-theme-cyberpunk)
;; (color-theme-tomorrow-night)

(set-cursor-color "yellow")
