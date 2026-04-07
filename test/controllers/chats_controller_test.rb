require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      email: "chat@example.com",
      password: "password",
      password_confirmation: "password",
      free: true,
      advance: false,
      pro: false
    )
  end

  test "redirects when not logged in" do
    get chats_url
    assert_redirected_to login_url
  end

  test "should get index when logged in" do
    post login_url, params: { email: @user.email, password: "password" }
    get chats_url
    assert_response :success
  end
end
