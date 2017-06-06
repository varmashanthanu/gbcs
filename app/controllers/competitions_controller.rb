class CompetitionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :check_authorization, only: [:edit, :update, :destroy]

  def index
    @competitions = Competition.all
  end

  def show
    @competition = Competition.find(params[:id])
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
  end

  def update
  end

  def destroy
  end

  private
  def comp_params
    params.require(:competition).permit(:name, :url,:creator_id, :description, :start, :date, :duration, :comp_type, :prize, :host)
  end

  def check_authorization
    @competition = Competition.find(params[:id])
    unless current_user.id == @competition.creator_id
      redirect_to reports_path, :notice => 'That report does not belong to you. Shame.'
    end
  end
end
