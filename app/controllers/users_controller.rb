class UsersController < ApplicationController
  before_filter :login_required

  def index
    @users = User.paginate(:page => params[:page], :per_page => 5)
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
   @user.destroy
   redirect_to users_path
 end

end
