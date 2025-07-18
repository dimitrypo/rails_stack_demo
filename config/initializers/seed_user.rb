Rails.application.config.after_initialize do
  if Rails.env.development? && defined?(Rails::Server)
    User.find_or_create_by(email: "user@example.com") do |user|
      user.password = "password"
      user.password_confirmation = "password"
    end
  end
end
