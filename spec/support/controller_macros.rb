module ControllerMacros
  def sign_in_user(*factory)
    let(:user) do
      create *(factory.empty? ? [:user]  : factory)
    end

    before do
      sign_out :user
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user

    end
  end

  def check_set_alert_flash_and_redirect_to?
    it { should set_flash[:alert].to('You need to sign in or sign up before continuing.') }
    it { should redirect_to(new_user_session_path) }
  end

end

