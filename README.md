# Manhattan Research Library Initiative (MaRLI) registration application

[![CircleCI](https://circleci.com/gh/NYULibraries/marli.svg?style=svg)](https://circleci.com/gh/NYULibraries/marli)
[![Dependency Status](https://gemnasium.com/NYULibraries/marli.png)](https://gemnasium.com/NYULibraries/marli)
[![Code Climate](https://codeclimate.com/github/NYULibraries/marli.png)](https://codeclimate.com/github/NYULibraries/marli)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/marli/badge.png)](https://coveralls.io/r/NYULibraries/marli)

This is a simple Rails application to allow MaRLI participants at NYU to send their registration requests to the other participant libraries. See [http://marli.libguides.com/welcome](http://marli.libguides.com/welcome) for more information on the MaRLI project.

## Authentication and authorization

Users login to NYU's SSO using [NYU's Login application](https://github.com/NYULibraries/login). Only authorized patron statuses are allowed through to the registration system. This authorization list is managed within the application by admins.

## User information

Once a user is logged into through NYU's Login, the application uses the [exlibris-nyu](https://github.com/NYULibraries/exlibris-nyu) gem to get additional patron information from [ExLibris's Aleph](http://www.exlibris-usa.com/category/Aleph) ILS.

## Dev environment

Assuming docker is setup and running in your development environment:

```bash
~$ docker-compose build
~$ docker-compose run --service-ports --rm web bash
# Now entering the container shell
web_1$ rake db:create
web_1$ rake db:schema:load
web_1$ rake db:seed
# Run tests
web_1$ rake
```

After that is setup then you can either run the dev server directly from the container or exit out and run `up`:

```bash
web_1$ rails s -b 0.0.0.0
# OR
~$ docker-compose up
```
