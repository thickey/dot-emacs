(live-add-pack-lib "nrepl")
(require 'nrepl )

(defun live-windows-hide-eol ()
 "Do not show ^M in files containing mixed UNIX and DOS line endings."
 (interactive)
 (setq buffer-display-table (make-display-table))
 (aset buffer-display-table ?\^M []))

(when (eq system-type 'windows-nt)
  (add-hook 'nrepl-mode-hook 'live-windows-hide-eol ))

(defun my-form-printing-handler (buffer form)
  (lexical-let ((form form))
    (nrepl-make-response-handler buffer
                                 (lambda (buffer value)
                                   (nrepl-emit-result buffer (format "%s" form) t)
                                   (nrepl-emit-result buffer (format "%s" value) t))
                                 (lambda (buffer out)
                                   (nrepl-emit-output buffer out t))
                                 (lambda (buffer err)
                                   (nrepl-emit-output buffer err t))
                                 (lambda (buffer)
                                   (nrepl-emit-prompt buffer)))))

;; (defun my-interactive-eval-to-repl (form)
;;   (let ((buffer nrepl-nrepl-buffer))
;;   (nrepl-send-string form (my-form-printing-handler buffer form) nrepl-buffer-ns)))

(defun my-interactive-eval-to-repl (form)
  (nrepl-send-string form
    (my-form-printing-handler (nrepl-current-repl-buffer) form)
    (nrepl-current-ns)))

(defun my-eval-last-expression-to-repl ()
  (interactive)
  (my-interactive-eval-to-repl (nrepl-last-expression)))

(defun my-eval-expression-at-point (&optional prefix)
  "Evaluate the current toplevel form."
  (interactive "P")
  (let ((form (nrepl-expression-at-point)))
    (if prefix
        (nrepl-interactive-eval-print form)
      (my-interactive-eval-to-repl form))))

(add-hook 'nrepl-interaction-mode-hook
          (lambda ()
            (nrepl-turn-on-eldoc-mode)
            (enable-paredit-mode)
            (define-key nrepl-interaction-mode-map
              (kbd "C-x C-e") 'my-eval-last-expression-to-repl)
            (define-key nrepl-interaction-mode-map
              (kbd "C-M-x") 'my-eval-expression-at-point)))

(add-hook 'nrepl-repl-mode-hook
          (lambda ()
            (nrepl-turn-on-eldoc-mode)
            (enable-paredit-mode)
            (define-key nrepl-repl-mode-map
              (kbd "{") 'paredit-open-curly)
            (define-key nrepl-repl-mode-map
              (kbd "}") 'paredit-close-curly)
            (linum-mode 0)))

(setq nrepl-popup-stacktraces nil)
;; TH: fuck that (add-to-list 'same-window-buffer-names "*nrepl*")

;;Auto Complete
(live-add-pack-lib "ac-nrepl")
(require 'ac-nrepl )
(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
(add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)

(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'nrepl-mode))

;;; Monkey Patch nREPL with better behaviour:

;;; Region discovery fix
(defun nrepl-region-for-expression-at-point ()
  "Return the start and end position of defun at point."
  (when (and (live-paredit-top-level-p)
             (save-excursion
               (ignore-errors (forward-char))
               (live-paredit-top-level-p)))
    (error "Not in a form"))

  (save-excursion
    (save-match-data
      (ignore-errors (live-paredit-forward-down))
      (paredit-forward-up)
      (while (ignore-errors (paredit-forward-up) t))
      (let ((end (point)))
        (backward-sexp)
        (list (point) end)))))

;;; Windows M-. navigation fix
(defun nrepl-jump-to-def (var)
  "Jump to the definition of the var at point."
  (let ((form (format "((clojure.core/juxt
                         (comp (fn [s] (if (clojure.core/re-find #\"[Ww]indows\" (System/getProperty \"os.name\"))
                                           (.replace s \"file:/\" \"file:\")
                                           s))
                               clojure.core/str
                               clojure.java.io/resource :file)
                         (comp clojure.core/str clojure.java.io/file :file) :line)
                        (clojure.core/meta (clojure.core/resolve '%s)))"
                      var)))
    (nrepl-send-string form
                       (nrepl-jump-to-def-handler (current-buffer))
                       (nrepl-current-ns)
                       (nrepl-current-tooling-session))))

(setq nrepl-port "4555")

(setq nrepl-history-file "~/.nrepl-history.eld")
