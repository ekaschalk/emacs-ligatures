;; -*- lexical-binding: t; -*-

;;; Lig-mode
;;;; Core
(add-to-list 'auto-mode-alist '("\\.lig\\'" . lig-mode))

(define-derived-mode lig-mode fundamental-mode "Lig"
  (setq-local indent-line-function 'lisp-indent-line)
  (setq-local syntax-propertize-function 'lig-syntax-propertize-function))

(defun lig--match-lig (limit)
  (re-search-forward (rx word-start "hello" word-end) limit t))

;;;; Indents

(defun lig-diff-in-indent (start end num-lines)
  (compose-region start end "")

  (save-excursion
    (dotimes (i num-lines)
      (forward-line)
      (funcall (symbol-value 'indent-line-function))
      (setq composed-indent (current-indentation))))

  (decompose-region start end)

  (save-excursion
    (dotimes (i num-lines)
      (forward-line)
      (funcall (symbol-value 'indent-line-function))
      (setq uncomposed-indent (current-indentation))))

  (- uncomposed-indent composed-indent))

;;;; Overlay management

(defun lig-mod-hook (overlay post-mod? start end &optional _)
  (when post-mod?
    (overlay-put overlay 'display nil)
    (overlay-put overlay 'modification-hooks nil)))

;;;; Syntax propertize

(defun lig-syntax-propertize-function (start-limit end-limit)
  (save-excursion
    (goto-char (point-min))

    (while (lig--match-lig end-limit)
      (let ((start (match-beginning 0))
            (end (match-end 0)))

        (unless (-contains? (overlays-at start) lig-overlay)
          (setq lig-overlay (make-overlay start end))
          (overlay-put lig-overlay 'display "")
          (overlay-put lig-overlay 'evaporate t)
          (overlay-put lig-overlay 'modification-hooks '(lig-mod-hook)))

        (setq num-lines 1)
        (save-excursion
          (while (> (lig-diff-in-indent start end num-lines) 0)
            (forward-line num-lines)
            (put-text-property (point) (+ 3 (point)) 'invisible t)
            ;; (compose-region (point) (+ 4 (point)) ?\s)

            (setq num-lines (1+ num-lines))
          ))))))

(provide 'lig-mode)
