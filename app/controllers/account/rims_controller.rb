class Account::RimsController < Account::ApplicationController
  account_load_and_authorize_resource :rim, through: :team, through_association: :rims

  # GET /account/teams/:team_id/rims
  # GET /account/teams/:team_id/rims.json
  def index
    @q = @rims.ransack(params[:q])
    @pagy, @rims = pagy(@q.result(distinct: true).recent)
    delegate_json_to_api
  end

  # GET /account/rims/:id
  # GET /account/rims/:id.json
  def show
    @visualizations = @rim.visualizations.accessible_by(current_ability).recent
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/rims/new
  def new
  end

  # GET /account/rims/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/rims
  # POST /account/teams/:team_id/rims.json
  def create
    respond_to do |format|
      if @rim.save
        format.html { redirect_to [:account, @rim], notice: I18n.t("rims.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @rim] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rim.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/rims/:id
  # PATCH/PUT /account/rims/:id.json
  def update
    respond_to do |format|
      if @rim.update(rim_params)
        format.html { redirect_to [:account, @rim], notice: I18n.t("rims.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @rim] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rim.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/rims/:id
  # DELETE /account/rims/:id.json
  def destroy
    @rim.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :rims], notice: I18n.t("rims.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  if defined?(Api::V1::ApplicationController)
    include strong_parameters_from_api
  end

  def process_params(strong_params)
    photo = strong_params[:photo]
    unless photo.is_a?(ActionDispatch::Http::UploadedFile) && photo.size.positive?
      strong_params.delete(:photo)
    end
    # 🚅 super scaffolding will insert processing for new fields above this line.
  end
end
