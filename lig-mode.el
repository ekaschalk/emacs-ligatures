;; -*- lexical-binding: t; -*-

;; Notes
;; invisible text is ignored by indentation
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Specified-Space.html#Specified-Space
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Special-Properties.html#index-composition-_0040r_007b_0028text-property_0029_007d-3102

;;; Lig-mode

(add-to-list 'auto-mode-alist '("\\.lig\\'" . lig-mode))

(define-derived-mode lig-mode fundamental-mode "Lig"
  ;; (setq font-lock-defaults '(lig-font-lock-kwds))
  (setq-local indent-line-function 'lisp-indent-line)
  (setq-local syntax-propertize-function 'lig-syntax-propertize-function))

(defun lig--match-lig (limit)
  (re-search-forward
   (rx word-start
       "hello"
       word-end)
   limit
   t))

(defun lig-mod-hook (overlay post-mod? start end &optional x)
  (when post-mod?
    (overlay-put overlay 'display nil)
    (overlay-put overlay 'modification-hooks nil)
    ))

(defun lig-syntax-propertize-function (start end)
  (save-excursion
    ;; (goto-char start)
    (goto-char (point-min))

    (while (lig--match-lig end)
      (let ((start (match-beginning 0))
            (end (match-end 0)))

        ;; (setq lig-overlay
        ;;       (make-overlay (match-beginning 0) (match-end 0)))
        ;; (overlay-put lig-overlay 'display
        ;;              "")
        ;; (overlay-put lig-overlay 'modification-hooks
        ;;              '(lig-mod-hook))

        (compose-region start end "")

        (save-excursion
          (next-line)
          (funcall (symbol-value 'indent-line-function))
          (print (current-indentation))
          )

        (decompose-region start end)

        (save-excursion
          (next-line)
          (funcall (symbol-value 'indent-line-function))
          (print (current-indentation))
          )
        )
      )))

(provide 'lig-mode)

;;; Scratch
;;;; Scratch composition

;; `text-property-any'
;; `text-properties-at'
;; '(?\s (Br . Bl) ?\s)
;; '(?\s (Br . Bl) ?\s
;;       (Br . Bl) ?\s
;;       (Br . Bl) ?\s
;;       (Br . Bl) ?\s
;;       (Br . Bl) ?\s)
;; (prettify-utils-generate (" " "  "))

;;;; Scratch font lock

;; (defconst lig--font-lock-kwds
;;   (list
;;    (rx "hello")
;;    '(0 font-lock-constant-face)
;;    ))

;; (setq lig-font-lock-kwds
;;       (list lig--font-lock-kwds))
