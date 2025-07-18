require 'rails_helper'

RSpec.feature "User Authentication", type: :feature, js: true do
  let!(:user) { create(:user, email: 'user@example.com', password: 'password', password_confirmation: 'password') }

  feature "Login page" do
    scenario "displays login form with custom styling" do
      visit new_user_session_path

      expect(page).to have_content("Sign in to your account")
      expect(page).to have_content("Demo account:")
      expect(page).to have_field("Email")
      expect(page).to have_field("Password")
      expect(page).to have_button("Sign in")
      expect(page).to have_field("Remember me", type: 'checkbox')

      # Check for TailwindCSS classes
      expect(page).to have_css('.bg-white.shadow-lg.rounded-lg')
    end

    scenario "shows demo credentials" do
      visit new_user_session_path

      expect(page).to have_content("user@example.com")
      expect(page).to have_content("password")

      # Check that demo credentials have the right styling
      expect(page).to have_css('.text-indigo-600.cursor-pointer', text: 'user@example.com')
      expect(page).to have_css('.text-indigo-600.cursor-pointer', text: 'password')
    end
  end

  feature "Clickable demo credentials" do
    scenario "clicking email populates email field" do
      visit new_user_session_path

      expect(find_field('Email').value).to eq('')

      find('.text-indigo-600.cursor-pointer', text: 'user@example.com').click

      expect(find_field('Email').value).to eq('user@example.com')
    end

    scenario "clicking password populates password field" do
      visit new_user_session_path

      expect(find_field('Password').value).to eq('')

      find('.text-indigo-600.cursor-pointer', text: 'password').click

      expect(find_field('Password').value).to eq('password')
    end

    scenario "can populate both fields and login" do
      visit new_user_session_path

      find('.text-indigo-600.cursor-pointer', text: 'user@example.com').click
      find('.text-indigo-600.cursor-pointer', text: 'password').click

      click_button 'Sign in'

      expect(page).to have_content('Signed in successfully.')
      expect(page).to have_current_path(root_path)
    end
  end

  feature "Login functionality" do
    scenario "successful login with valid credentials" do
      visit new_user_session_path

      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Sign in'

      expect(page).to have_content('Signed in successfully.')
      expect(page).to have_current_path(root_path)
      expect(page).not_to have_link('Login')
    end

    scenario "failed login with invalid credentials" do
      visit new_user_session_path

      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'wrongpassword'
      click_button 'Sign in'

      expect(page).to have_content('Invalid Email or password.')
      expect(page).to have_current_path(new_user_session_path)
    end

    scenario "remember me functionality" do
      visit new_user_session_path

      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      check 'Remember me'
      click_button 'Sign in'

      expect(page).to have_content('Signed in successfully.')
    end
  end

  feature "User dropdown menu" do
    before do
      sign_in user
      visit root_path
    end

    scenario "displays user email in header" do
      within('nav.bg-white') do
        expect(page).to have_content('user@example.com')
        expect(page).to have_css('.bg-gradient-to-r.from-purple-500.to-pink-500', text: 'U')
      end
    end

    scenario "dropdown opens on click" do
      within('nav.bg-white') do
        expect(page).not_to have_link('Logout')

        find('button', text: 'user@example.com').click

        expect(page).to have_link('Logout')
      end
    end

    scenario "dropdown closes when clicking outside" do
      within('nav.bg-white') do
        find('button', text: 'user@example.com').click
        expect(page).to have_link('Logout')
      end

      find('h1', text: 'Welcome to Rails Stack Demo').click

      within('nav.bg-white') do
        expect(page).not_to have_link('Logout')
      end
    end
  end

  feature "Logout functionality" do
    before do
      sign_in user
      visit root_path
    end

    scenario "user can logout successfully" do
      within('nav.bg-white') do
        find('button', text: 'user@example.com').click
        click_link 'Logout'
      end

      expect(page).to have_content('Signed out successfully.')
      expect(page).to have_link('Login')
      expect(page).not_to have_content('user@example.com')
    end
  end

  feature "Authentication protection" do
    scenario "unauthenticated users see Login button" do
      visit root_path

      within('nav.bg-white') do
        expect(page).to have_link('Login')
        expect(page).not_to have_content('user@example.com')
      end
    end

    scenario "authenticated users see user dropdown" do
      sign_in user
      visit root_path

      within('nav.bg-white') do
        expect(page).not_to have_link('Login')
        expect(page).to have_content('user@example.com')
      end
    end
  end
end
