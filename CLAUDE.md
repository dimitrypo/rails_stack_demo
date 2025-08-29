# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Modern Rails 7.2.2 application with Docker-based development environment. The stack includes:
- Rails 7.2.2 with Ruby 3.4.4
- PostgreSQL 15, Redis, Elasticsearch, Sidekiq
- TailwindCSS with Turbo/Stimulus
- RSpec with Capybara for testing
- RuboCop and Brakeman for code quality

## Essential Commands

**IMPORTANT**: Run ALL Rails, Ruby, and bundle commands ONLY inside Docker containers. Never run them directly on the host machine.

### Docker Setup
```bash
# If Docker is not running, start it first
docker-compose up -d

# Wait for all services to be healthy before running commands

# If you encounter Docker errors (won't start, can't connect, etc.):
docker-compose down && docker-compose up

# If problems persist, STOP and ask the user to check before digging further
```

### Development Server
```bash
# Start all services (app runs at http://localhost:8000)
docker-compose up

# Rails console
docker-compose exec web rails console

# Run migrations
docker-compose exec web rails db:migrate

# Install gems
docker-compose exec web bundle install

# Build/watch TailwindCSS
docker-compose exec web rails tailwindcss:build
docker-compose exec web rails tailwindcss:watch
```

### Testing
```bash
# Run all RSpec tests
./bin/run-tests

# Run specific test files
docker-compose run --rm test-runner bundle exec rspec spec/controllers/public_controller_spec.rb
docker-compose run --rm test-runner bundle exec rspec spec/features/home_pages_spec.rb

# Interactive test debugging
docker-compose run --rm test-runner bash
bundle exec rspec --format documentation
```

### Code Quality
```bash
# RuboCop style check
docker-compose exec web bundle exec rubocop

# Auto-fix RuboCop issues
docker-compose exec web bundle exec rubocop --autocorrect
docker-compose exec web bundle exec rubocop --autocorrect-all

# Brakeman security scan
docker-compose exec web bundle exec brakeman
docker-compose exec web bundle exec brakeman -o brakeman_report.html
```

## Architecture

### MVC Structure
- Controllers: `app/controllers/` - Currently has `public_controller.rb` for home page
- Models: `app/models/` - Base ApplicationRecord configured
- Views: `app/views/` - ERB templates with TailwindCSS styling
- Routes: `config/routes.rb` - Root route set to `public#home`

### Frontend
- ImportMaps for JavaScript management (`config/importmap.rb`)
- Stimulus controllers in `app/javascript/controllers/`
- TailwindCSS configured with custom styles in `app/assets/tailwind/application.css`

### Services Architecture
- **Web**: Main Rails app on port 8000 (internal 3000)
- **Database**: PostgreSQL with health checks
- **Cache/Jobs**: Redis for caching and Sidekiq background jobs
- **Search**: Elasticsearch for future search functionality
- **Email**: Mailcatcher for development email testing (port 1080)
- **Test Runner**: Dedicated container with Firefox/Geckodriver for system tests

### Testing Strategy
- RSpec for all tests with separate test database
- Capybara with Selenium WebDriver for system tests
- Firefox with Geckodriver chosen for Docker compatibility
- Screenshots on test failures for debugging
- Test container isolated from development environment

### Code Quality Enforcement
- Pre-commit hook runs RuboCop and Brakeman automatically
- RuboCop Rails Omakase for consistent Ruby style
- Brakeman configured with exit on warnings (config/brakeman.yml)
- Brakeman ignore file for managing false positives (.brakeman.ignore)

### Pre-commit Hook Details
The project has a Git pre-commit hook (.git/hooks/pre-commit) that automatically:
1. Runs RuboCop style checks before each commit
2. Runs Brakeman security scan after RuboCop passes
3. Prevents commits if either check fails
4. Provides helpful error messages and fix commands
5. Works with both Docker and direct Ruby environments
The hook ensures all committed code meets style and security standards.

## Docker Considerations
All Rails commands must be run inside the web container using `docker-compose exec web`. The project uses separate Dockerfiles for development (docker/Dockerfile) and testing (docker/Dockerfile.test).

## Development Workflow
After implementing features or changes, update README.md to reflect new functionality. Keep it brief - just the essentials.

## Git Operations
NEVER run `git add` automatically. Always ask the user to review changes and add files themselves. The user prefers to maintain control over what gets staged for commits.

**NEVER EVER put Claude signature in commit messages!** Just write clean, simple commit messages without any AI attribution or signature.

### Checking for AI-Generated Code Patterns
ALWAYS review commits by actually reading the code (not just grepping) to check for AI-generated patterns:

1. **Instructional comments that make no sense in code context**:
   - `# Insert actual data here`
   - `# If you prefer to do it differently you can do another way`
   - `# Now div centered as requested` (sounds like AI responding to user)

2. **Excessive or weird comments**:
   - `a == b # Checking that a == b` (stating the obvious)
   - `a = b.to_s # Streamline variable a assignment` (weird phrasing)

3. **Complex code WITHOUT comments**:
   - `result.grep('(?.,:<=s).{1,100}(?>=r)[a-z]+')`
   - `page.find('div.a-c').findAll('span')[0].find('a[href^=https]')`
   
   Normal humans would add explanatory comments for complex regex or queries like these.

When reviewing code, read it carefully to ensure it looks like natural human-written code for a personal project.

## Code Style Guidelines
Write code like a busy dev working on a pet project. Natural language, minimal comments (only where truly needed). Match the existing style - no over-explaining, no weird formatting. This is supposed to look like my personal project done in spare time.

## Design and Verification Workflow
- When working with the design or I'm asking to see something, always use MCP server playwright to open page and take a screenshot to verify positioning of elements.