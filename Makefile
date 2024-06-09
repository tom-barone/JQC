# Check if a .env file exists, and then load it
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Primary targets

clean:
	rm -rf ci .nyc_output public/assets tmp/_javascript tmp/downloads tmp/screenshots

install:
	npm install
	bundle install

test: clean install
	@echo 'Running javascript unit tests'
	npm test
	RAILS_ENV=test bundle exec bin/rails db:test:prepare
	$(MAKE) instrument-javascript-code
	@echo 'Running all rails tests'
	RAILS_ENV=test COVERAGE=true bundle exec bin/rails test:all
	$(MAKE) collect-javascript-coverage

test-live-site: guard-TEST_HOST install
	ruby production/sign_in_and_check_table_test.rb

dev: install
	RAILS_ENV=development bundle exec bin/rails server

test-report-mailers: guard-REPORT_MAILER_ENDPOINT
	@echo 'Hitting the last_month_csv_report endpoint'
	curl --fail --header "X-Appengine-Cron: true" $(REPORT_MAILER_ENDPOINT)

deploy-staging: guard-GOOGLE_APP_ENGINE_PROJECT
	RAILS_ENV=staging TARGET=STAGING $(MAKE) copy-production-database
	RAILS_ENV=staging bundle exec bin/rails db:migrate
	RAILS_ENV=staging bundle exec bin/rails db:add_staging_user
	RAILS_ENV=staging bundle exec bin/rails assets:precompile
	gcloud app deploy GAE_staging.yaml --project=$(GOOGLE_APP_ENGINE_PROJECT) --version=staging --no-promote --no-cache --quiet

run-cloud-sql-proxy: guard-GOOGLE_CLOUD_SQL_INSTANCE
	cloud_sql_proxy $(GOOGLE_CLOUD_SQL_INSTANCE)

backup: guard-BACKUP_LOCATION
	RAILS_ENV=production rails db:download_prod
	mv *.sql $(BACKUP_LOCATION)

# Secondary targets

instrument-javascript-code:
	@echo 'Instrumenting the javascript to allow for coverage reporting'
	mkdir -p .nyc_output/tests
	cp -R -f app/javascript tmp/_javascript
	npx nyc instrument tmp/_javascript app/javascript
	bundle exec bin/rails assets:precompile
	cp -R -f tmp/_javascript/. app/javascript

collect-javascript-coverage:
	@echo 'Collecting javascript coverage from the system tests'
	npx nyc merge .nyc_output/tests .nyc_output/out.json
	npx nyc report --reporter=lcov
	@echo 'Point the coverage results back to the clean app/javascript folder'
	find ci -name '*.info' -o -name '*.json' -o -name '*.xml' | xargs sed -i 's@tmp/_javascript@app/javascript@g'

## Run like this: RAILS_ENV=development TARGET=DEV make copy-production-database
copy-production-database: guard-RAILS_ENV guard-TARGET
	@echo 'Copying the PROD database to $(TARGET)'
	bundle exec bin/rails db:copy_prod

# Safety targets

guard-%:
	@if [ -z '${${*}}' ]; then echo 'ERROR: ENV variable $* is not set' && exit 1; fi
