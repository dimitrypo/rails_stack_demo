require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  let(:article) { Article.new(title: 'Test Article', content: 'This is test content for the article.', author: user) }

  describe 'associations' do
    it { should belong_to(:author).class_name('User') }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(3).is_at_most(255) }
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_least(10) }

    it 'validates slug format' do
      article.slug = 'valid-slug-123'
      expect(article).to be_valid

      article.slug = 'Invalid Slug!'
      expect(article).not_to be_valid
      expect(article.errors[:slug]).to include('only allows lowercase letters, numbers, and hyphens')
    end

    it 'validates slug uniqueness' do
      article.save!
      duplicate = Article.new(title: 'Another Article', content: 'Different content here', author: user, slug: article.slug)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:slug]).to include('has already been taken')
    end
  end

  describe 'callbacks' do
    describe '#generate_slug' do
      it 'generates slug from title on create' do
        article = Article.create!(title: 'Test Article Title!', content: 'This is test content.', author: user)
        expect(article.slug).to eq('test-article-title')
      end

      it 'does not override existing slug' do
        article = Article.create!(title: 'Test Article', content: 'Test content here.', author: user, slug: 'custom-slug')
        expect(article.slug).to eq('custom-slug')
      end

      it 'handles duplicate slugs by adding counter' do
        Article.create!(title: 'Duplicate Title', content: 'First article content.', author: user)
        second = Article.create!(title: 'Duplicate Title', content: 'Second article content.', author: user)
        expect(second.slug).to eq('duplicate-title-1')
      end
    end

    describe '#set_published_at' do
      it 'sets published_at when publishing' do
        article.published = true
        article.save!
        expect(article.published_at).not_to be_nil
      end

      it 'clears published_at when unpublishing' do
        article.published = true
        article.save!
        article.published = false
        article.save!
        expect(article.published_at).to be_nil
      end

      it 'keeps existing published_at when already published' do
        time = 1.day.ago
        article.published = true
        article.published_at = time
        article.save!
        expect(article.published_at.to_i).to eq(time.to_i)
      end
    end
  end

  describe 'scopes' do
    let!(:published_article) { Article.create!(title: 'Published', content: 'Published content here.', author: user, published: true) }
    let!(:draft_article) { Article.create!(title: 'Draft', content: 'Draft content here.', author: user, published: false) }

    describe '.published' do
      it 'returns only published articles' do
        expect(Article.published).to include(published_article)
        expect(Article.published).not_to include(draft_article)
      end
    end

    describe '.draft' do
      it 'returns only draft articles' do
        expect(Article.draft).to include(draft_article)
        expect(Article.draft).not_to include(published_article)
      end
    end

    describe '.recent' do
      it 'orders by published_at and created_at' do
        # Update the existing published_article to have an older published_at
        published_article.update!(published_at: 3.days.ago)

        older = Article.create!(title: 'Older', content: 'Older content here.', author: user, published: true)
        older.update!(published_at: 2.days.ago)

        newer = Article.create!(title: 'Newer', content: 'Newer content here.', author: user, published: true)
        newer.update!(published_at: 1.day.ago)

        recent_published = Article.published.recent
        expect(recent_published.first).to eq(newer)
        expect(recent_published.second).to eq(older)
        expect(recent_published.third).to eq(published_article)
      end
    end
  end

  describe '#to_param' do
    it 'returns the slug' do
      article.save!
      expect(article.to_param).to eq(article.slug)
    end
  end
end
