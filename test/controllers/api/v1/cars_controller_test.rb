require "controllers/api/v1/test"

class Api::V1::CarsControllerTest < Api::Test
  setup do
    # See `test/controllers/api/test.rb` for common set up for API tests.

    @car = build(:car, team: @team)
    @other_cars = create_list(:car, 3)

    @another_car = create(:car, team: @team)

    @car.photo = Rack::Test::UploadedFile.new("test/support/foo.txt")
    @another_car.photo = Rack::Test::UploadedFile.new("test/support/foo.txt")
    # 🚅 super scaffolding will insert file-related logic above this line.
    @car.save
    @another_car.save

    @original_hide_things = ENV["HIDE_THINGS"]
    ENV["HIDE_THINGS"] = "false"
    Rails.application.reload_routes!
  end

  teardown do
    ENV["HIDE_THINGS"] = @original_hide_things
    Rails.application.reload_routes!
  end

  # This assertion is written in such a way that new attributes won't cause the tests to start failing, but removing
  # data we were previously providing to users _will_ break the test suite.
  def assert_proper_object_serialization(car_data)
    # Fetch the car in question and prepare to compare it's attributes.
    car = Car.find(car_data["id"])

    assert_equal_or_nil car_data["name"], car.name
    assert_equal car_data["photo"], rails_blob_path(@car.photo) unless controller.action_name == "create"
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal car_data["team_id"], car.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/cars", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    car_ids_returned = response.parsed_body.map { |car| car["id"] }
    assert_includes(car_ids_returned, @car.id)

    # But not returning other people's resources.
    assert_not_includes(car_ids_returned, @other_cars[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/cars/#{@car.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/cars/#{@car.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    car_data = JSON.parse(build(:car, team: nil).api_attributes.to_json)
    car_data.except!("id", "team_id", "created_at", "updated_at")
    params[:car] = car_data

    post "/api/v1/teams/#{@team.id}/cars", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/cars",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/cars/#{@car.id}", params: {
      access_token: access_token,
      car: {
        name: "Alternative String Value",
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @car.reload
    assert_equal @car.name, "Alternative String Value"
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/cars/#{@car.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Car.count", -1) do
      delete "/api/v1/cars/#{@car.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/cars/#{@another_car.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
