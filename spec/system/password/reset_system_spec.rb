require 'rails_helper'

RSpec.describe 'Reset Password Page', type: :system do
  let(:user) { create(:user, email: 'test@example.com', password: 'OldPassword123!') }
  
  before do
    driven_by(:selenium_chrome_headless)
    # Simulate successful reset code verification
    user.update!(
      reset_code: '123456',
      reset_sent_at: Time.current
    )
    
    # Set up the session
    page.set_rack_session(reset_user_id: user.id)
    
    # Visit the reset password page
    visit new_password_reset_path
  end

  describe 'password reset form' do
    context 'with valid passwords' do
      it 'allows password reset with valid matching passwords' do
        fill_in 'password', with: 'NewPassword123!'
        fill_in 'password_confirmation', with: 'NewPassword123!'
        click_button 'Reset Password'
        
        # Add expectations based on your success behavior
        # For example:
        # expect(page).to have_current_path(new_user_session_path)
        # expect(page).to have_content('Password reset successful!')
      end
    end

    context 'with invalid passwords' do
      it 'shows error for mismatched passwords' do
        fill_in 'password', with: 'NewPassword123!'
        fill_in 'password_confirmation', with: 'DifferentPassword123!'
        click_button 'Reset Password'
        
        expect(page).to have_content("Passwords don't match")
      end

      it 'shows error for password without requirements' do
        fill_in 'password', with: 'password'
        fill_in 'password_confirmation', with: 'password'
        click_button 'Reset Password'
        
        expect(page).to have_content('Password must include at least one uppercase letter')
      end
    end
  end

  describe 'tooltip functionality' do
    it 'shows password requirements on hover' do
      tooltip = find('.tooltip')
      tooltip.hover
      
      expect(page).to have_content('Your password must:')
      expect(page).to have_content('Be at least 8 characters long')
      expect(page).to have_content('Include at least one uppercase letter')
      expect(page).to have_content('Include at least one lowercase letter')
      expect(page).to have_content('Include at least one special character')
    end
  end
end
