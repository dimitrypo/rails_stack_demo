require 'rails_helper'

RSpec.describe "Articles", type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }
  let(:other_user) { User.create!(email: 'other@example.com', password: 'password123') }
  let(:article) { Article.create!(title: 'Test Article', content: 'This is test content for the article.', author: user) }

  describe "GET /articles" do
    context "when not signed in" do
      it "shows only published articles" do
        published = Article.create!(title: 'Published', content: 'Published content here.', author: user, published: true)
        draft = Article.create!(title: 'Draft', content: 'Draft content here.', author: user, published: false)

        get articles_path
        expect(response).to be_successful
        expect(response.body).to include(published.title)
        expect(response.body).not_to include(draft.title)
      end
    end

    context "when signed in" do
      before { sign_in user }

      it "shows all articles including drafts" do
        published = Article.create!(title: 'Published', content: 'Published content here.', author: user, published: true)
        draft = Article.create!(title: 'Draft', content: 'Draft content here.', author: user, published: false)

        get articles_path
        expect(response).to be_successful
        expect(response.body).to include(published.title)
        expect(response.body).to include(draft.title)
      end
    end
  end

  describe "GET /articles/:id" do
    context "when article is published" do
      let(:article) { Article.create!(title: 'Published', content: 'Published content here.', author: user, published: true) }

      it "shows the article to everyone" do
        get article_path(article)
        expect(response).to be_successful
        expect(response.body).to include(article.title)
        expect(response.body).to include(article.content)
      end
    end

    context "when article is draft" do
      let(:article) { Article.create!(title: 'Draft', content: 'Draft content here.', author: user, published: false) }

      it "redirects non-authors" do
        get article_path(article)
        expect(response).to redirect_to(articles_path)
      end

      it "shows to the author" do
        sign_in user
        get article_path(article)
        expect(response).to be_successful
        expect(response.body).to include(article.title)
      end
    end
  end

  describe "GET /articles/new" do
    context "when not signed in" do
      it "redirects to login" do
        get new_article_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      before { sign_in user }

      it "shows the new article form" do
        get new_article_path
        expect(response).to be_successful
        expect(response.body).to include('New Article')
      end
    end
  end

  describe "POST /articles" do
    let(:valid_params) { { article: { title: 'New Article', content: 'This is new article content.', published: false } } }
    let(:invalid_params) { { article: { title: '', content: 'short' } } }

    context "when not signed in" do
      it "redirects to login" do
        post articles_path, params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in" do
      before { sign_in user }

      context "with valid parameters" do
        it "creates a new article" do
          expect {
            post articles_path, params: valid_params
          }.to change(Article, :count).by(1)

          expect(response).to redirect_to(Article.last)
          expect(Article.last.author).to eq(user)
        end

        it "responds to turbo_stream format" do
          post articles_path, params: valid_params, headers: { 'Accept' => 'text/vnd.turbo-stream.html' }
          expect(response).to be_successful
          expect(response.content_type).to include('text/vnd.turbo-stream.html')
        end
      end

      context "with invalid parameters" do
        it "does not create a new article" do
          expect {
            post articles_path, params: invalid_params
          }.not_to change(Article, :count)

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe "GET /articles/:id/edit" do
    before { article }

    context "when not signed in" do
      it "redirects to login" do
        get edit_article_path(article)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in as author" do
      before { sign_in user }

      it "shows the edit form" do
        get edit_article_path(article)
        expect(response).to be_successful
        expect(response.body).to include('Edit Article')
        expect(response.body).to include(article.title)
      end
    end

    context "when signed in as different user" do
      before { sign_in other_user }

      it "redirects with authorization error" do
        get edit_article_path(article)
        expect(response).to redirect_to(articles_path)
      end
    end
  end

  describe "PATCH /articles/:id" do
    before { article }
    let(:valid_params) { { article: { title: 'Updated Title', content: article.content } } }
    let(:invalid_params) { { article: { title: '', content: 'short' } } }

    context "when not signed in" do
      it "redirects to login" do
        patch article_path(article), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in as author" do
      before { sign_in user }

      context "with valid parameters" do
        it "updates the article" do
          patch article_path(article), params: valid_params
          expect(response).to redirect_to(article)
          expect(article.reload.title).to eq('Updated Title')
        end

        it "responds to turbo_stream format" do
          patch article_path(article), params: valid_params, headers: { 'Accept' => 'text/vnd.turbo-stream.html' }
          expect(response).to be_successful
          expect(response.content_type).to include('text/vnd.turbo-stream.html')
        end
      end

      context "with invalid parameters" do
        it "does not update the article" do
          patch article_path(article), params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
          expect(article.reload.title).to eq('Test Article')
        end
      end
    end

    context "when signed in as different user" do
      before { sign_in other_user }

      it "redirects with authorization error" do
        patch article_path(article), params: valid_params
        expect(response).to redirect_to(articles_path)
        expect(article.reload.title).to eq('Test Article')
      end
    end
  end

  describe "DELETE /articles/:id" do
    before { article }

    context "when not signed in" do
      it "redirects to login" do
        delete article_path(article)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in as author" do
      before { sign_in user }

      it "deletes the article" do
        expect {
          delete article_path(article)
        }.to change(Article, :count).by(-1)

        expect(response).to redirect_to(articles_path)
      end

      it "responds to turbo_stream format" do
        delete article_path(article), headers: { 'Accept' => 'text/vnd.turbo-stream.html' }
        expect(response).to be_successful
        expect(response.content_type).to include('text/vnd.turbo-stream.html')
      end
    end

    context "when signed in as different user" do
      before { sign_in other_user }

      it "redirects with authorization error" do
        expect {
          delete article_path(article)
        }.not_to change(Article, :count)

        expect(response).to redirect_to(articles_path)
      end
    end
  end
end
