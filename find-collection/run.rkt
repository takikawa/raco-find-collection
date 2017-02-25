#lang racket/base

(require "find-collection.rkt"
         racket/lazy-require
         racket/cmdline
         racket/list)
(lazy-require [pkg/lib (pkg-directory)])

;; a parameter that controls whether the user is asked
;; when the collection path needs disambiguation
(define interactive-mode (make-parameter #f))

;; sets whether to search for a raco command
(define raco-mode (make-parameter #f))

;; sets whether to search for a package source
(define source-mode (make-parameter #f))

;; print current directory (for use in scripts) and
;; re-raise the exception to print it to stderr
(define (fail e)
  (unless (source-mode)
    (displayln (path->string (current-directory))))
  (raise e))

;; allow user to select the path option
(define (select choices)
  (define stderr (current-error-port))
  (define choices-string
    (apply string-append
           (for/list ([(choice idx) (in-indexed (in-list choices))])
             (format "(~a) ~a~n" idx choice))))
  ;; these prompts ask the user via stderr, which is hacky
  (displayln "Ambiguous collection or pkg, please select one:" stderr)
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
   #:once-any
   [("-r" "--raco") "Find a raco command implementation"
                    (raco-mode #t)]
   [("-s" "--source") "Find the source URL of a package"
                      (source-mode #t)]
   #:args (collection-path)
   (if (source-mode)
     (displayln (find-source collection-path))
     (let* ([collection-path*
             (if (raco-mode)
                 (raco-name->collection-path collection-path)
                 collection-path)]
            [dirs (find-collection-dir collection-path*)])
       (cond [(and (pair? dirs) (not (interactive-mode)))
              (displayln (path->string (first dirs)))]
             [else
              (define pkg-path (pkg-directory collection-path))
              (define pkg (and pkg-path (path->string pkg-path)))
              (cond [(and pkg (not (interactive-mode)))
                     (displayln pkg)]
                    [(or pkg (pair? dirs))
                     (define choices
                       (remove-duplicates
                        (append (map path->string dirs)
                                (or (and pkg (list pkg)) null))))
                     (if (= (length choices) 1)
                         (displayln (car choices))
                         (select choices))]
                    [else
                     (raise-user-error 'raco-find-collection
                                       "could not find the collection path ~v"
                                       collection-path)])])))))

