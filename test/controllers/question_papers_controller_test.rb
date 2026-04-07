require "test_helper"

class QuestionPapersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get question_papers_url
    assert_response :success
  end

  test "should get show" do
    get question_paper_url(question_papers(:one))
    assert_response :success
  end
end
