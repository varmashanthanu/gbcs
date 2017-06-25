class YesListsController < ApplicationController
  def new
    @yes_list = YesList.new
  end

  def create
    @yes_list = YesList.new(list_params)
    if YesList.duplicate(@yes_list).present?
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'This preference already exists.'
              render action: 'error'}
      end
    elsif @yes_list.save
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'Saved.' }
      end
    end
  end

  def index
    @yes_lists = YesList.where(user:current_user)
  end

  def destroy
    @yes_list = YesList.find(params[:id])
    YesList.destroy(params[:id])
    respond_to do |format|
      format.html
      format.js { flash[:notice] = 'Saved.' }
    end
  end

  def toggle
    @yes_list = YesList.find(params[:id])
    if @yes_list.match.downcase == 'yes'
      @yes_list.update(match:'NO')
    elsif @yes_list.match.downcase == 'no'
      @yes_list.update(match:'YES')
    end
    respond_to do |format|
      format.html
      format.js { flash[:notice] = 'Saved.' }
    end
  end

  private
  def list_params
    params.require(:yes_list).permit(:user_id,:target_id,:match,:id)
  end
end
