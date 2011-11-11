class UsersController < ApplicationController
  before_filter :login_required

  def index
    @users = User.find(:all,:conditions => ["is_delete = ?", 0], :order => "username, email").paginate(:page => params[:page], :per_page => 15)
  end

  def new
    @roles = Role.all
    @user = User.new
  end

  def edit
    @roles = Role.all
    @user = User.find(params[:id])
  end

  def create
    @roles = Role.all
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Registration successful."
      redirect_to users_url
    else
      render :action => 'new'
    end
  end

  def update
   @roles = Role.all
   @user = User.find(params[:id])
   if @user.update_attributes(params[:user])
     flash[:notice] = "Successfully updated profile."
     redirect_to users_url
   else
    render :action => 'edit'
   end
 end

 def destroy
   @user = User.find(params[:id])
   if @user.username == SUPERADMIN
     flash[:notice] = "#ERROR#CAN NOT delete SUPERADMIN "
   else
     ## @user.destroy
     @user.is_delete = 1
     if @user.save 
       temp_usersroles = UsersRoles.find(:all,:conditions => ["user_id = ?", @user.id])
      for t_ur in temp_usersroles
        t_ur.update_attribute(:is_delete,1)
      end
       flash[:notice] = "User #{@user.username} has been deleted" 
     else
       flash[:notice] = "#ERROR#Error in deleting user #{@user.username} " 
     end
   end
   redirect_to users_path
 end
end
