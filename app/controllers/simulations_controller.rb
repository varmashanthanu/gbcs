class SimulationsController < ApplicationController
  before_action :check_auth, only: [:index]

  def index
    @team = Team.find(params[:team])
    params[:members] ? @members = User.where(:id => params[:members]) : @members = User.where(:id => @team.members.pluck(:user_id))
    @users = search_params.paginate(page: params[:page], per_page: 15)
    Rails.logger.debug(@users.count)
  end

  def search
    @team = Team.find(params[:team][:id])
    params[:members].present? ? @members = User.find((params[:members][:id])) : @members = User.where(:id => @team.members.pluck(:user_id))
    @users = search_params.paginate(page: params[:page], per_page: 15)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    # TODO need to figure out how to recreate the list without resorting to default mets.
    params[:members].present? ? params[:members] << params[:new_member] : params[:members] = params[:new_member]
    @team = Team.find(params[:team])
    @members = User.where(:id => params[:members])
    @compatibility = YesList.compatibility(@members)
    @users = search_params.paginate(page: params[:page], per_page: 15)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def remove_member
    # TODO need to figure out how to recreate the list without resorting to default mets.
    @member = params[:remove_member].to_i
    @team = Team.find(params[:team])
    params[:members] -= [params[:remove_member]]
    @members = User.find(params[:members])
    @compatibility = YesList.compatibility(@members)
    @users = search_params.paginate(page: params[:page], per_page: 15)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def user_stats
    @user = User.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def team_skills
    @members = User.find(params[:members])
    render json: User.combined_skills(@members)
  end

  private
  def check_auth
    @team = Team.find(params[:team])
    @team.is_lead(current_user) || @team.is_member(current_user)
  end

  def search_params
    user = User.students.active.search(params[:name])
    user = user.sorter(params[:sp],params[:so])
    user = user.filter(params[:filter])
    current_user.admin ? user.active : user.active.where.not(id:current_user.id)
  end

end
