#lang racket/base

(require "find-collection.rkt"
         racket/cmdline)

;; print current directory (for use in scripts) and
;; re-raise the exception to print it to stderr
(define (fail e)
  (displayln (path->string (current-directory)))
  (raise e))

(with-handlers ([exn:fail? fail])
  (command-line
   #:args (collection-path)
   (let ([dir (find-collection-dir collection-path)])
     (cond [dir (displayln (path->string dir))]
           [else
            (raise-user-error 'raco-find-collection
                              "could not find the collection path ~v"
                              collection-path)]))))

