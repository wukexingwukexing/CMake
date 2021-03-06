cmake_path
----------

.. versionadded:: 3.19

Filesystem path manipulation command.

This command is dedicated to the manipulation of objects of type path which
represent paths on a filesystem. Only syntactic aspects of paths are handled:
the pathname may represent a non-existing path or even one that is not allowed
to exist on the current file system or OS.

For operations involving the filesystem, have a look at the :command:`file`
command.

The path name has the following syntax:

1. ``root-name`` (optional): identifies the root on a filesystem with multiple
   roots (such as ``"C:"`` or ``"//myserver"``).

2. ``root-directory`` (optional): a directory separator that, if present, marks
   this path as absolute. If it is missing (and the first element other than
   the root name is a file name), then the path is relative.

Zero or more of the following:

3. ``file-name``: sequence of characters that aren't directory separators. This
   name may identify a file, a hard link, a symbolic link, or a directory. Two
   special file-names are recognized:

     * ``dot``: the file name consisting of a single dot character ``.`` is a
       directory name that refers to the current directory.

     * ``dot-dot``: the file name consisting of two dot characters ``..`` is a
       directory name that refers to the parent directory.

4. ``directory-separator``: the forward slash character ``/``. If this
   character is repeated, it is treated as a single directory separator:
   ``/usr///////lib`` is the same as ``/usr/lib``.

.. _EXTENSION_DEF:

A ``file-name`` can have an extension. By default, the extension is defined as
the sub-string beginning at the leftmost period (including the period) and
until the end of the pathname. When the option ``LAST_ONLY`` is specified, the
extension is the sub-string beginning at the rightmost period.

.. note::

  ``cmake_path`` command handles paths in the format of the build system, not
  the target system. So this is not generally applicable to the target system
  in cross-compiling environment.

For all commands, ``<path>`` placeholder expect a variable name. An error will
be raised if the variable does not exist, except for `APPEND`_ and
`CMAKE_PATH`_ sub-commands. ``<input>`` placeholder expect a string literal.
``[<input>...]`` placeholder expect zero or more arguments. ``<output>``
placeholder expect a variable name.

.. note::

  ``cmake_path`` command does not support list of paths. The ``<path>``
  placeholder must store only one path name.

To initialize a path variable, three possibilities can be used:

1. :command:`set` command.
2. :ref:`cmake_path(APPEND) <APPEND>` command. Can be used to build a path from
   already available path fragments.
3. :ref:`cmake_path(CMAKE_PATH) <CMAKE_PATH>` command. Mainly used to build a
   path variable from a native path.

  .. code-block:: cmake

    # To build the path "${CMAKE_CURRENT_SOURCE_DIR}/data"

    set (path1 "${CMAKE_CURRENT_SOURCE_DIR}/data")

    cmake_path(APPEND path2 "${CMAKE_CURRENT_SOURCE_DIR}" "data")

    cmake_path(CMAKE_PATH path3 "${CMAKE_CURRENT_SOURCE_DIR}/data")

`Modification`_ and `Generation`_ sub-commands store the result in-place or in
the variable specified by  ``OUTPUT_VARIABLE`` option. All other sub-commands,
except `CMAKE_PATH`_, store the result in the required ``<output>`` variable.

Sub-commands supporting ``NORMALIZE`` option will :ref:`normalize <NORMAL_PATH>`
the path.

Synopsis
^^^^^^^^

.. parsed-literal::

  `Decomposition`_
    cmake_path(`GET`_ <path> :ref:`ROOT_NAME <GET_ROOT_NAME>` <output>)
    cmake_path(`GET`_ <path> :ref:`ROOT_DIRECTORY <GET_ROOT_DIRECTORY>` <output>)
    cmake_path(`GET`_ <path> :ref:`ROOT_PATH <GET_ROOT_PATH>` <output>)
    cmake_path(`GET`_ <path> :ref:`FILENAME <GET_FILENAME>` <output>)
    cmake_path(`GET`_ <path> :ref:`EXTENSION <GET_EXTENSION>` [LAST_ONLY] <output>)
    cmake_path(`GET`_ <path> :ref:`STEM <GET_STEM>` [LAST_ONLY] <output>)
    cmake_path(`GET`_ <path> :ref:`RELATIVE_PATH <GET_RELATIVE_PATH>` <output>)
    cmake_path(`GET`_ <path> :ref:`PARENT_PATH <GET_PARENT_PATH>` <output>)

  `Modification`_
    cmake_path(`APPEND`_ <path> [<input>...] [OUTPUT_VARIABLE <output>])
    cmake_path(`CONCAT`_ <path> [<input>...] [OUTPUT_VARIABLE <output>])
    cmake_path(`REMOVE_FILENAME`_ <path> [OUTPUT_VARIABLE <output>])
    cmake_path(`REPLACE_FILENAME`_ <path> <input> [OUTPUT_VARIABLE <output>])
    cmake_path(`REMOVE_EXTENSION`_ <path> [LAST_ONLY]
                                       [OUTPUT_VARIABLE <output>])
    cmake_path(`REPLACE_EXTENSION`_ <path> [LAST_ONLY] <input>
                                        [OUTPUT_VARIABLE <output>])

  `Generation`_
    cmake_path(`NORMAL_PATH`_ <path> [OUTPUT_VARIABLE <output>])
    cmake_path(`RELATIVE_PATH`_ <path> [BASE_DIRECTORY <path>]
                                    [OUTPUT_VARIABLE <output>])
    cmake_path(`PROXIMATE_PATH`_ <path> [BASE_DIRECTORY <path>]
                                     [OUTPUT_VARIABLE <output>])
    cmake_path(`ABSOLUTE_PATH`_ <path> [BASE_DIRECTORY <path>] [NORMALIZE]
                                    [OUTPUT_VARIABLE <output>])

  `Conversion`_
    cmake_path(`CMAKE_PATH`_ <path> [NORMALIZE] <input>)
    cmake_path(`NATIVE_PATH`_ <path> [NORMALIZE] <output>)
    cmake_path(`CONVERT`_ <input> `TO_CMAKE_PATH_LIST`_ <output>)
    cmake_path(`CONVERT`_ <input> `TO_NATIVE_PATH_LIST`_ <output>)

  `Comparison`_
    cmake_path(`COMPARE`_ <path> <OP> <input> <output>)

  `Query`_
    cmake_path(`HAS_ROOT_NAME`_ <path> <output>)
    cmake_path(`HAS_ROOT_DIRECTORY`_ <path> <output>)
    cmake_path(`HAS_ROOT_PATH`_ <path> <output>)
    cmake_path(`HAS_FILENAME`_ <path> <output>)
    cmake_path(`HAS_EXTENSION`_ <path> <output>)
    cmake_path(`HAS_STEM`_ <path> <output>)
    cmake_path(`HAS_RELATIVE_PATH`_ <path> <output>)
    cmake_path(`HAS_PARENT_PATH`_ <path> <output>)
    cmake_path(`IS_ABSOLUTE`_ <path> <output>)
    cmake_path(`IS_RELATIVE`_ <path> <output>)
    cmake_path(`IS_PREFIX`_ <path> <input> [NORMALIZE] <output>)

  `Hashing`_
    cmake_path(`HASH`_ <path> [NORMALIZE] <output>)

Decomposition
^^^^^^^^^^^^^

.. _GET:
.. _GET_ROOT_NAME:

.. code-block:: cmake

  cmake_path(GET <path> ROOT_NAME <output>)

Returns the root name of the path. If the path does not include a root name,
returns an empty path.

.. _GET_ROOT_DIRECTORY:

.. code-block:: cmake

  cmake_path(GET <path> ROOT_DIRECTORY <output>)

Returns the root directory of the path. If the path does not include a root
directory, returns an empty path.

.. _GET_ROOT_PATH:

.. code-block:: cmake

  cmake_path(GET <path> ROOT_PATH <output>)

Returns the root path of the path. If the path does not include a root path,
returns an empty path.

Effectively, returns the following: ``root-name / root-directory``.

.. _GET_FILENAME:

.. code-block:: cmake

  cmake_path(GET <path> FILENAME <output>)

Returns the filename component of the path. If the path ends with a
``directory-separator``, there is no filename, so returns an empty path.

.. _GET_EXTENSION:

.. code-block:: cmake

  cmake_path(GET <path> EXTENSION [LAST_ONLY] <output>)

Returns the :ref:`extension <EXTENSION_DEF>` of the filename component.

If the ``FILENAME`` component of the path contains a period (``.``), and is not
one of the special filesystem elements ``dot`` or ``dot-dot``, then the
:ref:`extension <EXTENSION_DEF>` is returned.

  .. code-block:: cmake

    set (path "name.ext1.ext2")
    cmake_path (GET path EXTENSION result)
    cmake_path (GET path EXTENSION LAST_ONLY result)

First extension extraction will return ``.ex1.ext2``, while the second one will
return only ``.ext2``.

The following exceptions apply:

  * If the first character in the filename is a period, that period is ignored
    (a filename like ``".profile"`` is not treated as an extension).

  * If the pathname is either ``.`` or ``..``, or if ``FILENAME`` component
    does not contain the ``.`` character, then an empty path is returned.

.. _GET_STEM:

.. code-block:: cmake

  cmake_path(GET <path> STEM [LAST_ONLY] <output>)

Returns the ``FILENAME`` component of the path stripped of its
:ref:`extension <EXTENSION_DEF>`.

  .. code-block:: cmake

    set (path "name.ext1.ext2")
    cmake_path (GET path STEM result)
    cmake_path (GET path STEM LAST_ONLY result)

First stem extraction will return only ``name``, while the second one will
return ``name.ext1``.

The following exceptions apply:

  * If the first character in the filename is a period, that period is ignored
    (a filename like ``".profile"`` is not treated as an extension).

  * If the filename is one of the special filesystem components ``dot`` or
    ``dot-dot``, or if it has no periods, the function returns the entire
    ``FILENAME`` component.

.. _GET_RELATIVE_PATH:

.. code-block:: cmake

  cmake_path(GET <path> RELATIVE_PATH <output>)

Returns path relative to ``root-path``, that is, a pathname composed of
every component of ``<path>`` after ``root-path``. If ``<path>`` is an empty
path, returns an empty path.

.. _GET_PARENT_PATH:

.. code-block:: cmake

  cmake_path(GET <path> PARENT_PATH <output>)

Returns the path to the parent directory.

If `HAS_RELATIVE_PATH`_ sub-command returns false, the result is a copy of
``<path>``. Otherwise, the result is ``<path>`` with one fewer element.

Modification
^^^^^^^^^^^^

.. _APPEND:

.. code-block:: cmake

    cmake_path(APPEND <path> [<input>...] [OUTPUT_VARIABLE <output>])

Append all the ``<input>`` arguments to the ``<path>`` using ``/`` as
``directory-separator``.

For each ``<input>`` argument, the following algorithm (pseudo-code) applies:

  .. code-block:: cmake

    IF (<input>.is_absolute() OR
         (<input>.has_root_name() AND
          NOT <input>.root_name() STREQUAL <path>.root_name()))
      replaces <path> with <input>
      RETURN()
    ENDIF()

    IF (<input>.has_root_directory())
      remove any root-directory and the entire relative path from <path>
    ELSEIF (<path>.has_filename() OR
             (NOT <path>.has_root_directory() OR <path>.is_absolute()))
      appends directory-separator to <path>
    ENDIF()

    appends <input> omitting any root-name to <path>

.. _CONCAT:

.. code-block:: cmake

    cmake_path(CONCAT <path> [<input>...] [OUTPUT_VARIABLE <output>])

Concatenates all the ``<input>`` arguments to the ``<path>`` without
``directory-separator``.

.. _REMOVE_FILENAME:

.. code-block:: cmake

    cmake_path(REMOVE_FILENAME <path> [OUTPUT_VARIABLE <output>])

Removes a single filename component (as returned by
:ref:`GET ... FILENAME <GET_FILENAME>`) from ``<path>``.

After this function returns, if change is done in-place, `HAS_FILENAME`_
returns false for ``<path>``.

.. _REPLACE_FILENAME:

.. code-block:: cmake

    cmake_path(REPLACE_FILENAME <path> <input> [OUTPUT_VARIABLE <output>])

Replaces a single filename component from ``<path>`` with ``<input>``.

Equivalent to the following:

  .. code-block:: cmake

    cmake_path(REMOVE_FILENAME path)
    cmake_path(APPEND path "replacement");

If ``<path>`` has no filename component (`HAS_FILENAME`_ returns false), the
path is unchanged.

.. _REMOVE_EXTENSION:

.. code-block:: cmake

    cmake_path(REMOVE_EXTENSION <path> [LAST_ONLY] [OUTPUT_VARIABLE <output>])

Removes the :ref:`extension <EXTENSION_DEF>`, if any, from ``<path>``.

.. _REPLACE_EXTENSION:

.. code-block:: cmake

    cmake_path(REPLACE_EXTENSION <path> [LAST_ONLY] <input>
                                 [OUTPUT_VARIABLE <output>])

Replaces the :ref:`extension <EXTENSION_DEF>` with ``<input>``.

First, if ``<path>`` has an :ref:`extension <EXTENSION_DEF>` (`HAS_EXTENSION`_
is true), it is removed. Then, a ``dot`` character is appended to ``<path>``,
if ``<input>`` is not empty or does not begin with a ``dot`` character.

Then ``<input>`` is appended as if `CONCAT`_ was used.

Generation
^^^^^^^^^^

.. _NORMAL_PATH:

.. code-block:: cmake

    cmake_path(NORMAL_PATH <path> [OUTPUT_VARIABLE <output>])

Normalize ``<path>``.

A path can be normalized by following this algorithm:

  1. If the path is empty, stop (normal form of an empty path is an empty
     path).
  2. Replace each ``directory-separator`` (which may consist of multiple
     separators) with a single ``/``.
  3. Replace each ``directory-separator`` character in the ``root-name`` with
     ``/``.
  4. Remove each ``dot`` and any immediately following ``directory-separator``.
  5. Remove each non-dot-dot filename immediately followed by a
     ``directory-separator`` and a ``dot-dot``, along with any immediately
     following ``directory-separator``.
  6. If there is ``root-directory``, remove all ``dot-dots`` and any
     ``directory-separators`` immediately following them.
  7. If the last filename is ``dot-dot``, remove any trailing
     ``directory-separator``.
  8. If the path is empty, add a ``dot`` (normal form of ``./`` is ``.``).

.. _cmake_path-RELATIVE_PATH:
.. _RELATIVE_PATH:

.. code-block:: cmake

    cmake_path(RELATIVE_PATH <path> [BASE_DIRECTORY <path>]
                             [OUTPUT_VARIABLE <output>])

Returns ``<path>`` made relative to ``BASE_DIRECTORY`` argument. If
``BASE_DIRECTORY`` is not specified, the default base directory will be
:variable:`CMAKE_CURRENT_SOURCE_DIR`.

For reference, the algorithm used to compute the relative path is described
`here <https://en.cppreference.com/w/cpp/filesystem/path/lexically_normal>`_.

.. _PROXIMATE_PATH:

.. code-block:: cmake

    cmake_path(PROXIMATE_PATH <path> [BASE_DIRECTORY <path>]
                              [OUTPUT_VARIABLE <output>])

If the value of `RELATIVE_PATH`_ is not an empty path, return
it. Otherwise return ``<path>``.

If ``BASE_DIRECTORY`` is not specified, the default base directory will be
:variable:`CMAKE_CURRENT_SOURCE_DIR`.

.. _ABSOLUTE_PATH:

.. code-block:: cmake

    cmake_path(ABSOLUTE_PATH <path> [BASE_DIRECTORY <path>] [NORMALIZE]
                             [OUTPUT_VARIABLE <output>])

If ``<path>`` is a relative path, it is evaluated relative to the given base
directory specified by ``BASE_DIRECTORY`` option. If no base directory is
provided, the default base directory will be
:variable:`CMAKE_CURRENT_SOURCE_DIR`.

When ``NORMALIZE`` option is specified, the path is :ref:`normalized
<NORMAL_PATH>` after the path computation.

Because ``cmake_path`` does not access to the filesystem, symbolic links are
not resolved. To compute a real path, use :command:`get_filename_component`
command with ``REALPATH`` sub-command.

Conversion
^^^^^^^^^^

.. _cmake_path-CMAKE_PATH:
.. _CMAKE_PATH:

.. code-block:: cmake

    cmake_path(CMAKE_PATH <path> [NORMALIZE] <input>)

Converts a native ``<input>`` path into cmake-style path with forward-slashes
(``/``). On Windows, the long filename marker is taken into account.

When ``NORMALIZE`` option is specified, the path is :ref:`normalized
<NORMAL_PATH>` before the conversion.

.. _cmake_path-NATIVE_PATH:
.. _NATIVE_PATH:

.. code-block:: cmake

    cmake_path(NATIVE_PATH <path> [NORMALIZE] <output>)

Converts a cmake-style ``<path>`` into a native
path with platform-specific slashes (``\`` on Windows and ``/`` elsewhere).

When ``NORMALIZE`` option is specified, the path is :ref:`normalized
<NORMAL_PATH>` before the conversion.

.. _CONVERT:
.. _cmake_path-TO_CMAKE_PATH_LIST:
.. _TO_CMAKE_PATH_LIST:

.. code-block:: cmake

   cmake_path(CONVERT <input> TO_CMAKE_PATH_LIST <output> [NORMALIZE])

Converts a native ``<input>`` path into cmake-style path with forward-slashes
(``/``).  On Windows, the long filename marker is taken into account. The input can
be a single path or a system search path like ``$ENV{PATH}``.  A search path
will be converted to a cmake-style list separated by ``;`` characters. The
result of the conversion is stored in the ``<output>`` variable.

When ``NORMALIZE`` option is specified, the path is :ref:`normalized
<NORMAL_PATH>` before the conversion.

.. _cmake_path-TO_NATIVE_PATH_LIST:
.. _TO_NATIVE_PATH_LIST:

.. code-block:: cmake

  cmake_path(CONVERT <input> TO_NATIVE_PATH_LIST <output> [NORMALIZE])

Converts a cmake-style ``<input>`` path into a native path with
platform-specific slashes (``\`` on Windows and ``/`` elsewhere). The input can
be a single path or a cmake-style list. A list will be converted into a native
search path. The result of the conversion is stored in the ``<output>``
variable.

When ``NORMALIZE`` option is specified, the path is :ref:`normalized
<NORMAL_PATH>` before the conversion.

Comparison
^^^^^^^^^^

.. _COMPARE:

.. code-block:: cmake

    cmake_path(COMPARE <path> EQUAL <input> <output>)
    cmake_path(COMPARE <path> NOT_EQUAL <input> <output>)

Compares the lexical representations of the path and another path.

For testing equality, the following algorithm (pseudo-code) apply:

  .. code-block:: cmake

    IF (NOT <path>.root_name() STREQUAL <input>.root_name())
      returns FALSE
    ELSEIF (<path>.has_root_directory() XOR <input>.has_root_directory())
      returns FALSE
    ENDIF()

    returns TRUE or FALSE if the relative portion of <path> is
      lexicographically equal or not to the relative portion of <input>.
      Comparison is performed path component-wise

Query
^^^^^

.. _HAS_ROOT_NAME:

.. code-block:: cmake

    cmake_path(HAS_ROOT_NAME <path> <output>)

Checks if ``<path>`` has ``root-name``.

.. _HAS_ROOT_DIRECTORY:

.. code-block:: cmake

    cmake_path(HAS_ROOT_DIRECTORY <path> <output>)

Checks if ``<path>`` has ``root-directory``.

.. _HAS_ROOT_PATH:

.. code-block:: cmake

    cmake_path(HAS_ROOT_PATH <path> <output>)

Checks if ``<path>`` has root path.

Effectively, checks the following: ``root-name / root-directory``.

.. _HAS_FILENAME:

.. code-block:: cmake

    cmake_path(HAS_FILENAME <path> <output>)

Checks if ``<path>`` has ``file-name``.

.. _HAS_EXTENSION:

.. code-block:: cmake

    cmake_path(HAS_EXTENSION <path> <output>)

Checks if ``<path>`` has an :ref:`<extension <EXTENSION_DEF>`. If the first
character in the filename is a period, it is not treated as an extension (for
example ".profile").

.. _HAS_STEM:

.. code-block:: cmake

    cmake_path(HAS_STEM <path> <output>)

Checks if ``<path>`` has stem.

.. _HAS_RELATIVE_PATH:

.. code-block:: cmake

    cmake_path(HAS_RELATIVE_PATH <path> <output>)

Checks if ``<path>`` has relative path.

.. _HAS_PARENT_PATH:

.. code-block:: cmake

    cmake_path(HAS_PARENT_PATH <path> <output>)

Checks if ``<path>`` has parent path.

.. _IS_ABSOLUTE:

.. code-block:: cmake

    cmake_path(IS_ABSOLUTE <path> <output>)

Checks if ``<path>`` is absolute.

An absolute path is a path that unambiguously identifies the location of a file
without reference to an additional starting location.

.. _IS_RELATIVE:

.. code-block:: cmake

    cmake_path(IS_RELATIVE <path> <output>)

Checks if path is relative.

.. _IS_PREFIX:

.. code-block:: cmake

    cmake_path(IS_PREFIX <path> <input> [NORMALIZE] <output>)

Checks if ``<path>`` is the prefix of ``<input>``.

When ``NORMALIZE`` option is specified, the paths are :ref:`normalized
<NORMAL_PATH>` before the check.

Hashing
^^^^^^^

.. _HASH:

.. code-block:: cmake

    cmake_path(HASH <path> [NORMALIZE] <output>)

Compute hash value of ``<path>`` such that if for two paths (``p1`` and ``p2``)
are equal (:ref:`COMPARE ... EQUAL <COMPARE>`) then hash value of p1 is equal
to hash value of p2.

When ``NORMALIZE`` option is specified, the paths are :ref:`normalized
<NORMAL_PATH>` before the check.
