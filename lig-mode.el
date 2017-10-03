(add-to-list 'auto-mode-alist '("\\.lig\\'" . lig-mode))

(defconst lig--font-lock-kwds
  (list
   (rx "hello")
   '(0 font-lock-constant-face)))

(setq lig-font-lock-kwds
      (list lig--font-lock-kwds))

(define-derived-mode lig-mode fundamental-mode "Lig"
  (setq font-lock-defaults '(lig-font-lock-kwds))
  (setq-local indent-line-function 'lisp-indent-line)
  (setq-local syntax-propertize-function 'lig-syntax-propertize-function))

(defun lig--match-lig (limit)
  (re-search-forward
   (rx word-start
       "hello"
       word-end)
   limit
   t))

(defun lig-syntax-propertize-function (start end)
  (save-excursion
    (goto-char start)

    (while (lig--match-lig end)
      (compose-region (match-beginning 0)
                      (match-end 0)
                      #xe907)

      )))

(provide 'lig-mode)
