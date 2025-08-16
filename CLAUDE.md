# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Core Architecture

**Domain Model**: The core entity is `Application` which represents building consent applications. Applications belong to an `ApplicationType` and have relationships with `Client` records (applicant, owner, contact), `Council`, `Suburb`, and various supporting entities like `RequestForInformation`, `Invoice`, `StructuralEngineer`, etc.

**Frontend**: Uses Hotwire (Turbo + Stimulus) for SPA-like interactions, Bootstrap for styling, and Importmap for JavaScript module loading. JavaScript controllers are in `app/javascript/controllers/` and tests in `app/javascript/tests/`.

**Background Jobs**: Uses SolidQueue for background processing with jobs in `app/jobs/`.

**File Storage**: Uses Active Storage with S3 integration for file attachments.

## Key Commands

### Development Setup

```bash
rake install           # Install dependencies (bundle + npm)
rake dev              # Setup and start dev server on port 3008
rake dev_with_test_db # Start dev server with test fixtures loaded
```

### Testing

```bash
rake test_all         # Run all tests (Ruby + JavaScript)
npm run test          # Run JavaScript tests only
bundle exec rails test:all  # Run Ruby tests only
```

### Code Quality

```bash
rake lint             # Run all linters (RuboCop, Brakeman, ERB Lint, ESLint)
rake format           # Auto-format all code (Ruby, ERB, JavaScript)
rake precommit        # Full pipeline: install, format, lint, test
```

### Single Test Execution

```bash
bundle exec rails test test/system/basic_health_test.rb
bundle exec rails test test/models/application_test.rb
npm run test -- --testNamePattern="search controller"
```

## Development Workflow

**Branching**: All development on `develop` branch. PRs merge `develop` → `master` for production.

**CI/CD**: Push to `develop` triggers CI (test + deploy staging). Merge to `master` triggers CD (deploy production + create release).

**Code Style**:

- Uses RuboCop with Rails conventions
- ERB templates formatted with erb-formatter and erb_lint
- JavaScript linted with ESLint
- Auto-formatting via `rake format`

When making changes, ensure your code and tests work by running the test file specifically:

```bash
bundle exec rails test <path_to_test_file>
```

When you believe your changes are complete, run the full linting, formatting, and testing pipeline to ensure everything is in order - and be sure to fix any lingering issues.

```bash
just precommit
```

## Application-Specific Patterns

**Search**: Applications have full-text search via PostgreSQL tsvectors (`searchable_tsvector` column) supporting both phrase and term queries.

**Nested Forms**: Extensive use of Cocoon gem for dynamic nested forms (RFIs, invoices, stages, etc.) on application records.

**Dynamic Reference Numbers**: Application types auto-increment reference numbers on creation via `update_last_used_reference_number`.

**Application Conversion**: When changing application types, creates a duplicate of the old record and links them via `converted_to_from` field.

**CSV Export**: All list views support CSV export via `CsvExportable` concern.

**PDF Generation**: Uses ferrum_pdf for server-side PDF generation of application records.

## Key Configuration

**Credentials**: Building surveyors, certifiers, and backup settings stored in Rails credentials.

**Environment Variables**:

- `STAGING=true` for staging environment
- `SOLID_QUEUE_IN_PUMA=true` for development
- `DOMAIN` for deployment
- `STATSD_ADDR` for StatsD server address (default: localhost:8125)
- `STATSD_PREFIX` for metric prefix (default: jqc)
- `STATSD_DEFAULT_TAGS` for default metric tags
- `STATSD_SAMPLE_RATE` for metric sampling rate

**Database**: PostgreSQL with full-text search, uses SolidQueue for jobs/cache/cable.

**Monitoring**: StatsD integration for web request monitoring including duration and HTTP status codes.

## Testing Approach

**System Tests**: Capybara + Selenium for end-to-end testing **JavaScript Tests**: Jest for frontend component testing  
**Coverage**: SimpleCov for Ruby, coverage reports in `ci/` directory **Fixtures**: Heavy use of YAML fixtures for consistent test data

## Deployment

**Platform**: Dokku with PostgreSQL and Redis containers

**Monitoring**:

- Grafana dashboards and alerts (definitions in `/monitoring`)
- StatsD integration for real-time web request metrics (duration, status codes)
- Metrics tagged with controller, action, method, and status information

**Backups**: Automated PostgreSQL backups to S3 with encryption

**Health Checks**: `/up` for Rails health, `/check_recent_backup` for backup verification

## Important Files

**Models**: `app/models/application.rb` (core domain model)

**Controllers**: `app/controllers/applications_controller.rb` (main CRUD)

**Search**: `app/controllers/search_controller.rb` for building surveyor search

**Monitoring**:

- `lib/statsd_monitoring_middleware.rb` (request monitoring middleware)
- `config/initializers/statsd.rb` (StatsD client configuration)
- `test/integration/statsd_monitoring_test.rb` (monitoring integration tests)

**Tasks**: `Rakefile` contains all custom rake tasks

**Routes**: Authentication required for all routes except sign-in

**DB Schema**: `db/structure.sql` for database structure
