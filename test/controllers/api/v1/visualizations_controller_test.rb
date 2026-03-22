require "controllers/api/v1/test"

class Api::V1::VisualizationsControllerTest < Api::Test
  setup do
    # See `test/controllers/api/test.rb` for common set up for API tests.

    @visualization = build(:visualization, team: @team)
    @other_visualizations = create_list(:visualization, 3)

    @another_visualization = create(:visualization, team: @team)

    # 🚅 super scaffolding will insert file-related logic above this line.
    @visualization.save
    @another_visualization.save

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
  def assert_proper_object_serialization(visualization_data)
    # Fetch the visualization in question and prepare to compare it's attributes.
    visualization = Visualization.find(visualization_data["id"])

    assert_equal_or_nil visualization_data["car_id"], visualization.car_id
    assert_equal_or_nil visualization_data["rim_id"], visualization.rim_id
    assert_equal_or_nil visualization_data["status"], visualization.status
    # 🚅 super scaffolding will insert new fields above this line.

    assert_equal visualization_data["team_id"], visualization.team_id
  end

  test "index" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/teams/#{@team.id}/visualizations", params: {access_token: access_token}
    assert_response :success

    # Make sure it's returning our resources.
    visualization_ids_returned = response.parsed_body.map { |visualization| visualization["id"] }
    assert_includes(visualization_ids_returned, @visualization.id)

    # But not returning other people's resources.
    assert_not_includes(visualization_ids_returned, @other_visualizations[0].id)

    # And that the object structure is correct.
    assert_proper_object_serialization response.parsed_body.first
  end

  test "show" do
    # Fetch and ensure nothing is seriously broken.
    get "/api/v1/visualizations/#{@visualization.id}", params: {access_token: access_token}
    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    get "/api/v1/visualizations/#{@visualization.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "create" do
    # Use the serializer to generate a payload, but strip some attributes out.
    params = {access_token: access_token}
    visualization_data = JSON.parse(build(:visualization, team: nil).api_attributes.to_json)
    visualization_data.except!("id", "team_id", "created_at", "updated_at")
    params[:visualization] = visualization_data

    post "/api/v1/teams/#{@team.id}/visualizations", params: params
    assert_response :success

    # # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # Also ensure we can't do that same action as another user.
    post "/api/v1/teams/#{@team.id}/visualizations",
      params: params.merge({access_token: another_access_token})
    assert_response :not_found
  end

  test "update" do
    # Post an attribute update ensure nothing is seriously broken.
    put "/api/v1/visualizations/#{@visualization.id}", params: {
      access_token: access_token,
      visualization: {
        status: "Alternative String Value",
        # 🚅 super scaffolding will also insert new fields above this line.
      }
    }

    assert_response :success

    # Ensure all the required data is returned properly.
    assert_proper_object_serialization response.parsed_body

    # But we have to manually assert the value was properly updated.
    @visualization.reload
    assert_equal @visualization.status, "Alternative String Value"
    # 🚅 super scaffolding will additionally insert new fields above this line.

    # Also ensure we can't do that same action as another user.
    put "/api/v1/visualizations/#{@visualization.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end

  test "destroy" do
    # Delete and ensure it actually went away.
    assert_difference("Visualization.count", -1) do
      delete "/api/v1/visualizations/#{@visualization.id}", params: {access_token: access_token}
      assert_response :success
    end

    # Also ensure we can't do that same action as another user.
    delete "/api/v1/visualizations/#{@another_visualization.id}", params: {access_token: another_access_token}
    assert_response :not_found
  end
end
