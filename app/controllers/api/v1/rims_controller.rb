# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::RimsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :rim, through: :team, through_association: :rims

    # GET /api/v1/teams/:team_id/rims
    def index
    end

    # GET /api/v1/rims/:id
    def show
    end

    # POST /api/v1/teams/:team_id/rims
    def create
      if @rim.save
        render :show, status: :created, location: [:api, :v1, @rim]
      else
        render json: @rim.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/rims/:id
    def update
      if @rim.update(rim_params)
        render :show
      else
        render json: @rim.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/rims/:id
    def destroy
      @rim.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def rim_params
        strong_params = params.require(:rim).permit(
          *permitted_fields,
          :name,
          :brand,
          :diameter,
          :width,
          :finish,
          :photo,
          :photo_removal,
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
  class Api::V1::RimsController
  end
end
