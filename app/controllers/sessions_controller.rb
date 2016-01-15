class SessionsController < ApplicationController

  def new
    redirect_to '/auth/facebook'
  end

  def create
    auth = request.env["omniauth.auth"] || params[:auth]
    user = User.where(:provider => auth['provider'],
                      :uid => auth['uid'].to_s).first || User.create_with_omniauth(auth)
    reset_session
    session[:user_id] = user.id
    respond_to do |format|
      if user
        format.html { redirect_to root_url, :notice => 'Signed in!' }
        format.json do
          auth_token = SecureRandom.hex(16)+user.id.to_s
          user.update_column(:auth_token, auth_token)
          render json: {success: true, auth_token: auth_token}
        end
      else
        format.html { redirect_to :root }
        format.json { render json: user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    reset_session
    respond_to do |format|
      format.html { redirect_to root_url, :notice => 'Signed out!' }
      format.json { render json: {success: true} }
    end
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

end
