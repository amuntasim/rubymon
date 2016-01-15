module ControllerHelpers
  def sign_in(user = double('user'))
    if user.nil?
      allow(controller).to receive(:current_user).and_return(nil)
    else
      allow(controller).to receive(:current_user).and_return(user)
    end
  end
end