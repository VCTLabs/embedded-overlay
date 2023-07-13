==================
 embedded-overlay
==================

|ci| |repoman|

|pre|

Portage overlay for embedded tools and (extra) Python packages.

Interesting/useful items:

* app-forensics/openscap - NIST Certified SCAP 1.2 toolkit
* dev-embedded/abc - A system for sequential logic synthesis and formal verification
* dev-embedded/chiptools - A utility to automate FPGA build and verification
* dev-embedded/yosys - A framework for Verilog RTL synthesis
* dev-embedded/redis-ipc - system message bus using redis and json
* dev-libs/spdlog - Fast C++ logging library
* dev-libs/libdatrie - An implementation for a double-array Trie library in C
* dev-libs/ztcli-async - Thin async Python binding around Zerotier cli
* net-dns/mini-dot - Lightweight TCP-only DNS forwarder with DoT support
* net-misc/fpnd - FreePN P2P vpn network stack
* net-proxy/pyforwarder - Python raw socket proxy with optional SSL/TLS termination
* sci-electronics/pyVHDLModel - An abstract VHDL language model written in Python
* sci-electronics/ghdl - The GHDL VHDL simulator

plus lots of other python and networking goodies (see below for full listing).

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

.. |repoman| image:: https://github.com/VCTLabs/embedded-overlay/actions/workflows/repoman.yml/badge.svg
    :target: https://github.com/VCTLabs/embedded-overlay/actions/workflows/repoman.yml
    :alt: RepoMan CI status

.. |pre| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :target: https://github.com/pre-commit/pre-commit
   :alt: pre-commit enabled


ebuild listing::

  .
  ├── acct-group
  │   └── fpnd
  │       └── fpnd-0.ebuild
  ├── acct-user
  │   └── fpnd
  │       └── fpnd-0.ebuild
  ├── app-admin
  │   └── freepn-gtk3-tray
  │       ├── freepn-gtk3-tray-0.0.8.ebuild
  │       └── freepn-gtk3-tray-9999.ebuild
  ├── app-misc
  │   └── timew-report
  │       ├── files
  │       └── timew-report-1.4.0.ebuild
  ├── dev-cpp
  │   └── cpplint
  │       ├── cpplint-1.5.5.ebuild
  │       ├── cpplint-9999.ebuild
  │       └── files
  ├── dev-embedded
  │   ├── abc
  │   │   ├── abc-20211027.ebuild
  │   │   ├── abc-20221029.ebuild
  │   │   ├── abc-9999.ebuild
  │   │   └── files
  │   ├── chiptools
  │   │   └── chiptools-9999.ebuild
  │   ├── libmraa
  │   │   ├── files
  │   │   │   └── 2.2.0
  │   │   └── libmraa-2.2.0.ebuild
  │   ├── mavlink_c
  │   │   └── mavlink_c-20220518.ebuild
  │   ├── redis-ipc
  │   │   ├── redis-ipc-0.1.0.ebuild
  │   │   └── redis-ipc-9999.ebuild
  │   └── yosys
  │       ├── files
  │       └── yosys-0.10.ebuild
  ├── dev-go
  │   └── round
  │       └── round-0.0.2.ebuild
  ├── dev-libs
  │   ├── libdatrie
  │   │   ├── files
  │   │   ├── libdatrie-0.2.12.ebuild
  │   │   └── libdatrie-0.2.13.ebuild
  │   ├── libuio
  │   │   └── libuio-9999.ebuild
  │   ├── nanomsg-python
  │   │   ├── files
  │   │   ├── nanomsg-python-1.0.2_p4.ebuild
  │   │   └── nanomsg-python-9999.ebuild
  │   ├── nanoservice
  │   │   ├── files
  │   │   ├── nanoservice-0.7.2_p3.ebuild
  │   │   └── nanoservice-9999.ebuild
  │   ├── re2
  │   │   ├── files
  │   │   ├── re2-0.2020.10.01.ebuild
  │   │   └── re2-0.2020.11.01.ebuild
  │   ├── socketplusplus
  │   │   ├── files
  │   │   └── socketplusplus-1.12.13.ebuild
  │   ├── spdlog
  │   │   └── spdlog-1.9.2.ebuild
  │   └── ztcli-async
  │       ├── files
  │       ├── ztcli-async-0.0.8.ebuild
  │       └── ztcli-async-9999.ebuild
  ├── dev-python
  │   ├── adblockparser
  │   │   └── adblockparser-0.7.ebuild
  │   ├── ansible-assertive
  │   │   └── ansible-assertive-0.0.2.ebuild
  │   ├── daemonizer
  │   │   ├── daemonizer-0.3.5.ebuild
  │   │   └── daemonizer-9999.ebuild
  │   ├── datrie
  │   │   ├── datrie-0.8.2_p1.ebuild
  │   │   ├── datrie-9999.ebuild
  │   │   └── files
  │   ├── decor
  │   │   └── decor-2.0.1.ebuild
  │   ├── docstring-to-markdown
  │   │   └── docstring-to-markdown-0.9.ebuild
  │   ├── esptool
  │   │   └── esptool-2.0.1.ebuild
  │   ├── google-re2
  │   │   ├── files
  │   │   └── google-re2-0.0.7_p2.ebuild
  │   ├── gpio
  │   │   └── gpio-0.0.1_pre20181020.ebuild
  │   ├── gpiozero
  │   │   └── gpiozero-1.4.1.ebuild
  │   ├── hexdump
  │   │   ├── hexdump-3.3_p1.ebuild
  │   │   └── hexdump-9999.ebuild
  │   ├── honcho
  │   │   ├── honcho-1.0.1.ebuild
  │   │   └── honcho-9999.ebuild
  │   ├── minimock
  │   │   └── minimock-1.3.0.ebuild
  │   ├── msgpack
  │   │   └── msgpack-0.6.2.ebuild
  │   ├── pdfrw
  │   │   ├── files
  │   │   └── pdfrw-0.4_p2.ebuild
  │   ├── picotui
  │   │   ├── files
  │   │   ├── picotui-0.9.4-r1.ebuild
  │   │   ├── picotui-0.9.4.ebuild
  │   │   ├── picotui-1.0.0_rc3.ebuild
  │   │   └── picotui-9999.ebuild
  │   ├── py-re2
  │   │   ├── py-re2-0.3.3.ebuild
  │   │   └── py-re2-9999.ebuild
  │   ├── pymavlink
  │   │   └── pymavlink-2.4.29.ebuild
  │   ├── pystache
  │   │   ├── files
  │   │   ├── pystache-0.6.2.ebuild
  │   │   └── pystache-9999.ebuild
  │   ├── python-uinput
  │   │   └── python-uinput-0.11.2.ebuild
  │   ├── rst2pdf
  │   │   ├── files
  │   │   └── rst2pdf-0.98.ebuild
  │   ├── schedule
  │   │   ├── schedule-0.6.0_p3.ebuild
  │   │   └── schedule-9999.ebuild
  │   ├── semver
  │   │   └── semver-2.13.0.ebuild
  │   ├── smartypants
  │   │   ├── smartypants-2.0.1.ebuild
  │   │   └── smartypants-9999.ebuild
  │   ├── sphinxcontrib-apidoc
  │   │   └── sphinxcontrib-apidoc-0.3.0-r1.ebuild
  │   ├── srp
  │   │   └── srp-1.0.14.ebuild
  │   ├── svglib
  │   │   ├── svglib-1.0.1.ebuild
  │   │   └── svglib-9999.ebuild
  │   ├── unittest2pytest
  │   │   └── unittest2pytest-0.4.ebuild
  │   └── viivakoodi
  │       └── viivakoodi-0.8.0.ebuild
  ├── dev-util
  │   ├── allwinner-tvout
  │   │   ├── allwinner-tvout-1.1.ebuild
  │   │   └── files
  │   ├── devmem2
  │   │   ├── devmem2-0.1-r1.ebuild
  │   │   └── files
  │   ├── gitchangelog
  │   │   ├── gitchangelog-3.1.2.ebuild
  │   │   └── gitchangelog-9999.ebuild
  │   ├── repolite
  │   │   ├── repolite-0.3.3.ebuild
  │   │   └── repolite-9999.ebuild
  │   └── ymltoxml
  │       ├── ymltoxml-0.1.0.ebuild
  │       └── ymltoxml-9999.ebuild
  ├── media-gfx
  │   ├── diagrams
  │   │   ├── diagrams-0.21.1.ebuild
  │   │   └── files
  │   └── svg2rlg
  │       ├── svg2rlg-0.3.ebuild
  │       └── svg2rlg-0.4.0.ebuild
  ├── media-video
  │   └── mjpg-streamer
  │       ├── files
  │       └── mjpg-streamer-1.0.0.ebuild
  ├── net-dns
  │   ├── getdns
  │   │   ├── files
  │   │   └── getdns-1.6.0_beta1-r2.ebuild
  │   └── mini-dot
  │       ├── files
  │       └── mini-dot-9999.ebuild
  ├── net-libs
  │   └── libtins
  │       ├── files
  │       ├── libtins-3.4.ebuild
  │       ├── libtins-3.5.ebuild
  │       └── libtins-4.2.ebuild
  ├── net-misc
  │   ├── fpnd
  │   │   ├── files
  │   │   └── fpnd-0.9.10-r1.ebuild
  │   ├── stunnel
  │   │   ├── files
  │   │   ├── stunnel-5.56-r2.ebuild
  │   │   └── stunnel-5.58.ebuild
  │   └── zerotier
  │       ├── files
  │       ├── zerotier-1.4.6-r3.ebuild
  │       └── zerotier-1.6.4.ebuild
  ├── net-proxy
  │   └── pyforwarder
  │       ├── pyforwarder-0.12.35.ebuild
  │       └── pyforwarder-9999.ebuild
  ├── sci-electronics
  │   ├── ghdl
  │   │   ├── files
  │   │   ├── ghdl-1.0.0.ebuild
  │   │   └── ghdl-2.0.0.ebuild
  │   └── pyVHDLModel
  │       ├── pyVHDLModel-0.10.5.ebuild
  │       └── pyVHDLModel-0.13.2.ebuild
  ├── sys-apps
  │   └── fstrimDaemon
  │       ├── fstrimDaemon-1.1.1.ebuild
  │       └── fstrimDaemon-9999.ebuild
  ├── sys-block
  │   └── bmap-tools
  │       ├── bmap-tools-3.6.ebuild
  │       └── files
  └── sys-libs
      └── newlib
          ├── files
          └── newlib-3.3.0-r1.ebuild
