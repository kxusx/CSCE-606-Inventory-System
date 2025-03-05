require 'rails_helper'

RSpec.describe 'password/reset', type: :view do
  let(:user) do 
    double('User', 
      errors: double('errors', any?: false),
      model_name: ActiveModel::Name.new(User),
      to_key: nil,
      persisted?: false
    )
  end

  before do
    Rails.application.reload_routes!
    assign(:user, user)
    render
  end

  describe 'page structure' do
    it 'displays the reset password form' do
      expect(rendered).to have_selector('div.form-container-spl')
      expect(rendered).to have_selector('h2', text: 'Reset Password')
    end

    it 'has the correct form elements' do
      expect(rendered).to have_selector("form[action='#{update_password_path}'][method='post']") do |form|
        expect(form).to have_selector('label', text: 'New Password')
        expect(form).to have_selector('input[type="password"][id="password"][required]')
        expect(form).to have_selector('label', text: 'Confirm Password:')
        expect(form).to have_selector('input[type="password"][id="password_confirmation"][required]')
        expect(form).to have_selector('input[type="submit"][value="Reset Password"]')
      end
    end

    it 'includes the password stylesheet' do
      expect(rendered).to have_css('link[href*="passwords"][media="all"]', visible: false)
    end

    it 'has password requirements tooltip' do
      expect(rendered).to have_selector('.tooltip') do |tooltip|
        expect(tooltip).to have_content('Your password must:')
        expect(tooltip).to have_content('Be at least 8 characters long')
        expect(tooltip).to have_content('Include at least one uppercase letter')
        expect(tooltip).to have_content('Include at least one lowercase letter')
        expect(tooltip).to have_content('Include at least one special character')
      end
    end
  end

  describe 'error handling' do
    context 'when there are validation errors' do
      let(:error_messages) do
        {
          password: ['is too short (minimum is 8 characters)'],
          password_confirmation: ["doesn't match Password"]
        }
      end

      before do
        allow(user).to receive_messages(
          errors: double(
            'errors',
            any?: true,
            count: 2,
            to_hash: error_messages
          )
        )
        render
      end

      it 'displays error explanation section' do
        expect(rendered).to have_selector('#error_explanation')
        expect(rendered).to have_selector('h3', text: '2 errors prohibited this user from being saved:')
      end

      it 'displays password errors with attribute name' do
        expect(rendered).to have_selector('li', text: 'Password is too short (minimum is 8 characters)')
      end

      it 'displays password confirmation errors without attribute name' do
        expect(rendered).to have_selector('li', text: "doesn't match Password")
      end
    end
  end

  describe 'accessibility' do
    it 'has required form attributes' do
      expect(rendered).to have_selector('input[required]#password')
      expect(rendered).to have_selector('input[required]#password_confirmation')
      expect(rendered).to have_selector('label[for="password"]')
      expect(rendered).to have_selector('label[for="password_confirmation"]')
    end

    it 'has proper tooltip structure' do
      expect(rendered).to have_selector('.tooltip .tooltip-text')
    end
  end
end
