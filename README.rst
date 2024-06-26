==================
 embedded-overlay
==================

|ci| |repoman|

|pre|

Portage overlay for embedded tools and (extra) Python packages.

Interesting/useful items:

* app-forensics/openscap - NIST Certified SCAP 1.2 toolkit
* app-forensics/scap-security-guide - Baseline compliance content in SCAP formats
* app-forensics/scap-workbendh - SCAP Scanner And Tailoring Graphical User Interface
* app-portage/ltobase - cheap and simplified copy of lto-overlay in a single package
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
* sys-kernel/cross-kernel-bin - simple (cross)hand-built kernel installer (wip)

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

Updating md5-cache
------------------

The directory metadata/md5-cache can contain cache files to speed up portage
when working with ebuilds from the overlay. This overlay does not include
these files, so it is recommended to generate these yourself. To do that,
simply run the following as root::

  egencache --update --repo=embedded-overlay


WIP embedded kernel-bin ebuild
==============================

This is currently a WIP convenience ebuild for installing a generic kernel
binary on something small/embedded that can't run the full distro-kernel bin
package. There are also some experimental github CI kernel builds here:

https://github.com/sarnold/arm64-mainline-linux/releases

Feel free to request a tagged build for something specific.

In this context, "generic kernel" is built using something like the RCN
`build scripts`_ (forked) or one of the many upstream `kernel builders`_.


.. _build scripts: https://github.com/sarnold/arm64-mainline-linux
.. _kernel builders: https://github.com/RobertCNelson/

To use the cross-kernel-bin ebuild still involves manual work, but at least
the install/removal is managed. Using the above method produces a set of build
artifacts in a deploy directory named by KVER. For an arm64 target, the result
should look something like this::

  $ ls -1 deploy/*6.5.8-arm64-r1*
  deploy/6.5.8-arm64-r1-dtbs.tar.gz
  deploy/6.5.8-arm64-r1-modules.tar.gz
  deploy/6.5.8-arm64-r1.Image
  deploy/config-6.5.8-arm64-r1

To use these ebuilds on an arm64 host with your own build output, the steps
are essentially:

* drop the artifacts in your local distfiles
* bump the version as needed and (re)generate the ``cross-kernel-bin`` Manifest file
* emerge ``cross-kernel-bin`` as you normally would
* if needed, generate your initramfs (eg, dracut)
* run ``grub-mkconfig`` --or-- update extlinux.conf

.. note:: The grub ebuild in this overlay has the required devicetree patches
          until they make it into the portage tree.  Otherwise edit the resulting
          grub.cfg file and manually add a ``devicetree`` entry for each kernel
          with the full path to the ``.dtb`` file for your device.

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

  $ tox -e ci,replay

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


short ebuild listing::

  .
  ├── acct-group
  │   └── fpnd
  ├── acct-user
  │   └── fpnd
  ├── app-admin
  │   └── freepn-gtk3-tray
  ├── app-forensics
  │   ├── openscap
  │   ├── scap-security-guide
  │   └── scap-workbench
  ├── app-misc
  │   └── timew-report
  ├── dev-cpp
  │   ├── cpplint
  │   └── gtest
  ├── dev-db
  │   └── opendbx
  ├── dev-embedded
  │   ├── abc
  │   ├── chiptools
  │   ├── libmraa
  │   ├── mavlink_c
  │   └── yosys
  ├── dev-go
  │   └── round
  ├── dev-libs
  │   ├── libdatrie
  │   ├── libuio
  │   ├── nanomsg-python
  │   ├── nanoservice
  │   ├── qtzeroconf
  │   ├── re2
  │   ├── redis-ipc
  │   ├── socketplusplus
  │   ├── spdlog
  │   └── ztcli-async
  ├── dev-python
  │   ├── adblockparser
  │   ├── ansible-assertive
  │   ├── daemonizer
  │   ├── datrie
  │   ├── decor
  │   ├── docstring-to-markdown
  │   ├── esptool
  │   ├── google-re2
  │   ├── gpio
  │   ├── gpiozero
  │   ├── hexdump
  │   ├── honcho
  │   ├── minimock
  │   ├── msgpack
  │   ├── pdfrw
  │   ├── picotui
  │   ├── pyre2
  │   ├── pymavlink
  │   ├── pystache
  │   ├── python-uinput
  │   ├── rst2pdf
  │   ├── schedule
  │   ├── semver
  │   ├── smartypants
  │   ├── sphinxcontrib-apidoc
  │   ├── srp
  │   ├── svglib
  │   ├── unittest2pytest
  │   └── viivakoodi
  ├── dev-util
  │   ├── allwinner-tvout
  │   ├── cccc
  │   ├── devmem2
  │   ├── gitchangelog
  │   ├── repolite
  │   ├── tox-ignore-env-name-mismatch
  │   └── ymltoxml
  ├── licenses
  ├── media-gfx
  │   ├── diagrams
  │   ├── drawing
  │   └── svg2rlg
  ├── media-libs
  │   └── alsa-ucm-conf
  ├── media-video
  │   └── mjpg-streamer
  ├── net-dns
  │   ├── getdns
  │   └── mini-dot
  ├── net-ftp
  │   └── gftp
  ├── net-libs
  │   └── libtins
  ├── net-misc
  │   ├── fpnd
  │   ├── ipcalc
  │   ├── stunnel
  │   └── zerotier
  ├── net-proxy
  │   └── pyforwarder
  ├── profiles
  ├── sci-electronics
  │   ├── ghdl
  │   └── pyVHDLModel
  ├── sys-apps
  │   └── fstrimDaemon
  ├── sys-block
  │   └── bmap-tools
  ├── sys-boot
  │   └── grub
  ├── sys-firmware
  │   └── x13s-firmware
  ├── sys-libs
  │   └── newlib
  └── sys-power
      ├── pd-mapper
      ├── qmic
      ├── qrtr
      └── rmtfs
