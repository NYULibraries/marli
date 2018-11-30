# Manhattan Research Library Initiative (MaRLI) registration application

[![CircleCI](https://circleci.com/gh/NYULibraries/marli.svg?style=svg)](https://circleci.com/gh/NYULibraries/marli)
[![Maintainability](https://api.codeclimate.com/v1/badges/c7d81d4f398cb27cac82/maintainability)](https://codeclimate.com/github/NYULibraries/marli/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/NYULibraries/marli/badge.svg?branch=master)](https://coveralls.io/github/NYULibraries/marli?branch=master)

This is a simple Rails application to allow MaRLI participants at NYU to send their registration requests to the other participant libraries. See [http://marli.libguides.com/welcome](http://marli.libguides.com/welcome) for more information on the MaRLI project.

## Authentication and authorization

Users login to NYU's SSO using [NYU's Login application](https://github.com/NYULibraries/login). Only authorized patron statuses are allowed through to the registration system. This authorization list is managed within the application by admins.

## User information

Once a user is logged into through NYU's Login, the application uses the [exlibris-nyu](https://github.com/NYULibraries/exlibris-nyu) gem to get additional patron information from [ExLibris's Aleph](http://www.exlibris-usa.com/category/Aleph) ILS.

## Environments

### Test

Assuming docker:

```bash
# Run tests
~$ docker-compose run test
```

### Development

```bash
~$ docker-compose up dev
# Visit http://{DOCKER_MACHINE_IP}:3000
```
