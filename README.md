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

# Run tests
docker-compose run --rm test
```

## Features

- User authentication with Devise (TODO)
- Article CRUD with live updates (TODO)
- Global search with Elasticsearch (TODO)
- Background email jobs (TODO)
- Admin panel with ActiveAdmin (TODO)
- 2FA support (TOTP) (TODO)

## Deployment

Ready for AWS Lightsail Container Service. (TODO)
Terraform scripts included for production setup. (TODO)

## Development Notes

- Use `docker-compose exec` for all Rails tasks inside docker container, you mainly will need "web" one.
- Database auto-creates on first startup
- All services health-checked before Rails starts
