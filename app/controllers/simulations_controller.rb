class SimulationsController < ApplicationController
  before_action :check_auth, only: [:index]

  def index
    @team = Team.find(params[:team])
    params[:members] ? @members = User.where(:id => params[:members]) : @members = User.where(:id => @team.members.pluck(:user_id))
    @users = search_params
  end

  def search
    @team = Team.find(params[:team][:id])
    params[:members].present? ? @members = User.find((params[:members][:id])) : @members = User.where(:id => @team.members.pluck(:user_id))
    Rails.logger.debug("Testing #{params[:members][:id]}") #TODO Remove
    Rails.logger.debug("Testing #{params[:members][:id].class}") #TODO Remove
    Rails.logger.debug("Testing #{User.where(id:params[:members][:id]).count}") #TODO Remove
    Rails.logger.debug("Testing #{@members.pluck(:id)}") #TODO Remove
    @users = search_params
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
    Rails.logger.debug("Action NEW #{@members.count} #{@members.first.name}")
    @compatibility = YesList.compatibility(@members)
    @users = search_params
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
    Rails.logger.debug("TESTONG #{params[:members]}") # TODO REMOVE
    Rails.logger.debug("TESTONG #{@member.class}, member-#{@member}") # TODO REMOVE
    @members = User.find(params[:members])
    @users = search_params
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
    Rails.logger.debug("TESTINGTESTING #{User.combined_skills(@members)}")
    render json: User.combined_skills(@members)
  end

  private
  def check_auth
    @team = Team.find(params[:team])
    @team.is_lead(current_user) || @team.is_member(current_user)
  end

  def search_params #TODO remove loggers
    user = User.where.not(:id=>@members.pluck(:id))
    (user = user.where("fname iLIKE ? OR lname iLIKE ?", "%#{params[:name]}%", "%#{params[:name]}%");Rails.logger.debug("Triggered 3")) if (params[:name] && params[:name] != '')

    params.each do |k,v|
      Rails.logger.debug("Key #{k}, Value #{v}")
    end
    if params[:sp].present? && (params[:sp][:sp1].present? || params[:sp][:sp2].present? || params[:sp][:sp3].present?)
        user = user.search(params[:sp],params[:so])
        Rails.logger.debug("Triggered 1 #{user.class}")
    else
      current_user.admin ? user = user.students.order(:program).order(score:'DESC') : user = user.gen_sort(current_user)
    end
    current_user.admin ? user : user - [current_user]
  end

end
