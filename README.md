# JQC

[![License](https://img.shields.io/github/license/tom-barone/JQC?color=969696)](https://github.com/tom-barone/JQC/blob/master/LICENSE)

[![CICD](https://github.com/tom-barone/JQC/actions/workflows/cicd.yml/badge.svg?branch=master)](https://github.com/tom-barone/JQC/actions/workflows/cicd.yml) [![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=tom-barone_JQC&metric=alert_status)](https://sonarcloud.io/summary/overall?id=tom-barone_JQC)

[![Security Rating](https://sonarcloud.io/api/project_badges/measure?project=tom-barone_JQC&metric=security_rating)](https://sonarcloud.io/summary/overall?id=tom-barone_JQC) [![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=tom-barone_JQC&metric=reliability_rating)](https://sonarcloud.io/summary/overall?id=tom-barone_JQC) [![Maintainability Rating](https://sonarcloud.io/api/project_badges/measure?project=tom-barone_JQC&metric=sqale_rating)](https://sonarcloud.io/summary/overall?id=tom-barone_JQC) [![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=tom-barone_JQC&metric=vulnerabilities)](https://sonarcloud.io/summary/overall?id=tom-barone_JQC)

Rails/PostgreSQL app deployed with Kamal, styled with Bootstrap.

## Monitoring

A [Grafana](https://grafana.com) instance is provisioned by the Ansible `monitoring_stack_install` role and reachable at `http://monitoring.<website_domain>`.

## Deployment

Production runs on a Linode host provisioned by [OpenTofu](https://opentofu.org) and configured by [Ansible](https://docs.ansible.com), then deployed via [Kamal](https://kamal-deploy.org). CI/CD is wired up in `.github/workflows/cicd.yml` and runs on every push to `master`.

- Kamal service config: `config/deploy.yml`
- Ansible playbook + roles: `infrastructure/ansible/`
- OpenTofu (Linode + AWS): `infrastructure/tofu/`

To deploy manually from a local checkout:

```bash
bin/kamal deploy
```

Useful aliases (defined in `config/deploy.yml`):

```bash
bin/kamal console   # Rails console
bin/kamal shell     # Bash inside the app container
bin/kamal logs      # Tail app logs
bin/kamal dbc       # Rails dbconsole
```

## Development

There are a few issues with `solid_queue` causing trouble when resetting the database. To reset everything from scratch so we can load in backed up data in development

```bash
rails db:migrate:reset
rails db:drop:queue
# Reset the db/queue_schema.rb file
rails db:prepare
rake restore_development_db_from_most_recent_backup
```

## Infrastructure bootstrap

Day-to-day server config is handled by Ansible (`infrastructure/ansible/deploy.yml`); `tofu apply` only needs to run when the underlying cloud resources change.

If starting from scratch, you need to:

1. Create a new AWS account.
2. Create an IAM user with `AdministratorAccess` permissions and generate access keys for that user.
   - Setup the access keys in SOPS.
3. Create an S3 bucket to use as the state backend, e.g. `infrastructure-state-backend`.
   - Set `Object Versioning` to enabled.
   - Configure OpenTofu to use the S3 bucket as the state backend, done via SOPS.
4. Configure Route53 to manage the DNS for the app domain.
5. Setup AWS SES for sending emails from the app domain.
   - Verify the domain via route53 and request production access to remove sandbox restrictions.
6. Create a Linode token and configure OpenTofu to use it done via SOPS.
