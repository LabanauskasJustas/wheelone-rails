class Account::VisualizationsController < Account::ApplicationController
  account_load_and_authorize_resource :visualization, through: :team, through_association: :visualizations

  # GET /account/teams/:team_id/visualizations
  # GET /account/teams/:team_id/visualizations.json
  def index
    @q = @visualizations.ransack(params[:q])
    @pagy, @visualizations = pagy(@q.result(distinct: true).recent)
    delegate_json_to_api
  end

  # GET /account/visualizations/:id
  # GET /account/visualizations/:id.json
  def show
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/visualizations/new
  def new
  end

  # GET /account/visualizations/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/visualizations
  # POST /account/teams/:team_id/visualizations.json
  def create
    respond_to do |format|
      if @visualization.save
        format.html { redirect_to [:account, @visualization], notice: I18n.t("visualizations.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @visualization] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @visualization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/visualizations/:id
  # PATCH/PUT /account/visualizations/:id.json
  def update
    respond_to do |format|
      if @visualization.update(visualization_params)
        format.html { redirect_to [:account, @visualization], notice: I18n.t("visualizations.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @visualization] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @visualization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/visualizations/:id
  # DELETE /account/visualizations/:id.json
  def destroy
    @visualization.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :visualizations], notice: I18n.t("visualizations.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
