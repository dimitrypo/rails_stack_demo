require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: "test"
    end
  end

  describe "basic functionality" do
    it "inherits from ActionController::Base" do
      expect(ApplicationController.superclass).to eq(ActionController::Base)
    end

    it "responds to basic actions" do
      get :index
      expect(response).to be_successful
    end

    it "sets up the Rails environment properly" do
      get :index
      expect(controller.request).to be_present
      expect(controller.response).to be_present
    end
  end
end
