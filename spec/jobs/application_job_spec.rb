require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  it 'is defined' do
    expect(ApplicationJob).to be < ActiveJob::Base
  end
end
