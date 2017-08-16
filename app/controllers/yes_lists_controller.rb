class YesListsController < ApplicationController
  def new
    @yes_list = YesList.new
    @users = User.students.no_pref(current_user)
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
    @count = YesList.group(:user_id).count.count
    current_user.admin ? @users = [User.joins(:yes_lists).select("users.*, count(yes_lists.id) as ycount").group("users.id").order("ycount DESC")].flatten.paginate(page: params[:page], per_page: 20) : @yes_lists = YesList.where(user:current_user).paginate(page: params[:page], per_page: 20)
    @users = (User.students.no_pref(current_user).order(:fname) - [current_user]).paginate(page: params[:page], per_page:10) unless current_user.admin
  end

  def difficult_graph
    render json: User.difficult
  end
  def hated_graph
    render json: User.hated
  end

  def destroy
    @yes_list = YesList.find(params[:id])
    if current_user == @yes_list.user
      YesList.destroy(params[:id])
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'Saved.' }
      end
    else
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'Not Allowed.'
                  render action: 'error'}
      end
    end
  end

  def toggle
    @yes_list = YesList.find(params[:id])
    if current_user == @yes_list.user
      if @yes_list.match.downcase == 'yes'
        @yes_list.update(match:'NO')
      elsif @yes_list.match.downcase == 'no'
        @yes_list.update(match:'YES')
      end
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'Saved.' }
      end
    else
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'Not Allowed.'
                  render action: 'error'}
      end
    end
  end

  private
  def list_params
    params.require(:yes_list).permit(:user_id,:target_id,:match,:id)
  end
end
