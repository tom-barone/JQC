# Pre requisites

```bash
brew install git-crypt
```

## Encryption

Rails keys are stored in the *.key files.

Unlock/lock them with git-crypt:

```bash
git-crypt unlock
git-crypt lock
```

RAILS_MASTER_KEY and SECRET_KEY_BASE are stored in the gitlab project settings so the runners have access to them: 
https://gitlab.com/tombarone/jqc/-/settings/ci_cd

RAILS_MASTER_KEY is config/credentials/production.key and not config/master.key


# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...


Dump the existing database (from cloned) into seed file

```
#rails db:seed:dump
#rails db:data:dump
```

## Invoicing

using jinja2 and weasyprint to make invoices

bean-report jqc.beancount holdings --by=currency

bean-query -f csv jqc.beancount 'select Date, description as Description, number as Hours, cost_number as Rate, value(position) as amount from has_account("HoursWorked") open on 2018-05-01 close on 2018-08-03 where not "invoice" in tags and number > 0'

bean-query -f csv jqc.beancount 'select sum(value(position)) as total from has_account("HoursWorked") open on 2018-05-01 close on 2018-08-03 where not "invoice" in tags and number > 0;'

## Rails Generators from database

Generate

```
scaffold -c -p ./db/schema.rb
```

## Rails Generators from database
Scheduled cron jobs are stored in cron.yaml.
https://cloud.google.com/appengine/docs/standard/scheduling-jobs-with-cron-yaml
View app engine cron jobs in Cloud Scheduler on the Google cloud console.

To update the cron jobs:

```bash
gcloud app deploy cron.yaml
```

To test and trigger the mail in development:
```bash
curl --header "X-Appengine-Cron: true" http://localhost:3000/crons/last_month_csv_reports
```

## Devise initial install instructions

Depending on your application's configuration some manual setup may be required:

1. Ensure you have defined default url options in your environments files. Here
   is an example of default_url_options appropriate for a development environment
   in config/environments/development.rb:

   ```
   config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
   ```

   In production, :host should be set to the actual host of your application.

   - Required for all applications. \*

2. Ensure you have defined root*url to \_something* in your config/routes.rb.
   For example:

   root to: "home#index"

   - Not required for API-only Applications \*

3. Ensure you have flash messages in app/views/layouts/application.html.erb.
   For example:

   ```
    <p class="notice"><%= notice %></p>
    <p class="alert"><%= alert %></p>
   ```

   - Not required for API-only Applications \*

4. You can copy Devise views (for customization) to your app by running:

   rails g devise:views

   - Not required \*

## Deploying

Compile rails app and deplyo

```
RAILS_ENV=production rails assets:precompile
gcloud app deploy
```

## Todo


- Create migrations for each database table
- link foreign keys and things
- Change Application.Client to Application.Contact
- drop sortprioritygen column
- https://www.driftingruby.com/episodes/nested-forms-from-scratch

- do this https://floatingcube.com/blog/action-cable/
- tests: 
- export works
- export works lots of records
- export works and can load page at the same time
- export works and can load page at the same time
- Delete stages/uploads/invoices/clients with no attached application

- remove cancelled reports from the monthly exports
- rename client to contact

- Remove "Edit" buttons when the applicant/contact/owner changes in application_edit


- Fields no longer used
--  request_for_information_issued
--  job_type
--  consent
--  certifier

