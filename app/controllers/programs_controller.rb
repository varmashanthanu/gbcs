class ProgramsController < ApplicationController
  before_action :check_admin

  def index
    @programs = Program.asc
  end

  def show
    @program = Program.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @program = Program.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @program = Program.new(program_params)
    if @program.save
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'Add Successful.'}
      end
    else
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'Error, please try again.'
                  render action: 'error'}
      end
    end
  end

  def edit
    @program = Program.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @program = Program.find(params[:id])
    if @program.update_attributes(program_params)
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'Saved.' }
      end
    else
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'Update Unsuccessful.'
                  render action: 'error'}
      end
    end
  end

  def destroy
    @program = Program.find(params[:id])
    if @program.destroy
      respond_to do |format|
        format.html
        format.js { flash[:notice] = 'Deleted Program.' }
      end
    else
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  private
  def check_admin
    unless current_user.admin
      redirect_to current_user, notice: 'Administrator-only Action.'
    end
  end

  def program_params
    params.require(:program).permit(:id,:name,:description)
  end

end
