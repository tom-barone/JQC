# JQC

[![License](https://img.shields.io/github/license/tom-barone/JQC?color=969696)](https://github.com/tom-barone/JQC/blob/master/LICENSE)

[![CICD](https://github.com/tom-barone/JQC/actions/workflows/cicd.yml/badge.svg?branch=master)](https://github.com/tom-barone/JQC/actions/workflows/cicd.yml) [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=tom-barone_JQC&metric=alert_status)](https://sonarcloud.io/summary/overall?id=tom-barone_JQC)

[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=tom-barone_JQC&metric=security_rating)](https://sonarcloud.io/summary/overall?id=tom-barone_JQC) [![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=tom-barone_JQC&metric=reliability_rating)](https://sonarcloud.io/summary/overall?id=tom-barone_JQC) [![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=tom-barone_JQC&metric=sqale_rating)](https://sonarcloud.io/summary/overall?id=tom-barone_JQC) [![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=tom-barone_JQC&metric=vulnerabilities)](https://sonarcloud.io/summary/overall?id=tom-barone_JQC)

Rails/PostgreSQL app deployed with Kamal, styled with Bootstrap.

## Deployment

Runs on a Linode host provisioned by [OpenTofu](https://opentofu.org) and configured by [Ansible](https://docs.ansible.com), then deployed via [Kamal](https://kamal-deploy.org).

Currently setup to use AWS for:

- S3
  - OpenTofu state backend.
  - [Restic](https://restic.net/) backups for the Postgres database and ActiveStorage files.
- Route53 for DNS management.
- SES for sending emails.

CI/CD is wired up in `.github/workflows/cicd.yml` and runs on every push to `master`.

### Bootstrapping

To bootstrap the infrastructure to a point where OpenTofu / Ansible can take over:

1. Create an AWS account.
2. Create an IAM user with appropriate permissions and generate access keys.
3. Create an S3 bucket to use as the state backend, e.g. `infrastructure-state.<website_domain>`.
   - Set `Object Versioning` to enabled.
4. Configure Route53 to manage the DNS for the app domain.
5. Configure SES for sending emails from the app domain.
   - Verify the domain via Route53 and request production access to remove sandbox restrictions.
6. Create a Linode account and access token.
7. Configure all the above credentials and config values in SOPS `secrets.sops.env`.

## Monitoring

A [Grafana](https://grafana.com) instance is provisioned by the Ansible `monitoring_stack_install` role and reachable at `http://monitoring.<website_domain>`.

## Development

There are a few issues with `solid_queue` causing trouble when resetting the database. To reset everything from scratch so we can load in backed up data in development

```bash
rails db:migrate:reset
rails db:drop:queue
# Reset the db/queue_schema.rb file
rails db:prepare
```
