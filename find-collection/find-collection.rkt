#lang racket/base

(provide find-collection-dir)

(define (find-collection-dir collection)
  (collection-path
   collection
   #:fail (λ (_0)
            (define-values (base name _1)
              (split-path collection))
            (define file-path
              (collection-file-path name base #:fail (λ (_) #f)))
            (and file-path
                 (file-exists? file-path)
                 (let-values ([(collection-base _2 _3)
                               (split-path (collection-file-path name base))])
                   collection-base)))))

