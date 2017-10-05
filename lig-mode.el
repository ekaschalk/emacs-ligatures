;; -*- lexical-binding: t; -*-

;;; Lig-mode
;;;; Core
(add-to-list 'auto-mode-alist '("\\.lig\\'" . lig-mode))

(define-derived-mode lig-mode fundamental-mode "Lig"
  (setq-local indent-line-function 'lisp-indent-line)
  ;; (setq-local syntax-propertize-function 'lig-syntax-propertize-function)
  (setq-local syntax-propertize-function nil)
  )

(defun lig--match-lig (limit)
  (re-search-forward (rx word-start "hello" word-end) limit t))

;;;; Overlay management

(defun lig-mod-hook (overlay post-mod? start end &optional _)
  (when post-mod?
    (overlay-put overlay 'display nil)
    (overlay-put overlay 'modification-hooks nil)))

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
            (compose-region (point) (+ 4 (point)) ?\s)

            (setq num-lines (1+ num-lines))
          ))))))

(defvar lig-diff-indents nil)

(defun lig-get-diff-indents ()
  (setq lig-diff-indents nil)
  (save-excursion
    (goto-char (point-min))

    (while (re-search-forward (rx word-start "hello" word-end) nil t)
      (compose-region (match-beginning 0) (match-end 0) #xe907))

    (indent-region (point-min) (point-max))

    (goto-char (point-min))

    (setq i 1)
    (while (< (point) (point-max))
      (push (cons i (current-indentation))
            lig-diff-indents)
      (forward-line)
      (setq i (1+ i)))))

(defun test ()
  (let ((true-buffer (current-buffer)))
    (with-temp-buffer
      (insert-buffer-substring true-buffer)
      (lig-get-diff-indents)
      lig-diff-indents
      )))


(provide 'lig-mode)
