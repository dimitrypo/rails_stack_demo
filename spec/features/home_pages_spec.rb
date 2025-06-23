require 'rails_helper'

RSpec.describe "HomePage", type: :feature, js: true do
  def wait_for_page_load
    sleep 0.5
  end

  it "displays the home page correctly" do
    visit root_path
    wait_for_page_load

    # Test the main heading
    expect(page).to have_selector("h1", text: "Welcome to Rails Stack Demo")

    # Test the hero section description
    expect(page).to have_content("A modern Rails 7 application featuring TailwindCSS, Docker")

    # Test feature cards are present
    expect(page).to have_content("Lightning Fast")
    expect(page).to have_content("Modern Design")
    expect(page).to have_content("Docker Ready")

    # Test tech stack section
    expect(page).to have_selector("h2", text: "Built with Modern Technology")
    expect(page).to have_content("Rails 7")
    expect(page).to have_content("TailwindCSS")
    expect(page).to have_content("Docker")
    expect(page).to have_content("PostgreSQL")

    # Test stack technologies section
    expect(page).to have_content("Stack Technologies")
    expect(page).to have_content("✓ TailwindCSS Stack")
    expect(page).to have_content("✓ Docker Stack")
    expect(page).to have_content("✓ Rails 7 Stack")

    # Test development guide section
    expect(page).to have_content("Quick Development Guide")
    expect(page).to have_content("Start Docker:")
    expect(page).to have_content("docker-compose up -d")
  end

  it "has proper structure and styling" do
    visit root_path
    wait_for_page_load

    # Test that main container is present
    expect(page).to have_selector("div.p-8.max-w-7xl.mx-auto")

    # Test hero section has gradient background
    expect(page).to have_selector("div.bg-gradient-to-r.from-blue-600.to-purple-700")

    # Test feature grid is present
    expect(page).to have_selector("div.grid.md\\:grid-cols-2.lg\\:grid-cols-3")

    # Test that feature cards have proper styling
    expect(page).to have_selector("div.bg-white.p-6.rounded-lg.shadow")

    # Test tech stack grid
    expect(page).to have_selector("div.grid.grid-cols-2.md\\:grid-cols-4")

    # Test code blocks are present and styled
    expect(page).to have_selector("pre.bg-gray-800.text-green-400")
  end

  it "displays responsive design elements" do
    visit root_path
    wait_for_page_load

    # Test responsive grid classes
    expect(page).to have_selector("div.md\\:grid-cols-2")
    expect(page).to have_selector("div.lg\\:grid-cols-3")
    expect(page).to have_selector("div.md\\:grid-cols-4")

    # Test responsive text classes
    expect(page).to have_selector("h1.text-3xl.md\\:text-5xl")
    expect(page).to have_selector("p.text-lg.md\\:text-xl")
  end

  it "contains all expected content sections" do
    visit root_path
    wait_for_page_load

    # Test all major sections are present
    sections = [
      "Welcome to Rails Stack Demo",
      "Built with Modern Technology",
      "Stack Technologies",
      "Quick Development Guide"
    ]

    sections.each do |section|
      expect(page).to have_content(section)
    end

    # Test feature descriptions
    features = [
      "Built with Rails 7 and modern best practices",
      "Beautiful, responsive design with TailwindCSS",
      "Fully containerized with Docker for easy development"
    ]

    features.each do |feature|
      expect(page).to have_content(feature)
    end
  end

  it "displays code examples correctly" do
    visit root_path
    wait_for_page_load

    # Test that docker commands are displayed
    expect(page).to have_content("docker-compose up -d")
    expect(page).to have_content("docker-compose exec web rails console")
    expect(page).to have_content("docker-compose exec web rails db:migrate")

    # Test that code blocks have proper styling
    expect(page).to have_selector("pre", minimum: 1)
    expect(page).to have_selector("code", minimum: 1)
  end

  it "has proper meta information and styling" do
    visit root_path
    wait_for_page_load

    # Test page title
    expect(page).to have_title("Rails Stack Demo")

    # Test that TailwindCSS classes are applied
    expect(page).to have_selector("body.bg-gray-50")

    # Test color scheme classes
    expect(page).to have_selector(".text-white", minimum: 1)
    expect(page).to have_selector(".from-blue-600", minimum: 1)
    expect(page).to have_selector(".text-gray-600", minimum: 1)
  end
end
