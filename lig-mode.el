;; -*- lexical-binding: t; -*-

;;; Lig-mode

(add-to-list 'auto-mode-alist '("\\.lig\\'" . lig-mode))

(define-derived-mode lig-mode fundamental-mode "Lig"
  (setq-local indent-line-function 'lisp-indent-line)
  (setq-local syntax-propertize-function 'lig-syntax-propertize-function))

(defun lig--match-lig (limit)
  (re-search-forward (rx word-start "hello" word-end) limit t))

(defun lig-mod-hook (overlay post-mod? start end &optional _)
  (when post-mod?
    (overlay-put overlay 'display nil)
    (overlay-put overlay 'modification-hooks nil)))

(defun lig-syntax-propertize-function (start-limit end-limit)
  (save-excursion
    (goto-char (point-min))

    (while (lig--match-lig end-limit)
      (let ((start (match-beginning 0))
            (end (match-end 0)))

        (setq lig-overlay (make-overlay start end))
        (overlay-put lig-overlay 'display "")
        (overlay-put lig-overlay 'modification-hooks '(lig-mod-hook))

        (save-excursion
          (forward-line)
          (put-text-property (point) (+ 3 (point)) 'invisible t))))))

(provide 'lig-mode)


(defun lig-diff-in-indent (start end)
  (compose-region start end "")

  (save-excursion
    (forward-line)
    (funcall (symbol-value 'indent-line-function))
    (setq composed-indent (current-indentation)))

  (decompose-region start end)

  (save-excursion
    (forward-line)
    (funcall (symbol-value 'indent-line-function))
    (setq uncomposed-indent (current-indentation))))


;;; Scratch

;; `text-property-any'
;; `text-properties-at'
;; '(?\s (Br . Bl) ?\s)
;; '(?\s (Br . Bl) ?\s (Br . Bl) ?\s)
;; (prettify-utils-generate (" " "  "))
