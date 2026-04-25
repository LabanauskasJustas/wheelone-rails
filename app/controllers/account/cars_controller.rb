class Account::CarsController < Account::ApplicationController
  account_load_and_authorize_resource :car, through: :team, through_association: :cars

  # GET /account/teams/:team_id/cars
  # GET /account/teams/:team_id/cars.json
  def index
    @q = @cars.ransack(params[:q])
    @pagy, @cars = pagy(@q.result(distinct: true).recent)
    delegate_json_to_api
  end

  # GET /account/cars/:id
  # GET /account/cars/:id.json
  def show
    @visualizations = @car.visualizations.accessible_by(current_ability).recent
    delegate_json_to_api
  end

  # GET /account/teams/:team_id/cars/new
  def new
  end

  # GET /account/cars/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/cars
  # POST /account/teams/:team_id/cars.json
  def create
    respond_to do |format|
      if @car.save
        format.html { redirect_to [:account, @car], notice: I18n.t("cars.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @car] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/cars/:id
  # PATCH/PUT /account/cars/:id.json
  def update
    respond_to do |format|
      if @car.update(car_params)
        format.html { redirect_to [:account, @car], notice: I18n.t("cars.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @car] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/cars/:id
  # DELETE /account/cars/:id.json
  def destroy
    @car.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :cars], notice: I18n.t("cars.notifications.destroyed") }
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
