#lang racket/kernel

(#%require '#%utils)
(#%provide find-collection-dir)

(define-values (find-collection-dir)
  (lambda (collection)
    (collection-path
     (λ (_0)
        (define-values (base name _1)
          (split-path collection))
        (define-values (file-path)
          (collection-file-path (λ (_) #f) name base))
        (if file-path
            (if (file-exists? file-path)
                (let-values ([(collection-base _2 _3)
                              (split-path (collection-file-path name base))])
                  collection-base)
                #f)
            #f))
     collection)))


