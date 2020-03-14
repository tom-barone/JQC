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

* ...


## Invoicing

using jinja2 and weasyprint to make invoices

bean-report jqc.beancount holdings --by=currency

bean-query -f csv jqc.beancount 'select Date, description as Description, number as Hours, cost_number as Rate, value(position) as amount from has_account("HoursWorked") open on 2018-05-01 close on 2018-08-03 where not "invoice" in tags and number > 0'

bean-query -f csv jqc.beancount 'select sum(value(position)) as total from has_account("HoursWorked") open on 2018-05-01 close on 2018-08-03 where not "invoice" in tags and number > 0;'
