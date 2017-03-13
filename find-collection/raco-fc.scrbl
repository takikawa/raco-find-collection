#lang scribble/manual

@title{@exec{raco fc}: Finding Collections}

The @exec{raco fc} command-line tool allows you to locate where
collections or packages are installed.

@section{Installation}

Run @exec{raco pkg install raco-find-collection} or install it
from the DrRacket package manager.

@section{Usage}

The most convenient way to use this tool is to install shell functions
like the following in your @tt{.bashrc}:

@verbatim|{
  function rfc() {
    cd `racket -l find-collection/run -- $@`
  }

  # interactive version
  function rfci() {
    cd `racket -l find-collection/run -- -i $@`
  }
}|

For example, the invocation @exec{rfc typed-racket} will change
the current directory to the implementation directory for Typed Racket.

More generally, the invocation
@;
@nested[#:style 'inset @exec{raco fc <pkg-or-collection-name>}]
@;
will return a path to the location on the filesystem where the
named package or collection is installed. If there are multiple
matches, an arbitrary one is returned.

Collection paths are prioritized over package paths if the name
could match either.

If a collection or package cannot be found, the command returns the
current directory (for convenience in scripts that use cd).

If you supply the @exec{-i} option, the tool will ask you to
disambiguate when there are multiple matches by printing to
standard error. Enter a numeric response to choose a match.


@subsection{Find a Package's Source}
@(define (pkgtech #:key [key #f] . args)
   @tech[#:doc '(lib "pkg/scribblings/pkg.scrbl") #:key key args])

The invocation
@;
@nested[#:style 'inset @exec{raco fc -s <pkg-name>}]
@;
consults the @pkgtech{package catalogs} for information about the given
@pkgtech{package name} and prints the package's
@pkgtech[#:key "package-source"]{source}.
