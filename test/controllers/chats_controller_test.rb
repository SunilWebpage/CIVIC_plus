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
    @friend = User.create!(
      email: "friend@example.com",
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

  test "creates a conversation between two users" do
    post login_url, params: { email: @user.email, password: "password" }

    assert_difference("Conversation.count", 1) do
      post chats_url, params: { user_id: @friend.id }
    end

    assert_redirected_to chats_url(conversation_id: Conversation.last.id)
  end

  test "creates a room with current user as admin" do
    post login_url, params: { email: @user.email, password: "password" }

    assert_difference("Room.count", 1) do
      post create_room_chats_url, params: {
        room: {
          name: "Tamil Group",
          password: "secret123",
          password_confirmation: "secret123"
        }
      }
    end

    assert_equal @user, Room.last.admin
  end
end
