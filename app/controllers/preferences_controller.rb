class PreferencesController < ApplicationController

  def edit
    @preference = current_user.preference
  end

  def update
    @preference = current_user.preference
    if @preference.update_attributes(pref_params)
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'Saved.' }
      end
    else
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'Unable to save, Please try again.'
                  render action: 'error'}
      end
    end
  end

  private
  def pref_params
    params.require(:preference).permit(:location,:competition,:id)
  end
end
