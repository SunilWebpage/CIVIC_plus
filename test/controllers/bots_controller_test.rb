require "test_helper"

class BotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "bot@example.com",
      password: "password",
      password_confirmation: "password",
      free: true,
      advance: false,
      pro: false
    )
  end

  test "redirects when not logged in" do
    get bots_url
    assert_redirected_to login_url
  end

  test "should get index when logged in" do
    post login_url, params: { email: @user.email, password: "password" }
    get bots_url
    assert_response :success
  end

  test "returns ai answer when logged in" do
    client = Minitest::Mock.new
    client.expect(:configured?, true)
    client.expect(:ask, "AI answer", [ "Explain photosynthesis" ])

    post login_url, params: { email: @user.email, password: "password" }

    GroqChatClient.stub :new, client do
      post ask_bots_url, params: { question: "Explain photosynthesis" }, as: :json
    end

    assert_response :success
    assert_equal "AI answer", JSON.parse(@response.body)["answer"]
    client.verify
  end
end
