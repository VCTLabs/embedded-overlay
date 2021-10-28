==================
 embedded-overlay
==================

|ci|

|pre|

VCTLabs portage overlay for embedded and (extra) Python packages.

Quick and dirty layman install::

  $ layman -f -a embedded-overlay -o https://raw.github.com/VCTLabs/embedded-overlay/master/layman.xml

Install the overlay without layman
==================================

Create a repos.conf file for the overlay and place the file in the
``/etc/portage/repos.conf`` directory.  Run::

  # nano -w /etc/portage/repos.conf/embedded-overlay.conf

and add the following content to the new file::

  [embedded-overlay]

  # Various embedded and python ebuilds for project work
  # Maintainer: nerdboy (nerdboy@gentoo.org)

  location = /var/db/repos/embedded-overlay
  sync-type = git
  sync-uri = https://github.com/VCTLabs/embedded-overlay.git
  priority = 50
  auto-sync = yes

Adjust the path in the ``location`` field as needed, then save and exit nano.

Run the following command to sync the repo::

  # emaint sync --repo embedded-overlay

Dev tools
=========

Local tool dependencies to aid in development; install both tools for
maximum enjoyment.

Tox
---

As long as you have git and at least Python 3.6, then you can install
and use `tox`_.  After cloning the repository, you can run the repo
checks with the ``tox`` command.  It will build a virtual python
environment for each installed version of python with all the python
dependencies and run the specified commands, eg:

::

  $ git clone https://github.com/VCTLabs/embedded-overlay
  $ cd embedded-overlay
  $ tox -e ci,replay

The above will run the same checks run by the `pkgcheck-action on github`_.
Alternatively, you can run the following command to replicate the current
pre-commit check::

  tox -e scan

Pre-commit
----------

This repo is now pre-commit_ enabled for pkgcheck_ and file-type linting.
The checks run automatically on commit and will fail the commit (if not
clean) and perform simple file corrections.  If the pkgcheck check fails
on commit, you must first fix any fatal errors for the commit to succeed.
That said, pre-commit does nothing if you don't install it first (both
the program itself and the hooks in the local repository copy).

You will need to install pre-commit before contributing any changes;
installing it using your system's package manager is recommended,
otherwise install with pip into your usual virtual environment using
something like::

  $ sudo emerge pre-commit  --or--
  $ pip install pre-commit

then install it into the repo you just cloned::

  $ git clone https://github.com/VCTLabs/embedded-overlay
  $ cd embedded-overlay/
  $ pre-commit install

It's usually a good idea to update the hooks to the latest version::

    pre-commit autoupdate

Most (but not all) of the pre-commit checks will make corrections for you,
however, some will only report errors, so these you will need to correct
manually.

Automatic-fix checks include Doc8, the json/yaml/xml format checks, and the
miscellaneous file fixers. If any of these fail, you can review the changes
with ``git diff`` and just add them to your commit and continue.

If any of the ``pkgcheck`` or ``rst`` checks fail, you will get a report,
and you must fix any errors before you can continue adding/committing.

To see any fatal ``pkgcheck`` errors, run::

  $ tox -ci,replay

to see a replay of just the errors that need to be fixed.  Then make the
appropriate fixes, add the result, and commit.

To see a "replay" of any ``rst`` check errors, run::

  $ pre-commit run rst-backticks -a
  $ pre-commit run rst-directive-colons -a
  $ pre-commit run rst-inline-touching-normal -a


.. _tox: https://github.com/tox-dev/tox
.. _pkgcheck: https://github.com/pkgcore/pkgcheck
.. _pkgcheck-action on github: https://github.com/pkgcore/pkgcheck-action
.. _pre-commit: https://pre-commit.com/index.html


.. |ci| image:: https://github.com/VCTLabs/embedded-overlay/actions/workflows/main.yml/badge.svg
    :target: https://github.com/VCTLabs/embedded-overlay/actions/workflows/main.yml
    :alt: PkgCheck CI status

.. |pre| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :target: https://github.com/pre-commit/pre-commit
   :alt: pre-commit enabled
