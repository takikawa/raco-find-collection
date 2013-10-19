#lang racket/kernel

(#%require "find-collection.rkt")

(let*-values ([(collection-path) (vector-ref (current-command-line-arguments) 0)]
              [(dir) (find-collection-dir collection-path)])
  (if dir
      (begin (write-string (path->string dir)) (newline))
      (begin (write-string (path->string (current-directory)))
             (newline)
             (error 'raco-find-collection
                    "could not find the collection path ~v"
                    collection-path))))
