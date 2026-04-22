# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::VisualizationsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :visualization, through: :team, through_association: :visualizations

    # Callback from the Python vision service — service-to-service, HMAC-verified.
    skip_before_action :load_team, only: :callback
    before_action :verify_callback_signature, only: :callback

    # GET /api/v1/teams/:team_id/visualizations
    def index
    end

    # GET /api/v1/visualizations/:id
    def show
    end

    # POST /api/v1/teams/:team_id/visualizations
    def create
      if @visualization.save
        render :show, status: :created, location: [:api, :v1, @visualization]
      else
        render json: @visualization.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/visualizations/:id
    def update
      if @visualization.update(visualization_params)
        render :show
      else
        render json: @visualization.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/visualizations/:id
    def destroy
      @visualization.destroy
    end

    # POST /api/v1/visualizations/:id/callback
    def callback
      visualization = Visualization.find(params[:id])

      unless params[:visualization_id].to_i == visualization.id
        return render json: {error: "visualization_id mismatch"}, status: :unprocessable_entity
      end

      case params[:status]
      when "completed"
        VisualizationFetchImageJob.perform_later(visualization.id)
        head :no_content
      when "failed"
        visualization.failed!
        Rails.logger.warn("[Callback] visualization=#{visualization.id} failed: #{params[:error]}")
        head :no_content
      else
        render json: {error: "unknown status: #{params[:status]}"}, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: {error: "not found"}, status: :not_found
    end

    private

    def verify_callback_signature
      secret = ENV.fetch("CALLBACK_HMAC_SECRET") { raise "CALLBACK_HMAC_SECRET not configured" }
      provided = request.headers["X-Wheelone-Signature"].to_s.sub(/\Asha256=/, "")
      expected = OpenSSL::HMAC.hexdigest("SHA256", secret, request.raw_post)

      return if ActiveSupport::SecurityUtils.secure_compare(provided, expected)

      head :unauthorized
    end

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def visualization_params
        strong_params = params.require(:visualization).permit(
          *permitted_fields,
          :car_id,
          :rim_id,
          :status,
          # 🚅 super scaffolding will insert new fields above this line.
          *permitted_arrays,
          # 🚅 super scaffolding will insert new arrays above this line.
        )

        process_params(strong_params)

        strong_params
      end
    end

    include StrongParameters
  end
else
  class Api::V1::VisualizationsController
  end
end
