# Manhattan Research Library Initiative (MaRLI) registration application

[![Build Status](http://jenkins1.bobst.nyu.edu/buildStatus/icon?job=MaRLI Production)](http://jenkins1.bobst.nyu.edu/job/MaRLI%20Production/)

[![Build Status](https://travis-ci.org/NYULibraries/marli.png?branch=development-shibboleth)](https://travis-ci.org/NYULibraries/marli)
[![Code Climate](https://codeclimate.com/github/NYULibraries/marli.png)](https://codeclimate.com/github/NYULibraries/marli)
[![Dependency Status](https://gemnasium.com/NYULibraries/marli.png)](https://gemnasium.com/NYULibraries/marli)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/marli/badge.png?branch=development-shibboleth)](https://coveralls.io/r/NYULibraries/marli)

This is a simple Rails3 application to allow MaRLI participants at NYU to send their registration requests to the other participant libraries. See [http://marli.libguides.com/welcome](http://marli.libguides.com/welcome) for more information on the MaRLI project.

## Authentication and authorization

Users login to NYU's SSO through ExLibris's Patron Directory Service (PDS) using the [authpds-nyu](https://github.com/scotdalton/authpds-nyu) gem. Only authorized patron statuses are allowed through to the registration system. This authorization list is managed within the application by admins.

## User information

Once a user is logged into PDS, the application uses the [exlibris-nyu](https://github.com/NYULibraries/exlibris-nyu) gem to get additional patron information from [ExLibris's Aleph](http://www.exlibris-usa.com/category/Aleph) ILS. 