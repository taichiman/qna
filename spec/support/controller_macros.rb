module ControllerMacros
  def sign_in_user
    before do
      @user = create :user
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end

  def check_set_alert_flash_and_redirect_to?
    it { should set_flash[:alert].to('You need to sign in or sign up before continuing.') }
    it { should redirect_to(new_user_session_path) }
  end

end

