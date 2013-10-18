#lang racket/base

(require "find-collection.rkt"
         racket/cmdline)

(command-line
 #:args (collection-path)
 (let ([dir (find-collection-dir collection-path)])
   (if dir
       (displayln (path->string dir))
       (displayln (path->string (current-directory))))))

