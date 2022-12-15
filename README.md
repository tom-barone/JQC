# JQC

[![License](https://img.shields.io/github/license/tom-barone/JQC?color=silver)](https://github.com/tom-barone/JQC/blob/master/LICENSE.txt)
[![Continuous Integration](https://img.shields.io/github/actions/workflow/status/tom-barone/JQC/continuous-integration.yml?branch=develop&label=CI)](https://github.com/tom-barone/JQC/actions?query=branch:develop)
[![Continuous Deployment](https://img.shields.io/github/actions/workflow/status/tom-barone/JQC/continuous-deployment.yml?branch=master&label=CD)](https://github.com/tom-barone/JQC/actions?query=branch:master)

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

1. Create a pull request to merge `develop` -> `master`.
1. All checks must pass, and it is a good idea to manually look over the staging site as well.
1. Merge the pull request.
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
