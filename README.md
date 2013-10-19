raco-find-collection : a script for finding collections
-------------------------------------------------------

This script helps you find where a given collection is
installed in Racket packages or core collections.

Installation
------------

Use one of:

  * `raco pkg install raco-find-collection`
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
  cd `racket -l find-collection/run $1`
}
````

Note: using `racket -l` in the shell function is faster than calling
the `raco` version of the script, but the latter is easier to
remember when using it manually.

---

Copyright (c) Asumu Takikawa 2013.

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
