embedded-overlay
================

|ci|

|pre|

VCTLabs portage overlay for embedded and (extra) Python packages.

Quick and dirty layman install::

  $ layman -f -a embedded-overlay -o https://raw.github.com/VCTLabs/embedded-overlay/master/layman.xml

Install the overlay without layman
----------------------------------

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

This repo is now pre-commit_ enabled for pkgcheck and file-type linting.  The
checks run automatically on commit and will fail the commit (if not clean) and
perform simple file corrections.  If pkgcheck fails on commit, the failure
data is provided in the ``failures.json`` file for inspection. Note you must
fix any fatal errors for the commit to succeed.

.. _pre-commit: https://pre-commit.com/index.html

.. |ci| image:: https://github.com/VCTLabs/embedded-overlay/actions/workflows/main.yml/badge.svg
    :target: https://github.com/VCTLabs/embedded-overlay/actions/workflows/main.yml
    :alt: PkgCheck CI status

.. |pre| image:: https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white
   :target: https://github.com/pre-commit/pre-commit
   :alt: pre-commit enabled
