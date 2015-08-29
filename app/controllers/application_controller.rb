class ApplicationController < ActionController::Base
  # protect_from_forgery
  after_filter :set_access_control_headers

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

  #called before any method which requires admin rights
  # def is_admin
  #   user_id = current_user.id
  #   user = User.find(user_id)
  #   if user.is_admin
  #     return true
  #   else
  #     flash[:notice] = 'You dont have admin rights'
  #     redirect_to(:action => 'index',:controller => 'publics')
  #     return false
  #   end
  # end

  
  #decides which layout to use based on who is accessing the app public/logged in/admin
  def get_layout
    if user_signed_in?
      User.find(current_user.id).is_admin ? 'admin': 'user' 
    else
      'application'
    end
  end

  

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Request-Method'] = '*'
  end
end
