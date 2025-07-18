require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  it 'is defined' do
    expect(ApplicationCable::Connection).to be < ActionCable::Connection::Base
  end
end
