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

All commands run inside Docker containers:

```bash
# Rails console
docker-compose exec web rails console

# Run migrations
docker-compose exec web rails db:migrate

# Install gems
docker-compose exec web bundle install

# Run tests
docker-compose run --rm test
```

## Features

- User authentication with Devise
- Article CRUD with live updates
- Global search with Elasticsearch
- Background email jobs
- Admin panel with ActiveAdmin
- 2FA support (TOTP)

## Deployment

Ready for AWS Lightsail Container Service (~$7/month).
Terraform scripts included for production setup.

## Development Notes

- Never run Ruby commands outside Docker
- Use `docker-compose exec` for all Rails tasks
- Database auto-creates on first startup
- All services health-checked before Rails starts
