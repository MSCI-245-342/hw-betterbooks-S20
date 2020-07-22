class UsersController < ApplicationController

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  def create
    # active record new, create, and update allow us to pass in a hash with the
    # attributes and their values, user_params is a method (see below!)
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = 'User was successfully created.'  
      redirect_to @user
    else
      render :new
    end
  end

  # PATCH/PUT /users/:id
  def update
    @user = User.find(params[:id])  
    if @user.update(user_params)
      flash[:notice] = 'User was successfully updated.'
      redirect_to @user
    else
      render :edit
    end
  end

  def confirm_delete
      @user = User.find(params[:id])
      # show the form for confirm_delete of user 
  end
    
  # DELETE /users/:id
  def destroy
    @user = User.find(params[:id])  
      
    if @user.destroy
        flash[:notice] = 'User was successfully deleted.'
    else
        flash[:notice] = 'Unable to delete user.'
    end
      
    redirect_to users_url        
  end

  private
    # Only allow a trusted parameter "white list" through.
    def user_params
      # params is a hashtable.  It should have in it a key of :user.
      # The value for the :user key is another hash.
      # If params does not contain the key :user, an exception is raised.  
      # Only the "user" hash is returned and only with the permitted key(s).
      # So we get back { :name => someName, :email => someEmail}
      params.require(:user).permit(:name, :email)
    end
end
