class AccessController < ApplicationController
  before_filter :confirm_logged_in,:except => [:login,:logout,:attempt_login,:attempt_signup,:signup]

	def login
  end

  def attempt_login
    if params[:email].present? && params[:password].present?
      found_user = User.where(:email => params[:email]).first
      if found_user
        authorized_user = found_user.authenticate(params[:password])
      end
      if authorized_user
        #check if user is blocked
        if User.find(authorized_user.id).is_blocked
          flash[:notice] = 'Your EventApp account has been blocked by the admin'
          redirect_to(:action=>"login", :controller=>"access")
        else
          flash[:notice] = 'You have successfully logged in'
          session[:user_id] = authorized_user.id
          session[:username] = authorized_user.name
          if session[:previous_url].nil?
            redirect_to(:action=>"location", :controller=>"users")
          else
            #in case user was directed to login from some other page,  direct him back to same page
            prev_url = session[:previous_url]
            session[:previous_url] = nil
            redirect_to prev_url
          end 
        end
      else
        flash[:notice] = 'Invalid username or password'
        redirect_to(:action=>"login", :controller=>"access")
      end
    end
  end

  def logout
    session[:user_id] = nil
    session[:username] = nil
    flash[:notice] = 'Successfully logged out'
    redirect_to(:action=>"login", :controller=>"access")
  end

  def signup
  end

  def attempt_signup
    user_hash = {
      "name" => params[:name],
      "email" => params[:email],
      "password" => params[:pwd],
      "password_confirmation" => params[:pwd_confirm],
      "profile_pic" => params[:profile_pic]
    }
    user = User.create_user(user_hash)

    if user[0].nil?
      flash[:notice] = user[1]
      redirect_to(:action => 'signup')
    else
      #if user created successfully add the user interests
      category = params[:category]
      category.each do |x|
        t = Tag.find(x.to_i)
        t.users << User.find(user[0].id)
      end
      flash[:notice] = 'You have successfully signed up'
      redirect_to(:action=>"login", :controller=>"access")
    end
  end
end
