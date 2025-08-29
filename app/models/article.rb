class Article < ApplicationRecord
  belongs_to :author, class_name: "User"

  validates :title, presence: true, length: { minimum: 3, maximum: 255 }
  validates :content, presence: true, length: { minimum: 10 }
  validates :slug, presence: true, uniqueness: true,
                   format: { with: /\A[a-z0-9\-]+\z/, message: "only allows lowercase letters, numbers, and hyphens" }

  before_validation :generate_slug, on: :create
  before_save :set_published_at

  scope :published, -> { where(published: true).where.not(published_at: nil) }
  scope :draft, -> { where(published: false) }
  scope :recent, -> { order(Arel.sql("COALESCE(published_at, created_at) DESC")) }

  def to_param
    slug
  end

  private

  def generate_slug
    return if slug.present?

    base_slug = title.to_s.downcase.strip
                     .gsub(/[^\w\s-]/, "")
                     .gsub(/[\s_-]+/, "-")
                     .gsub(/^-+|-+$/, "")

    counter = 1
    self.slug = base_slug

    while Article.exists?(slug: slug)
      self.slug = "#{base_slug}-#{counter}"
      counter += 1
    end
  end

  def set_published_at
    if published? && published_at.nil?
      self.published_at = Time.current
    elsif !published?
      self.published_at = nil
    end
  end
end
