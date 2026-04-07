require "test_helper"

class ExamPracticesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "practice@example.com",
      password: "password",
      password_confirmation: "password",
      free: true,
      advance: false,
      pro: false
    )

    @exam_practice = ExamPractice.new(
      title: "Maths Model Test 1",
      subject: "Maths",
      exam_type: "Practice Test",
      duration_minutes: 60,
      total_marks: 50,
      questions_text: "1. Solve x + 2 = 5"
    )
  end

  test "redirects index when not logged in" do
    get exam_practices_url
    assert_redirected_to login_url
  end

  test "shows index when logged in" do
    post login_url, params: { email: @user.email, password: "password" }
    ExamPractice.stub :order, [ @exam_practice ] do
      get exam_practices_url
      assert_response :success
    end
  end
end
