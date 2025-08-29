require 'rails_helper'

RSpec.describe "Articles", type: :feature do
  let(:user) { User.create!(email: 'test@example.com', password: 'password123') }

  describe "Articles index page" do
    context "when no articles exist and user not signed in" do
      it "shows empty state with login prompt" do
        visit articles_path

        expect(page).to have_content("No articles")
        expect(page).to have_content("Get started by creating a new article")
        expect(page).to have_link("Login to create article")

        # Should not have New Article button when not signed in
        expect(page).not_to have_link("New Article", href: new_article_path)
      end
    end

    context "when user is signed in" do
      before do
        visit new_user_session_path
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it "can edit an article from index without 'Content missing'" do
        # Ensure there's an article owned by the current user so Edit link is visible
        Article.create!(title: 'Sample', content: 'A valid content that is long enough', author: user)

        visit articles_path
        # Scope to the articles list container to avoid ambiguous main/body selection
        within("#articles") do
          click_link "Edit", match: :first
        end

        # We should land on the edit page without Turbo frame mismatch
        expect(page).to have_content("Edit Article").or have_content("Editing Article")
        expect(page).not_to have_content("Content missing")
        expect(page).to have_field("Title")
        expect(page).to have_field("Content")
      end

  it "can delete an article from index without 'Content missing'", js: true do
        article = Article.create!(title: 'Deletable', content: 'Content is long enough to be valid', author: user)

        visit articles_path
        within("#articles") do
          accept_confirm do
            click_link "Delete", match: :first
          end
        end

  # After delete, the article row should be removed without full page reload
  expect(page).not_to have_css("##{ActionView::RecordIdentifier.dom_id(article)}")
  expect(page).not_to have_content("Content missing")
      end

      it "shows only one New Article button when no articles exist" do
        visit articles_path

        # Should have exactly one New Article button at the top
        new_article_links = all(:link, "New Article")
        expect(new_article_links.count).to eq(1)

        # Should show empty state but without duplicate button
        expect(page).to have_content("No articles")
        expect(page).not_to have_link("Login to create article")
      end

      it "can navigate to new article page" do
        visit articles_path

        # Click the New Article button
        click_link "New Article"

        # Should navigate to the new article page without errors
        expect(page).to have_current_path(new_article_path)
        expect(page).to have_content("New Article")
        expect(page).not_to have_content("Content missing")

        # Should have form fields
        expect(page).to have_field("Title")
        expect(page).to have_field("Content")
      end

      it "updates an article and returns to the index via Turbo", js: true do
        article = Article.create!(title: 'Original', content: 'A valid content goes here and is long enough', author: user)

        visit edit_article_path(article)
        expect(page).to have_content("Edit Article")

        fill_in "Title", with: "Updated Title From Spec"
        click_button "Update Article"

        # Should render the index via Turbo Stream replace of page-content
        expect(page).to have_css("#articles")
        expect(page).to have_content("Updated Title From Spec")
        # And we shouldn't be stuck on the edit form anymore
        expect(page).not_to have_button("Update Article")
      end

      it "can create a new article", js: true do
  visit new_article_path
  fill_in "Title", with: "My Test Article"
  fill_in "Content", with: "This is the content of my test article. It needs to be at least 10 characters."
  click_button "Create Article"

        # With Turbo Stream create: the page should update to show the index and include the new article row
        expect(page).to have_css("#articles")
  expect(page).to have_content("My Test Article")
      end
    end

    context "when user is not signed in" do
      it "shows login prompt instead of New Article button" do
        visit articles_path

        # Should not show New Article button when not signed in
        expect(page).not_to have_link("New Article", href: new_article_path)

        # Should show login prompt
        expect(page).to have_link("Login to create article")

        # Clicking login link should redirect to login page
        click_link "Login to create article"
        expect(page).to have_current_path(new_user_session_path)
      end
    end

    context "article show page" do
      it "shows a published article to a visitor" do
        article = Article.create!(title: 'Public Post', content: 'This is public content that is long enough.', author: user, published: true)

        visit article_path(article)

        expect(page).to have_content('Public Post')
        expect(page).to have_content('This is public content')
        expect(page).not_to have_link('Edit')
        expect(page).not_to have_link('Delete')
      end

      it "redirects a visitor away from a draft" do
        article = Article.create!(title: 'Draft Post', content: 'This is draft content that is long enough.', author: user, published: false)

        visit article_path(article)
        expect(page).to have_current_path(articles_path)
      end
    end

    context "deleting from show page", js: true do
      before do
        visit new_user_session_path
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it "deletes and returns to index" do
        article = Article.create!(title: 'ShowDelete', content: 'Some deletable content that is long enough.', author: user, published: true)

        visit article_path(article)
        accept_confirm do
          click_link "Delete"
        end

        # After deleting from show, we should be back on index and not see the article
        expect(page).to have_css('#articles')
        expect(page).not_to have_content('ShowDelete')
      end
    end
  end
end
