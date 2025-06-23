require 'rails_helper'

RSpec.describe PublicController, type: :controller do
  describe "GET #home" do
    it "returns a success response" do
      get :home
      expect(response).to be_successful
    end

    it "renders the home template" do
      get :home
      expect(response).to render_template("home")
    end

    it "returns a 200 status code" do
      get :home
      expect(response).to have_http_status(200)
    end

    it "assigns the correct content type" do
      get :home
      expect(response.content_type).to start_with('text/html')
    end
  end
end
