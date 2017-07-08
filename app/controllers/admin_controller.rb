class AdminController < ApplicationController

  def get_pass
  end

  def make_admin
    password = params[:master_password]
    Rails.logger.debug(password)
    Rails.logger.debug(MasterPass.first.password)
    if password == MasterPass.first.password
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: 'Admin status set.'}
        format.js { flash[:notice] = 'Admin status set.' }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: 'Wrong Password.'}
        format.js { flash[:notice] = 'Wrong Password.'
        render action: "error" }
      end
    end
  end
end
