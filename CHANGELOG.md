# Change Log

## 2014-12-11
- Rails 4, Ruby 2.1.x

## 2013-10-25

### Functional Changes
- __Shibboleth Integration__  
  We've integrated the [PDS Shibboleth integration](https://github.com/NYULibraries/pds-custom/wiki/NYU-Shibboleth-Integration)
  into this release.

### Technical Changes
- :gem: __Updates__: Most gems are up to date. We're not on Rails 4, so that's the exception.

- __Update authpds-nyu__: Use the Shibboleth version of the
  [NYU PDS authentication gem](https://github.com/NYULibraries/authpds-nyu/tree/v1.1.2).

- __Update exlibris-nyu__ Use the newly refactored version of the [Exlibris NYU gem](https://github.com/NYULibraries/exlibris-nyu).

- __Use nyulibraries_deploy__ Refactored to use the [NYU Libraries Deploy gem](https://github.com/NYULibraries/nyulibraries_deploy) for capistrano recipe simplification and the ability to send diff emails.

- __Refactor__
  A bit of a code refactor to clean up and optimize in a Rails fashion, e.g. use of respond_with, more RESTful actions, upped code coverage significantly, etc.
