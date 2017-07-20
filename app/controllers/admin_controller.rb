class AdminController < ApplicationController

  # before_action :check_admin, only: [:edit, :update]

  def get_pass
  end

  def make_admin
    password = params[:master_password]
    if password == MasterPass.first.password
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: 'Admin status set.'}
        format.js { flash[:error] = 'Admin status set.' }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: 'Wrong Password.'}
        format.js { flash[:notice] = 'Wrong Password.'
        render action: "error" }
      end
    end
  end

  def edit
    @password = MasterPass.find(params[:id])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def update
    @password = MasterPass.first
    @password.update_attributes(pass_params)
    if @password.save
      respond_to do |format|
        format.js { flash[:notice] = 'Master Password Updated.' }
        format.html
      end
    else
      respond_to do |format|
        format.js { flash[:notice] = 'Failed. Try Again.'
                  render action: 'error' }
        format.html
      end
    end
  end


  private
  def check_admin
    current_user.admin ? true : redirect_back(current_user)
  end

  def pass_params
    params.require(:master_pass).permit(:password, :id)
  end
end
