;; Notes
;; invisible text is ignored by indentation

;; Thoughts
;; what I make one space expand to many
;;


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

;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Specified-Space.html#Specified-Space
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Special-Properties.html#index-composition-_0040r_007b_0028text-property_0029_007d-3102

(defun lig-mod-hook (overlay post-mod? start end &optional x)
  (when post-mod?
    (overlay-put overlay 'display nil)
    (overlay-put overlay 'modification-hooks nil)
    ))

(defun lig-syntax-propertize-function (start end)
  (save-excursion
    ;; (goto-char (point-min))
    (goto-char start)

    (while (lig--match-lig end)
      ;; (compose-region (match-beginning 0) (match-end 0)
      ;;                 #xe907)
      ;; (put-text-property (match-beginning 0) (match-end 0)
      ;;                    'display
      ;;                    "")

      ;; (put-text-property (match-beginning 0) (match-end 0)
      ;;                    'invisible
      ;;                    t)

      (setq lig-overlay
            (make-overlay (match-beginning 0) (match-end 0)))
      (overlay-put lig-overlay 'display "")
      (overlay-put lig-overlay 'modification-hooks
                   '(lig-mod-hook)
                   )

      ;; (overlay-put lig-overlay 'invisible t)

      ;; (put-text-property (match-beginning 0) (1- (match-end 0))
      ;;                    'invisible
      ;;                    t)

      ;; (put-text-property (match-beginning 0) (match-end 0)
      ;;                    'modification-hooks
      ;;                    '(lig-mod-hook)
      ;;                    )

      ;; (save-excursion
      ;;   (forward-line)
      ;;   )
      )))

(provide 'lig-mode)

;;; Scratch
;;;; Scratch composition

;; (compose-region (point) (+ 3 (point))
;;                 ?\s)

;; (unless (text-property-any (point) (1+ (point))
;;                            'bigger t)

;;   (compose-region (point) (+ 3 (point))
;;                   ?\s))

;; (put-text-property (point) (1+ (point))
;;                    'bigger t)


;;   (compose-region (point) (1+ (point))
;;                   '(?\s (Br . Bl) ?\s))
;;   )

;; (put-text-property (point) (1+ (point))
;;                    'bigger t)

;; maybe I insert an invisible number of spaces on next line?
;; what if I do the opposite - and shrink the spaces on next line
;; and have the indentation adjust itself automatically?

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
