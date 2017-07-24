class CompetitionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :check_authorization, only: [:edit, :update, :destroy]

  def index
    @competitions = Competition.latest.paginate(page: params[:page], per_page: 10)
  end

  def show
    @competition = Competition.find(params[:id])
    respond_to do |format|
      format.html { redirect_to competitions_path}
      format.js
    end
  end

  def new
    @competition = Competition.new
    @competition.creator_id = current_user.id
  end

  def create
    @competition = Competition.new(comp_params)
    if @competition.save
      redirect_to competition_path(@competition), notice: 'New Competition has been added.'
    else
      redirect_back(fallback_location: competitions_new_path, notice: 'Failed. Please try again.')
    end
  end

  def edit
    @competition = Competition.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @competition = Competition.find(params[:id])
    if @competition.update_attributes(comp_params)
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'Updated.' }
      end
    else
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'Update Failed.'
                  render action: 'error' }
      end
    end
  end

  def destroy
    @competition = Competition.find(params[:id]).destroy
    respond_to do |format|
      format.html {redirect_to(competitions_path, notice: 'Deleted.')}
      format.js { flash[:notice] = 'Deleted.' }
    end
  end

  def select_team
    @teams = current_user.teams
    @competition = Competition.find(params[:competition])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def join_comp
    @competition = Competition.find(params[:competition])
    if @comp_team.save
      respond_to do |format|
        format.html
        format.js { flash[:notice] = "You are participating in #{@comp_team.competition.name} with Team #{@comp_team.team.name}." }
      end
    else
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'Unable to add team to competition.'
                  render action: 'error' }
      end
    end
  end

  def leave_comp
    @comp_team = CompTeam.where(competition:@competition, team:@team).first
    @comp_team.destroy
    respond_to do |format|
      format.html
      format.js { flash[:notice] = 'Your team has left this competition.' }
    end
  end

  private
  def comp_params
    params.require(:competition).permit(:name, :url,:creator_id, :description, :start, :date, :duration, :comp_type, :prize, :host)
  end

  def check_authorization
    @competition = Competition.find(params[:id])
    unless current_user.admin || current_user == @competition.creator
      redirect_to @competition, :notice => 'Authorization Error.'
    end
  end
end
