# Api::V1::ApplicationController is in the starter repository and isn't
# needed for this package's unit tests, but our CI tests will try to load this
# class because eager loading is set to `true` when CI=true.
# We wrap this class in an `if` statement to circumvent this issue.
if defined?(Api::V1::ApplicationController)
  class Api::V1::CarsController < Api::V1::ApplicationController
    account_load_and_authorize_resource :car, through: :team, through_association: :cars

    # GET /api/v1/teams/:team_id/cars
    def index
    end

    # GET /api/v1/cars/:id
    def show
    end

    # POST /api/v1/teams/:team_id/cars
    def create
      if @car.save
        render :show, status: :created, location: [:api, :v1, @car]
      else
        render json: @car.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/v1/cars/:id
    def update
      if @car.update(car_params)
        render :show
      else
        render json: @car.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/v1/cars/:id
    def destroy
      @car.destroy
    end

    private

    module StrongParameters
      # Only allow a list of trusted parameters through.
      def car_params
        strong_params = params.require(:car).permit(
          *permitted_fields,
          :brand,
          :model,
          :year,
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
  class Api::V1::CarsController
  end
end
