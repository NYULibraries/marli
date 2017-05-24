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

## Environments

### Test

Assuming docker is setup and running in your development environment:

```bash
~$ docker-compose up -d
# Run tests
~$ docker-compose run web rake
```

### Development

```bash
~$ docker-compose up -d
~$ docker-compose exec web rake db:setup
# Visit http://{DOCKER_MACHINE_IP}:3000
```
