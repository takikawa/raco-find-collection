raco-find-collection : a script for finding collections
-------------------------------------------------------

This script helps you find where a given collection is
installed in Racket packages or core collections.

Installation
------------

  * `raco pkg install git://github.com/takikawa/raco-find-collection`
  * `raco pkg install github://github.com/takikawa/raco-find-collection` (on Racket 5.3.6)

Usage
-----

Quick usage: `` cd `raco fc <collection-name>` ``

The `<collection-name>` argument is the same as paths used
for `require` for the most part. For example, `typed/racket`
or `racket/dict`. If a module is just a file and not a
directory, you may have to add `.rkt` at the end (like
for `typed-racket/core.rkt`).

If a collection can't be found, the command returns the
current directory (for convenience in scripts that use `cd`).

You can also add something like the following to your `.bashrc`:

````
function rfc() {
  cd `raco fc $1`
}
````

License
-------

Released under the GPLv3 license. See COPYING.
