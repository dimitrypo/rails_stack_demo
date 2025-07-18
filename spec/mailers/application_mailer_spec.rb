require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  it 'is defined' do
    expect(ApplicationMailer).to be < ActionMailer::Base
  end

  it 'has correct default from address' do
    expect(ApplicationMailer.default[:from]).to eq("from@example.com")
  end

  it 'uses mailer layout' do
    expect(ApplicationMailer._layout).to eq("mailer")
  end
end
