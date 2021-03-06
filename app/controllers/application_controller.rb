class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  helper_method :current_user
  helper_method :user_signed_in?
  helper_method :correct_user?

  private
  def current_user
    begin
      if session[:user_id]
        @current_user ||= User.find(session[:user_id])
      elsif params[:auth_token]
        @current_user || User.where(auth_token: params[:auth_token]).first
      end
    rescue Exception => e
      nil
    end
  end

  def user_signed_in?
    return true if current_user
  end

  def correct_user?
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to root_url, :alert => "Access denied."
    end
  end

  def authenticate_user!
    if !current_user
      respond_to do |format|
        format.html { redirect_to root_url, :alert => 'You need to sign in for access to this page.'}
        format.json { render json: {user: :invalid},  status: :unprocessable_entity }
      end

    end
  end

end
