require 'rails_helper'

RSpec.describe 'password/forgot', type: :view do

  before do
    puts "DEBUG: #{Rails.application.routes.url_helpers.send_reset_code_path}"
    render
  end

  it 'displays the forgot password form' do
    expect(rendered).to have_selector('div.form-container')
    expect(rendered).to have_selector('h2', text: 'Forgot Password')
  end

  it 'has the correct form elements' do 
    expect(rendered).to have_selector("form[action='#{send_reset_code_path}'][method='post']") do |form|
      expect(form).to have_selector('label[for="email"]', text: 'Enter your registered email:')
      expect(form).to have_selector('input[type="email"][id="email"][required]')
      expect(form).to have_selector('input[type="submit"][value="Send Reset Code"]')
    end
  end

  it 'includes the back to login link' do
    expect(rendered).to have_selector('p#back_to_login') do |p|
      expect(p).to have_link('Back to Login', href: unauthenticated_root_path)
    end
  end

  it 'includes the password stylesheet' do
    expect(rendered).to have_css('link[href*="passwords"][media="all"]', visible: false)
  end

  context 'when there is a flash error' do
    before do
      flash[:error] = 'Invalid email address'
      render
    end

    it 'displays the flash error message' do
      expect(rendered).to have_selector('div.flash-error', text: 'Invalid email address')
    end
  end

  context 'when there is no flash error' do
    it 'does not display a flash error message' do
      expect(rendered).not_to have_selector('div.flash-error')
    end
  end
end