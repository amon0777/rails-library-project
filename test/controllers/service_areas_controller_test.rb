require "test_helper"

class ServiceAreasControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get service_areas_index_url
    assert_response :success
  end

  test "should get show" do
    get service_areas_show_url
    assert_response :success
  end
end
