require 'rails_helper'

RSpec.describe PasswordController, type: :controller do
  let(:user) { create(:user, email: 'test@example.com', password: 'OldPassword123!') }

  describe 'GET #forgot' do
    it 'renders the forgot password page' do
      get :forgot
      expect(response).to render_template('password/forgot')
    end
  end

  describe 'POST #send_reset_code' do
    context 'with existing user email' do
      before do
        allow(UserMailer).to receive_message_chain(:reset_password_email, :deliver_now)
      end

      it 'sends reset code and redirects to reset code page' do
        post :send_reset_code, params: { email: user.email }
        
        expect(session[:reset_user_id]).to eq(user.id)
        expect(user.reload.reset_code).not_to be_nil
        expect(user.reset_sent_at).not_to be_nil
        expect(flash[:notice]).to eq('Reset code sent to your email.')
        expect(response).to redirect_to(reset_code_path)
      end

      it 'sends reset password email' do
        expect(UserMailer).to receive_message_chain(:reset_password_email, :deliver_now)
        post :send_reset_code, params: { email: user.email }
      end
    end

    context 'with non-existing user email' do
      it 'redirects back with error message' do
        post :send_reset_code, params: { email: 'nonexistent@example.com' }
        
        expect(flash[:error]).to eq('User not registered in the database')
        expect(response).to redirect_to(forgot_password_path)
      end
    end
  end

  describe 'GET #reset_code' do
    it 'renders the reset code page' do
      get :reset_code
      expect(response).to render_template('password/reset_code')
    end
  end

  describe 'POST #verify_reset_code' do
    context 'with valid reset code within time limit' do
      before do
        user.update_columns(
          reset_code: 'abc123',
          reset_sent_at: 5.minutes.ago
        )
        session[:reset_user_id] = user.id
      end

      it 'redirects to new password reset page' do
        post :verify_reset_code, params: { reset_code: 'abc123' }
        expect(response).to redirect_to(new_password_reset_path)
      end
    end

    context 'with invalid reset code' do
      before do
        user.update_columns(
          reset_code: 'abc123',
          reset_sent_at: 5.minutes.ago
        )
        session[:reset_user_id] = user.id
      end

      it 'redirects back with error message' do
        post :verify_reset_code, params: { reset_code: 'wrong123' }
        expect(flash[:console_alert]).to eq('Invalid or expired reset code')
        expect(response).to redirect_to(reset_code_path)
      end
    end

    context 'with expired reset code' do
      before do
        user.update_columns(
          reset_code: 'abc123',
          reset_sent_at: 20.minutes.ago
        )
        session[:reset_user_id] = user.id
      end

      it 'redirects back with error message' do
        post :verify_reset_code, params: { reset_code: 'abc123' }
        expect(flash[:console_alert]).to eq('Invalid or expired reset code')
        expect(response).to redirect_to(reset_code_path)
      end
    end
  end

  describe 'POST #resend_reset_code' do
    context 'with valid session' do
      before do
        session[:reset_user_id] = user.id
        allow(UserMailer).to receive_message_chain(:reset_password_email, :deliver_now)
      end

      it 'generates new reset code and redirects' do
        old_reset_code = user.reset_code
        post :resend_reset_code
        
        expect(user.reload.reset_code).not_to eq(old_reset_code)
        expect(flash[:notice]).to eq('New reset code sent to your email.')
        expect(response).to redirect_to(reset_code_path)
      end

      it 'sends new reset password email' do
        expect(UserMailer).to receive_message_chain(:reset_password_email, :deliver_now)
        post :resend_reset_code
      end
    end

    context 'with expired session' do
      it 'redirects to forgot password page' do
        post :resend_reset_code
        expect(flash[:console_alert]).to eq('Session expired. Please request a new reset code.')
        expect(response).to redirect_to(forgot_password_path)
      end
    end
  end

  describe 'POST #update' do
    context 'with valid parameters' do
      before do
        session[:reset_user_id] = user.id
      end

      it 'updates password and redirects to login' do
        post :update, params: {
          user: {
            password: 'NewPassword123!',
            password_confirmation: 'NewPassword123!'
          }
        }

        expect(user.reload.reset_code).to be_nil
        expect(session[:reset_user_id]).to be_nil
        expect(flash[:notice]).to eq('Password reset successful!')
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'with invalid parameters' do
      before do
        session[:reset_user_id] = user.id
      end

      it 'renders reset form with errors' do
        post :update, params: {
          user: {
            password: 'new',
            password_confirmation: 'different'
          }
        }

        expect(response).to render_template('password/reset')
        expect(response.status).to eq(422)
      end
    end
  end
end
