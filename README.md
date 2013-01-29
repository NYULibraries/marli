# Manhattan Research Library Initiative (MaRLI) registration application

[![Build Status](http://jenkins1.bobst.nyu.edu/job/MaRLI%20Production/badge/icon)](http://jenkins1.bobst.nyu.edu/job/MaRLI%20Production/)

This is a simple Rails3 application to allow MaRLI participants at NYU to send their registration requests to the other participant libraries. See [http://marli.libguides.com/welcome](http://marli.libguides.com/welcome) for more information on the MaRLI project.

## Authentication and authorization

Users login to NYU's SSO through ExLibris's Patron Directory Service (PDS) using the [authpds-nyu](https://github.com/scotdalton/authpds-nyu) gem. Only authorized patron statuses are allowed through to the registration system. This authorization list is managed within the application by admins.

## User information

Once a user is logged into PDS, the application uses the [exlibris-aleph](https://github.com/scotdalton/exlibris-aleph) gem to get additional patron information from [ExLibris's Aleph](http://www.exlibris-usa.com/category/Aleph) ILS. 