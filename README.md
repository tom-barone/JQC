# JQC

[![License](https://img.shields.io/github/license/AccessToTheCloud/JQC?color=969696)](https://github.com/AccessToTheCloud/JQC/blob/master/LICENSE.txt)
[![Lines of Code](https://sonarcloud.io/api/project_badges/measure?project=AccessToTheCloud_JQC&metric=ncloc)](https://sonarcloud.io/summary/overall?id=AccessToTheCloud_JQC)

[![Continuous Integration](https://github.com/AccessToTheCloud/JQC/actions/workflows/continuous-integration.yml/badge.svg?branch=develop)](https://github.com/AccessToTheCloud/JQC/actions/workflows/continuous-integration.yml)
[![Continuous Deployment](https://github.com/AccessToTheCloud/JQC/actions/workflows/continuous-deployment.yml/badge.svg?branch=master)](https://github.com/AccessToTheCloud/JQC/actions/workflows/continuous-deployment.yml)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=AccessToTheCloud_JQC&metric=alert_status)](https://sonarcloud.io/summary/overall?id=AccessToTheCloud_JQC)

[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=AccessToTheCloud_JQC&metric=security_rating)](https://sonarcloud.io/summary/overall?id=AccessToTheCloud_JQC)
[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=AccessToTheCloud_JQC&metric=reliability_rating)](https://sonarcloud.io/summary/overall?id=AccessToTheCloud_JQC)
[![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=AccessToTheCloud_JQC&metric=sqale_rating)](https://sonarcloud.io/summary/overall?id=AccessToTheCloud_JQC)
[![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=AccessToTheCloud_JQC&metric=vulnerabilities)](https://sonarcloud.io/summary/overall?id=AccessToTheCloud_JQC)

[![Sonar Coverage](https://img.shields.io/sonar/coverage/AccessToTheCloud_JQC?label=test%20coverage&server=https%3A%2F%2Fsonarcloud.io)](https://sonarcloud.io/component_measures?metric=coverage&view=list&id=AccessToTheCloud_JQC)

Real world Rails 7 app deployed on Google App Engine, backed by MySQL and
designed with Bootstrap 5.

Currently used as an in-house record keeping system for a company of ~30 users.

## Contributing and CI/CD process

All work is done on the `develop` branch. Create feature branches off `develop`
as necessary.

After committing and pushing to `develop`, the
[CI Github Action](https://github.com/AccessToTheCloud/JQC/actions/workflows/continuous-integration.yml)
will:

1. Run the unit, integration and end to end tests.
1. Create a copy of the production database and deploy a staging site using that
   copy.
1. Run a set of smaller, production safe tests against the staging site.

See the
[/production](https://github.com/AccessToTheCloud/JQC/tree/master/production)
folder for the production safe tests.

To deploy a new production version:

1. It is a good idea to do a quick manual check of the most recent staging site
1. Create a pull request to merge `develop` -> `master`.
1. Once all the checks have passed, the pull request will automatically merge.
1. The
   [CD Github Action](https://github.com/AccessToTheCloud/JQC/actions/workflows/continuous-deployment.yml)
   will deploy a new production version to Google App Engine and migrate traffic
   to that version.
1. The action will then run the production safe tests against the new production
   site.

## Installing on M1 Mac

There's some issues with the mysql2 gem on M1 Macs, you can get around them by
installing the mysql2 gem with:

```bash
gem install mysql2 -v '0.5.4' -- --with-mysql-lib=$(brew --prefix mysql)/lib --with-mysql-dir=$(brew --prefix mysql) --with-mysql-config=$(brew --prefix mysql)/bin/mysql_config --with-mysql-include=$(brew --prefix mysql)/include --with-ldflags="-L$(brew --prefix zstd)/lib -L$(brew --prefix openssl)/lib -L$(brew --prefix zlib)/lib" --with-cppflags="-I$(brew --prefix openssl)/include -I$(brew --prefix zlib)/include"
```

After running this command, `bundle install` should now work. Thanks goes to
[this thread](https://gist.github.com/fernandoaleman/385aad12a18fe50cf5fd1e988e76fd63).

## Testing

Simple as running:

```bash
make test
```

Test and coverage results will be saved to the `ci` folder. Screenshots of
failed tests will be in `tmp/screenshots`.

## Security

The rails credential keys are stored seperately and provided to the test &
deploy actions as environment secrets.
