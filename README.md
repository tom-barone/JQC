# jqc


## Invoicing

using jinja2 and weasyprint to make invoices

bean-report jqc.beancount holdings --by=currency

bean-query -f csv jqc.beancount 'select Date, description as Description, number as Hours, cost_number as Rate, value(position) as amount from has_account("HoursWorked") open on 2018-05-01 close on 2018-08-03 where not "invoice" in tags and number > 0'

bean-query -f csv jqc.beancount 'select sum(value(position)) as total from has_account("HoursWorked") open on 2018-05-01 close on 2018-08-03 where not "invoice" in tags and number > 0;'
