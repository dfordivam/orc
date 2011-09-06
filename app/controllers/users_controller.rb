class UsersController < ApplicationController
  before_filter :login_required
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
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def update
   @roles = Role.all
   @user = current_user
   if @user.update_attributes(params[:user])
     flash[:notice] = "Successfully updated profile."
     redirect_to root_url
   else
    render :action => 'edit'
   end
 end

end
