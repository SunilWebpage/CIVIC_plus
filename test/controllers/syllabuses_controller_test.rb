require "test_helper"

class SyllabusesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get syllabuses_url
    assert_response :success
  end

  test "filters syllabus by exam family" do
    get syllabuses_url(filter: "neet")

    assert_response :success
    assert_includes @response.body, "NEET"
    assert_not_includes @response.body, "IBPS PO / Clerk"
  end
end
