require "test_helper"

class SyllabusesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get syllabuses_url
    assert_response :success
  end
end
