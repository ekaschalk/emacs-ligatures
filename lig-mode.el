;; -*- lexical-binding: t; -*-

;;; Lig-mode
;;;; Core
(add-to-list 'auto-mode-alist '("\\.lig\\'" . lig-mode))

(define-derived-mode lig-mode fundamental-mode "Lig"
  (setq-local indent-line-function 'lisp-indent-line)
  (setq-local syntax-propertize-function 'lig-syntax-propertize-function))

(defun lig--match-lig (limit)
  (re-search-forward (rx word-start "hello" word-end) limit t))

;;;; Overlay management

(defun lig-mod-hook (overlay post-mod? start end &optional _)
  (when post-mod?
    (overlay-put overlay 'display nil)
    (overlay-put overlay 'modification-hooks nil)))

;;;; Syntax propertize

(defun lig-syntax-propertize-function (start-limit end-limit)
  (run-lig-get-diff-indents)

  (save-excursion
    (goto-char (point-min))

    (while (lig--match-lig end-limit)
      (let ((start (match-beginning 0))
            (end (match-end 0)))

        ;; Create and set the lig overlays
        (unless (-contains? (overlays-at start) lig-overlay)
          (setq lig-overlay (make-overlay start end))
          (overlay-put lig-overlay 'display "")
          (overlay-put lig-overlay 'evaporate t)
          (overlay-put lig-overlay 'modification-hooks '(lig-mod-hook)))))

    (remove-overlays nil nil 'invis-spaces t)

    ;; add spacing overlays
    (goto-char (point-min))
    (setq line 1)
    (while (< (point) (point-max))
      (unless (> (+ (current-indentation) (point))
                 (point-max))
        (let* ((vis-indent (alist-get line lig-diff-indents))
               (num-spaces (- (current-indentation)
                              vis-indent))
               (start (point))
               (end (+ num-spaces (point))))

         (unless (<= num-spaces 1)
            (setq space-overlay (make-overlay start end))
            (overlay-put space-overlay 'invis-spaces t)
            (overlay-put space-overlay 'display " ")
            (overlay-put space-overlay 'evaporate t))

          (setq line (1+ line))
          (forward-line))))))

;;;; Diff indent calculations

(defvar lig-diff-indents nil)

(defun lig-get-diff-indents ()
  (setq lig-diff-indents nil)
  (save-excursion
    (goto-char (point-min))

    (while (re-search-forward (rx word-start "hello" word-end) nil t)
      (compose-region (match-beginning 0) (match-end 0) #xe907))

    (indent-region (point-min) (point-max))

    (goto-char (point-min))
    (setq line 1)
    (while (< (point) (point-max))
      (push (cons line (current-indentation))
            lig-diff-indents)
      (forward-line)
      (setq line (1+ line)))))

(defun run-lig-get-diff-indents ()
  (let ((true-buffer (current-buffer)))
    (with-temp-buffer
      (fundamental-mode)
      (setq-local indent-line-function 'lisp-indent-line)
      (insert-buffer-substring-no-properties true-buffer)
      (lig-get-diff-indents))))

(provide 'lig-mode)
