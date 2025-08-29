# Use official Ruby image - works on all platforms
FROM ruby:3.4.4

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y \
      curl \
      build-essential \
      libpq-dev \
      nodejs \
      npm \
      && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy Gemfile first for better caching
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy app files
COPY . .

# Copy and make entrypoint executable
COPY docker/entrypoint.sh /app/docker/entrypoint.sh
RUN chmod +x /app/docker/entrypoint.sh

# Precompile assets (will be overridden in development)
RUN bundle exec rails assets:precompile RAILS_ENV=production || true

# Expose port
EXPOSE 3000

# Start server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
