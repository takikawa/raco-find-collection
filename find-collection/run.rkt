#lang racket/base

(require "find-collection.rkt"
         racket/cmdline
         racket/list)

;; a parameter that controls whether the user is asked
;; when the collection path needs disambiguation
(define interactive-mode (make-parameter #f))

;; print current directory (for use in scripts) and
;; re-raise the exception to print it to stderr
(define (fail e)
  (displayln (path->string (current-directory)))
  (raise e))

;; allow user to select the path option
(define (select choices)
  (define stderr (current-error-port))
  (define choices-string
    (apply string-append
           (for/list ([(choice idx) (in-indexed (in-list choices))])
             (format "(~a) ~a~n" idx choice))))
  ;; these prompts ask the user via stderr, which is hacky
  (displayln "Ambiguous collection path, please select one:" stderr)
  (display choices-string stderr)
  (flush-output)
  (let loop ()
    (define line (read-line))
    (define user# (string->number line))
    (cond [(and user#
                (member user# (range 0 (length choices))))
           (displayln (list-ref choices user#))]
          [else
           (displayln (format "Invalid choice `~a', please choose again" line)
                      stderr)
           (loop)])))

(with-handlers ([exn:fail? fail])
  (command-line
   #:once-each
   [("-i" "--interactive") "Ask when disambiguation is needed"
                           (interactive-mode #t)]
   #:args (collection-path)
   (let ([dirs (find-collection-dir collection-path)])
     (cond [(and (pair? dirs) (not (interactive-mode)))
            (displayln (path->string (first dirs)))]
           [(and (pair? dirs))
            (select (map path->string dirs))]
           [else
            (raise-user-error 'raco-find-collection
                              "could not find the collection path ~v"
                              collection-path)]))))

