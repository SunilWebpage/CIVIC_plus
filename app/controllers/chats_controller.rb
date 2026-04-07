class ChatsController < ApplicationController
  before_action :require_login
  helper_method :display_name_for_user

  def index
    @users = User.where.not(id: current_user.id).order(:email)
    @filter_room_id = params[:filter_room_id].presence || authenticated_room_id
    rooms_scope = current_user.rooms.includes(:admin, room_memberships: :user).order(updated_at: :desc)
    @joined_rooms = if @filter_room_id.present?
      rooms_scope.where(id: @filter_room_id)
    else
      rooms_scope
    end
    @current_room = @filter_room_id.present? ? @joined_rooms.first : nil
    @room_users = @current_room ? @current_room.users.where.not(id: current_user.id).order(:email) : []
    @show_direct_messages = @current_room.present?
    if current_user.admin_rooms.exists?
      @show_direct_messages = true
      @room_users = @users
    end
    @conversations = current_user.conversations.includes(:sender, :recipient, :chat_messages).order(updated_at: :desc)
    @selected_conversation = find_selected_conversation
    @messages = @selected_conversation ? @selected_conversation.chat_messages.includes(:user).order(:created_at) : []

    @share_items = QuestionPaper.order(year: :desc).limit(6).map do |paper|
      {
        title: paper.title,
        subtitle: "#{paper.category} • #{paper.year}",
        url: SafeUrl.normalize(paper.pdf_url) || question_paper_path(paper)
      }
    end
  end

  def create
    other_user = User.find(params[:user_id])
    conversation = Conversation.find_or_create_between!(current_user, other_user)

    redirect_to chats_path(conversation_id: conversation.id)
  end

  def create_message
    @selected_conversation = current_user.conversations.find(params[:conversation_id])
    @selected_conversation.chat_messages.create!(user: current_user, body: params[:body].to_s.strip)

    redirect_to chats_path(conversation_id: @selected_conversation.id)
  rescue ActiveRecord::RecordInvalid
    redirect_to chats_path(conversation_id: @selected_conversation.id), alert: "Message cannot be blank."
  end

  def create_room
    @room = current_user.admin_rooms.build(room_params)

    if @room.save
      display_name = params[:display_name].presence || current_user.email
      @room.room_memberships.find_or_create_by!(user: current_user) do |membership|
        membership.display_name = display_name
      end
      mark_room_authenticated(@room.id)
      redirect_to chats_path, notice: "Room created successfully."
    else
      load_chat_index_state
      render :index, status: :unprocessable_entity
    end
  end

  def join_room
    @room = Room.find_by(name: params[:name].to_s.strip)

    unless @room&.authenticate(params[:password].to_s)
      redirect_to chats_path, alert: "Invalid room name or password."
      return
    end

    membership = @room.room_memberships.find_or_initialize_by(user: current_user)
    membership.display_name = params[:display_name].presence || current_user.email
    membership.save!
    mark_room_authenticated(@room.id)
    redirect_to chats_path(filter_room_id: @room.id), notice: "Joined room successfully."
  end

  def destroy_room
    @room = current_user.admin_rooms.find_by(id: params[:room_id])
    return redirect_to chats_path, alert: "Room not found or you are not the admin." unless @room

    @room.destroy
    redirect_to chats_path, notice: "Room deleted."
  end

  def destroy_conversation
    conversation = current_user.conversations.find_by(id: params[:conversation_id])
    return redirect_to chats_path, alert: "Conversation not found." unless conversation

    conversation.destroy
    redirect_to chats_path, notice: "Conversation deleted."
  end

  def remove_member
    room = current_user.admin_rooms.find_by(id: params[:room_id])
    return redirect_to chats_path, alert: "Room not found or you are not the admin." unless room

    membership = room.room_memberships.find_by(user_id: params[:user_id])
    return redirect_to chats_path, alert: "Member not found." unless membership

    name = membership.display_name.presence || membership.user.email
    membership.destroy
    redirect_to chats_path, notice: "#{name} removed."
  end

  private

  def load_chat_index_state
    @users = User.where.not(id: current_user.id).order(:email)
    @filter_room_id = params[:filter_room_id].presence || authenticated_room_id
    rooms_scope = current_user.rooms.includes(:admin, room_memberships: :user).order(updated_at: :desc)
    @joined_rooms = if @filter_room_id.present?
      rooms_scope.where(id: @filter_room_id)
    else
      rooms_scope
    end
    @current_room = @filter_room_id.present? ? @joined_rooms.first : nil
    @room_users = @current_room ? @current_room.users.where.not(id: current_user.id).order(:email) : []
    @show_direct_messages = @current_room.present?
    @conversations = current_user.conversations.includes(:sender, :recipient, :chat_messages).order(updated_at: :desc)
    @selected_conversation = find_selected_conversation
    @messages = @selected_conversation ? @selected_conversation.chat_messages.includes(:user).order(:created_at) : []
    @share_items = QuestionPaper.order(year: :desc).limit(6).map do |paper|
      {
        title: paper.title,
        subtitle: "#{paper.category} • #{paper.year}",
        url: SafeUrl.normalize(paper.pdf_url) || question_paper_path(paper)
      }
    end
  end

  def room_params
    params.require(:room).permit(:name, :password, :password_confirmation)
  end

  def display_name_for_user(user)
    return "" unless user

    display_name = user.display_name.presence ||
      user.room_memberships.order(updated_at: :desc).where.not(display_name: [ nil, "" ]).limit(1).pluck(:display_name).first
    display_name.presence || user.email
  end

  def mark_room_authenticated(room_id)
    session[:authenticated_room_ids] ||= []
    session[:authenticated_room_ids] << room_id unless session[:authenticated_room_ids].include?(room_id)
  end

  def authenticated_room_id
    ids = session[:authenticated_room_ids]
    return ids.first if ids&.any?

    current_user.room_memberships.order(:created_at).limit(1).pluck(:room_id).first
  end

  def find_selected_conversation
    return @conversations.first if params[:conversation_id].blank?

    current_user.conversations.find_by(id: params[:conversation_id]) || @conversations.first
  end
end
