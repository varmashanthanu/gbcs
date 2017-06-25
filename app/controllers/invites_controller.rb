class InvitesController < ApplicationController

  def new
    @invite = Invite.new
    # @team = params[:team]
    # Rails.logger.debug("test #{params[:team_id]}")
  end

  def create
    @invite = Invite.new(invite_params)
    if Invite.duplicate(@invite).present?
      respond_to do |format|
        format.html
        format.js { flash[:notice] = "#{@invite.user.name} has already been invited to join #{@invite.team.name}"
                    render action: 'error'}
      end
    elsif @invite.save
      respond_to do |format|
        format.html
        format.js { flash[:notice] = "An invitation has been sent to #{@invite.user.name}."}
      end
    end
  end

  def destroy
    @invite = Invite.destroy(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:sender_id, :user_id, :team_id)
  end

end
