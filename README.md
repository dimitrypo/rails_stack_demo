# Rails Stack Demo

Modern Rails 7 starter kit with Docker. Demo project showcasing my skills and providing public code examples on modern Rails stack.

## Stack

- **Rails 7.2.2** with Ruby 3.4.4
- **PostgreSQL 15** database
- **Redis** for caching and jobs
- **Sidekiq** for background processing
- **Elasticsearch** for search
- **TailwindCSS** for styling
- **Turbo/Stimulus** for frontend

## Quick Start

```bash
# Start all services
docker-compose up

# App runs at http://localhost:8000
# Mailcatcher at http://localhost:1080
```

## Development

Various usable commands that you may use:

```bash
# Rails console
docker-compose exec web rails console

# Run migrations
docker-compose exec web rails db:migrate

# Install gems
docker-compose exec web bundle install

# Build TailwindCSS for styling
docker-compose exec web rails tailwindcss:build

# Watch TailwindCSS for development (auto-rebuild on changes)
docker-compose exec web rails tailwindcss:watch

# Check code style with RuboCop
./bin/rubocop-check

# Auto-fix code style issues
./bin/rubocop-check --fix

# Run security scan
./bin/brakeman-check
```

## Testing

This project includes comprehensive testing using RSpec:

### Testing Stack
- **RSpec** - Behavior-driven testing framework
- **Capybara** - Web application testing framework
- **Selenium WebDriver** - Browser automation
- **Firefox + Geckodriver** - Headless browser for actual rendering
- **Docker** - Isolated testing environment


# Run all RSpec tests (inside container)
./bin/run-tests

# Or manually run it inside container
docker-compose run --rm test-runner bundle exec rspec

# Run specific test files
docker-compose run --rm test-runner bundle exec rspec spec/controllers/public_controller_spec.rb
docker-compose run --rm test-runner bundle exec rspec spec/features/home_pages_spec.rb


### Running Tests
```bash
# Run all system tests in dedicated container
./bin/run-tests

# Interactive mode for debugging
docker-compose run --rm test-runner bash
bundle exec rspec --format documentation
```

The `./bin/run-tests` script runs all RSpec tests inside a dedicated Docker container with all necessary dependencies pre-installed.

### Manual Docker Commands examples
```bash
# RuboCop
docker-compose exec web bundle exec rubocop
docker-compose exec web bundle exec rubocop --autocorrect

# Brakeman
docker-compose exec web bundle exec brakeman
docker-compose exec web bundle exec brakeman -o brakeman_report.html
docker-compose exec web bundle exec brakeman --ignore-config .brakeman.ignore
```

### Browser Configuration
Firefox with Geckodriver was chosen for feature testing due to its superior compatibility with Docker environments, particularly when running on Apple Silicone machines. This ensures consistent test execution across development and CI environments.

### Testing Features
- **Containerized Testing**: All tests run in isolated Docker containers
- **Screenshot Capture**: Automatic screenshots on test failures for debugging
- **Responsive Testing**: Validates TailwindCSS responsive design behaviors
- **Content Verification**: Tests all page sections, interactions, and styling
- **Cross-platform**: Consistent testing environment across different systems
- **100% Code Coverage**: Complete test coverage with SimpleCov reporting

## Code Quality

This project enforces code quality and security using RuboCop and Brakeman:

### Tools Setup
- **RuboCop Rails Omakase** - Curated Ruby style guide for Rails applications  
- **Brakeman** - Static security vulnerability scanner for Rails
- **Pre-commit Hook** - Automatically runs both tools on every commit
- **Auto-correction** - Many RuboCop issues can be fixed automatically

### Pre-commit Hook
The project includes an automatic pre-commit hook that:
- Runs RuboCop on every commit attempt
- Runs Brakeman security scan on every commit  
- Prevents commits with style violations or security issues
- Shows helpful commands to fix problems
- Works with Docker environment automatically

If you need to bypass the hook (emergency only):
```bash
git commit --no-verify -m "Emergency commit"
```

## Features

### Current Features
- **User Authentication**: Devise-based login-only system (no registration for safety)
- **Comprehensive Testing**: 100% code coverage with RSpec, Capybara, and Docker
- **Code Quality**: Automated RuboCop and Brakeman checks with pre-commit hooks
- **Modern UI**: TailwindCSS with Turbo/Stimulus for responsive design

### Planned Features (TODO)
- Article CRUD with live updates
- Global search with Elasticsearch
- Background email jobs with Sidekiq
- Admin panel with ActiveAdmin
- 2FA support (TOTP)

### Authentication

Simple login-only authentication with Devise (no registration, password reset, or other features - just as a safety precaution if it'll be deployed somewhere to not invite bots, and also demos my skills to customize Devise):
- Email: `user@example.com`
- Password: `password`

A default user is automatically created on startup in development mode. The login page features a modern TailwindCSS design with the app branding.

## Deployment

Ready for AWS Lightsail Container Service. (TODO)
Terraform scripts included for production setup. (TODO)

## Development Notes

- Use `docker-compose exec` for all Rails tasks inside docker container, you mainly will need "web" one.
- Database auto-creates on first startup
- All services health-checked before Rails starts
