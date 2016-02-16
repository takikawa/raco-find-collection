raco-find-collection : a script for finding collections
-------------------------------------------------------

[![Scribble](https://img.shields.io/badge/Docs-Scribble-blue.svg)](http://docs.racket-lang.org/raco-fc/index.html)

This script helps you find collections or packages that
you have installed in your copy of Racket.
Requires Racket 6.0 or newer.

Installation
------------

Use one of:

  * `raco pkg install raco-find-collection`
  * `raco pkg install git://github.com/takikawa/raco-find-collection`

Usage
-----

Quick usage: `` cd `raco fc <pkg-or-collection-name>` ``

If you are looking for a collection, just use a collection path like
those you would pass to `require`. For example, `typed/racket`, `racket/dict`, or
`typed-racket/core`.

Collection paths are prioritized over package paths if the name
is ambiguous.

If a collection or package can't be found, the command returns the
current directory (for convenience in scripts that use `cd`).

If the `-i` flag is provided, the script will ask you to disambiguate
if there are multiple paths that match the name that you provide.

You can also add something like the following to your `.bashrc`:

````
function rfc() {
  cd `racket -l find-collection/run $1`
}

# interactive version
function rfci() {
  cd `racket -l find-collection/run -i $1`
}
````

Note: using `racket -l` in the shell function is faster than calling
the `raco` version of the script, but the latter is easier to
remember when using it manually.

---

Copyright © Asumu Takikawa 2013-2016.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
