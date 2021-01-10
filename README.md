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

## Seeding the db with the existing AppMaker db

in other folder, from JQC_PROD

```
./cloneDatabaseToRails.sh
```

Then migrate and seed the DB
```
rails db:migrate
rails db:seed
```


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

# google cloud proxy

To start:

```
cloud_sql_proxy -instances=***REMOVED***:australia-southeast1:rails-jqc-instance-v8=tcp:3306
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
