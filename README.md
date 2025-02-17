# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

# Deployment

## Dokku

```bash
# Create the app
ssh -t <user>@<dokku_server> dokku apps:create <website_domain>
# Add the dokku git remote to the repo
git remote add <remote_name> dokku@<dokku_server>:<website_domain>
# Set the domain for the dokku container
dokku --remote <remote_name> domains:set <website_domain>
# Create & link postgres and redis containers
dokku --remote <remote_name> postgres:create <app_name>-db
dokku --remote <remote_name> postgres:link <app_name>-db <website_domain>
dokku --remote <remote_name> redis:create <app_name>-redis
dokku --remote <remote_name> redis:link <app_name>-redis <website_domain>
# Set important environment variables
dokku --remote <remote_name> config:set RAILS_MASTER_KEY=$(cat config/master.key)
dokku --remote <remote_name> config:set DOMAIN=<website_domain>
# Setup LetsEncrypt certs
# - Make sure to have your domain DNS settings point <website_domain> to the server before running this
dokku --remote <remote_name> letsencrypt:enable
# If using a branch other than main or master to deploy from
dokku --remote <remote_name> git:set deploy-branch <branch_name>
# Push the code to the server and deploy
git push <remote_name> <branch>
# Scale up the web and worker processes
dokku --remote <remote_name> ps:scale web=1 worker=1

# Anytime you need to deploy a new release
git push <remote_name> <branch>
```

I like to use `pgAdmin` to interface with the postgres database, which can be done with SSH tunneling.
First you'll need to expose the database port from the docker container to the host machine:

```bash
# Expose the database internally from dokku to 0.0.0.0 on the host
dokku --remote <remote_name> postgres:expose <app_name>-db 5432
# Undo the port expose with
dokku --remote <remote_name> postgres:unexpose <app_name>-db 5432
# View the connection string (password etc.) and use it in pgAdmin, along with relevant SSH tunnel settings
dokku --remote <remote_name> postgres:info <app_name>-db
```
