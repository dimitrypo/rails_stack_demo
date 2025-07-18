require 'rails_helper'

RSpec.describe ApplicationCable::Channel, type: :channel do
  it 'is defined' do
    expect(ApplicationCable::Channel).to be < ActionCable::Channel::Base
  end
end
