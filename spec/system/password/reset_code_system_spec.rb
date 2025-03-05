require 'rails_helper'

RSpec.describe 'Reset Code Page', type: :system do
  include Devise::Test::IntegrationHelpers
  include Rails.application.routes.url_helpers

  before(:each) do
    Rails.application.reload_routes!
  end
  
  before do
    driven_by(:selenium_chrome_headless)
    visit reset_code_path
  end

  describe 'form submission' do
    it 'shows error for invalid code' do
      fill_in 'reset_code', with: '123456'
      
      click_button 'Verify'
      expect(page).to have_current_path(reset_code_path)
      puts "✅ Test Passed: invalid code"
    end
  end

  describe 'timer functionality' do
    it 'updates the timer text after countdown' do
      expect(page).to have_selector('#timer', text: '30')
      
      # Wait for countdown to finish
      sleep 4 # Since countdown is set to 3 seconds
      expect(page).to have_selector('#resend_link', text: 'Resend in 0 seconds')
      puts "✅ Test Passed: timer functionality"
    end
  end
end