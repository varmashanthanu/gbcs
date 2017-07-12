class SimulationsController < ApplicationController
  before_action :check_auth, only: [:index]

  def index
    @team = Team.find(params[:team])
    @users = search_params
    params[:members] ? @members = User.where(:id => params[:members]) : @members = User.where(:id => @team.members.pluck(:user_id))
  end

  def search
    @team = Team.find(params[:team][:id])
    @users = search_params
    params[:members] ? @members = User.where(:id => params[:members]) : @members = User.where(:id => @team.members.pluck(:user_id))
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    params[:members] << params[:new_member]
    @members = User.find(params[:members])
    @users = User.students.where.not(:id=>params[:members])
    Rails.logger.debug("TESTINGTESTING #{@members.count} #{@users.count} ")
    respond_to do |format|
      format.html
      format.js { flash[:alert] = 'Added.' }
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
    user = User.where.not(:id=>@team.members.select(:user_id))
    (user = user.where("fname iLIKE ? OR lname iLIKE ?", "%#{params[:name]}%", "%#{params[:name]}%");Rails.logger.debug("Triggered 3")) if (params[:name] && params[:name] != '')

    params.each do |k,v|
      Rails.logger.debug("Key #{k}, Value #{v}")
    end
    if (params[:sp].present? && (params[:sp][:sp1].present? || params[:sp][:sp2].present? || params[:sp][:sp3].present?))
        user = user.search(params[:sp],params[:so])
        Rails.logger.debug("Triggered 1 #{user.class}")
    else
      current_user.admin ? user = user.students.order(:program).order(score:'DESC') : user = user.gen_sort(current_user)
    end
    current_user.admin ? user : user - [current_user]
  end

end
