#lang racket/base

(require racket/path pkg/path pkg/lib
         setup/getinfo
         (submod compiler/commands/test paths))

(provide find-collection-dir
         find-source
         raco-name->collection-path)

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

;; String -> String
(define (find-source pkg-name)
  (define (pkg-not-found e)
    (raise-user-error 'raco-find-collection
                      "could not find the package ~v"
                      pkg-name))
  (define (source-not-found)
    (raise-user-error 'raco-find-collection
                      "could not find source for package ~v"
                      pkg-name))
  (define details
    (with-handlers ([exn:fail? pkg-not-found])
      (get-pkg-details-from-catalogs pkg-name)))
  (hash-ref details 'source source-not-found))

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

;; output the collection path for a given raco command name
(define (raco-name->collection-path name)
  (define commands
    (for/fold ([commands null])
              ([p (in-list (find-relevant-directories '(raco-commands)))])
      (append commands
              ((get-info/full p) 'raco-commands))))
  (define maybe-entry (assoc name commands))
  (cond [(and maybe-entry
              (not (null? maybe-entry))
              (not (null? (cdr maybe-entry))))
         (define collection (symbol->string (cadr maybe-entry)))
         (fprintf (current-error-port)
                  "collection name for `raco ~a`: ~a~n"
                  name collection)
         collection]
        [else (raise-user-error
               'raco-find-collection
               "raco command ~v not found"
               name)]))
