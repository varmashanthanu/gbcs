module CompetitionsHelper

  def show
    @team = @competition.user_team(current_user) if user_signed_in?
  end

  def join_comp
    @team = Team.find(params[:team][:id]) || Team.create(team_params)
    @comp_team = CompTeam.new(competition:@competition,team:@team)
  end

  def leave_comp
    @competition = Competition.find(params[:competition])
    @team = Team.find(params[:team])
  end
end
