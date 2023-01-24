# Check if a .env file exists, and then load it
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Primary targets

clean:
	rm -rf ci .nyc_output public/assets tmp/_javascript

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

build:
	bundle exec bin/rails assets:precompile

dev: install
	RAILS_ENV=development bundle exec bin/rails server

# Secondary targets

run-cloud-sql-proxy: guard-GOOGLE_CLOUD_SQL_INSTANCE
	cloud_sql_proxy -instances=$(GOOGLE_CLOUD_SQL_INSTANCE)=tcp:3306

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

test-report-mailers:
	@echo 'Hitting the last_month_csv_report endpoint'
	curl --header "X-Appengine-Cron: true" http://localhost:3000/crons/last_month_csv_reports

copy-production-database-to-development:
	bundle exec bin/rails db:copy_prod TARGET=DEV

# Safety targets

guard-%:
	@if [ -z '${${*}}' ]; then echo 'ERROR: ENV variable $* is not set' && exit 1; fi
