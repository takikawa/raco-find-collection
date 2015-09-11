#lang racket/base

(require racket/path pkg/path
         (submod compiler/commands/test paths))

(provide find-collection-dir)

;; Path-String -> (Listof Path)
;; Return list of possible paths for collection
(define (find-collection-dir collection)
  (if (relative-path? collection)
      (append (find/file-path collection)
              (let ([v (collection-paths collection)])
                (sort v < #:key score #:cache-keys? #t)))
      null))

;; Path-String -> (Listof Path)
;; Given a collection path, return a file path to the
;; containing directory (.rkt ending is optional) or null if
;; none found
(define (find/file-path collection)
  (define-values (base name _1)
    (split-path collection))
  (define file-path
    (and (path-string? base)
         (path-string? name)
         (if (racket-extension? name)
             (collection-file-path name base #:fail (λ (_) #f))
             (collection-file-path (path-add-suffix name ".rkt")
                                   base #:fail (λ (_) #f)))))
  (or (and file-path
           (file-exists? file-path)
           (let-values ([(collection-base _2 _3)
                         (split-path file-path)])
             (list collection-base)))
      null))

(define cache (make-hash))

(define (score p)
  (define pkg (path->pkg p #:cache cache))
  (cond ;; prefer `collects` paths
        [(not pkg) -1]
        ;; prefer `-lib` packages otherwise
        [(regexp-match? #rx".*-lib$" pkg)    0]
        [else                 1]))

;; check if the path has a Racket module extension
(define (racket-extension? path)
  (define ext (filename-extension path))
  (and ext (bytes=? ext #"rkt")))

(module+ test
  (require rackunit)
  (check-not-exn (λ () (find-collection-dir "/bin/bash")))
  (check-not-exn (λ () (find-collection-dir "raco-find-collection"))))

