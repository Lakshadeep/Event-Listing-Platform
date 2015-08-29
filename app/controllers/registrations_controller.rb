class RegistrationsController < Devise::RegistrationsController

  def new
    super
    
    
  end

  
  def create
    super
    if @user.persisted?
      category = params[:category]

      if category.nil? != true        
          category.each do |x|
            t = Tag.find(x.to_i)
            t.users << User.find(@user.id)
        end
      end
    end
    
  end

  def update
    super
  end
end 