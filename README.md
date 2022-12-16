# JQC

[![License](https://img.shields.io/github/license/tom-barone/JQC?color=silver)](https://github.com/tom-barone/JQC/blob/master/LICENSE.txt)
[![Continuous Integration](https://github.com/tom-barone/JQC/actions/workflows/continuous-integration.yml/badge.svg?branch=develop)](https://github.com/tom-barone/JQC/actions/workflows/continuous-integration.yml)
[![Continuous Deployment](https://github.com/tom-barone/JQC/actions/workflows/continuous-deployment.yml/badge.svg?branch=master)](https://github.com/tom-barone/JQC/actions/workflows/continuous-deployment.yml)

Real world Rails 7 app deployed on Google App Engine.

Currently used as an in-house record keeping system for a company of ~30 users.

## Contributing and CI/CD process

All work is done on the `develop` branch. Create feature branches off `develop` as necessary.

After committing and pushing to `develop`, the [CI Github Action](https://github.com/tom-barone/JQC/actions/workflows/continuous-integration.yml) will:

1. Run the unit, integration and end to end tests.
1. Create a copy of the production database and deploy a staging site using that copy.
1. Run a set of smaller, production safe tests against the staging site.

See the [/production](https://github.com/tom-barone/JQC/tree/master/production) folder for the production safe tests.

To deploy a new production version:

1. It is a good idea to do a quick manual check of the most recent staging site
1. Create a pull request to merge `develop` -> `master`.
1. Once all the checks have passed, the pull request will automatically merge.
1. The [CD Github Action](https://github.com/tom-barone/JQC/actions/workflows/continuous-deployment.yml) will deploy a new production version to Google App Engine and migrate traffic to that version.
1. The action will then run the production safe tests against the new production site.

## Testing

```bash
npm test
rails test:all
```

See the [CI Github Action](https://github.com/tom-barone/JQC/actions/workflows/continuous-integration.yml) for more details.

## Security

The rails credential keys are stored seperately and provided to the test & deploy actions as environment secrets.
