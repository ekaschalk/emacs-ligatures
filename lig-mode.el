(add-to-list 'auto-mode-alist '("\\.lig\\'" . lig-mode))

(define-derived-mode lig-mode fundamental-mode "Lig"
  (setq font-lock-defaults '(lig-font-lock-kwds))
  (setq-local indent-line-function 'lisp-indent-line))

(defconst lig--font-lock-kwds
  (list
   (rx "hello")
   '(0 font-lock-constant-face)))

(setq lig-font-lock-kwds
      (list lig--font-lock-kwds))

(provide 'lig-mode)
