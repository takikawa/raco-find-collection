#lang racket/base

(provide find-collection-dir)

;; Path-String -> (Option Path)
(define (find-collection-dir collection)
  (and (relative-path? collection)
       (collection-path
        collection
        #:fail (file-path-case collection))))

;; Path-String -> Any -> (Option Path)
;; Dummy argument to satisfy `collection-path` contract
(define ((file-path-case collection) _0)
  (define-values (base name _1)
    (split-path collection))
  (define file-path
    (and (path-string? base)
         (path-string? name)
         (collection-file-path name base #:fail (λ (_) #f))))
  (and file-path
       (file-exists? file-path)
       (let-values ([(collection-base _2 _3)
                     (split-path (collection-file-path name base))])
         collection-base)))

(module+ test
  (require rackunit)
  (check-not-exn (λ () (find-collection-dir "/bin/bash")))
  (check-not-exn (λ () (find-collection-dir "raco-find-collection"))))

