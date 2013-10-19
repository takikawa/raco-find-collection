#lang racket/base

(require "find-collection.rkt"
         racket/cmdline)

(command-line
 #:args (collection-path)
 (let ([dir (find-collection-dir collection-path)])
   (cond [dir (displayln (path->string dir))]
         [else
          (displayln (path->string (current-directory)))
          (error 'raco-find-collection
                 "could not find the collection path ~v"
                 collection-path)])))

