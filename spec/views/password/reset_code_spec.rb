require 'rails_helper'

RSpec.describe 'password/reset_code', type: :view do
  describe 'page structure' do
    before do
      render
    end

    it 'displays the reset code form' do
      expect(rendered).to have_selector('div.form-container')
      expect(rendered).to have_selector('h2', text: 'Enter Reset Code')
    end

    it 'has the correct form elements' do
      expect(rendered).to have_selector("form[action='#{verify_reset_code_path}'][method='post']") do |form|
        expect(form).to have_selector('label[for="reset_code"]', text: 'Reset Code:')
        expect(form).to have_selector('input[type="text"][id="reset_code"][required]')
        expect(form).to have_selector('input[type="submit"][value="Verify"]')
      end
    end

    it 'includes the password stylesheet' do
      expect(rendered).to have_css('link[href*="passwords"][media="all"]', visible: false)
    end

    it 'has the resend timer text' do
      expect(rendered).to have_selector('p#resend_text')
      expect(rendered).to have_selector('span#timer', text: '30')
    end

    it 'includes the countdown script' do
      script_content = rendered.match(/<script>(.*?)<\/script>/m)[1]
      expect(script_content).to include('let countdown = 3')
      expect(script_content).to include('function updateTimer()')
    end

    it 'has the correct initial timer value' do
      expect(rendered).to have_selector('#timer', text: '30')
    end

    it 'includes the resend link path' do
      expect(rendered).to include(resend_reset_code_path)
    end
  end

  describe 'accessibility' do
    before do
      render
    end

    it 'has required form attributes' do
      expect(rendered).to have_selector('input[required]#reset_code')
      expect(rendered).to have_selector('label[for="reset_code"]')
    end
  end
end
