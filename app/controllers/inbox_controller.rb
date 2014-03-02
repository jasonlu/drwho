class InboxController < ApplicationController

  before_filter :authenticate_user!
  before_filter :check_profile

  def index
    @current_section = 'account'
    @inboxes = current_user.inboxes
    #@messages = current_user.messages
  end

  def show
    @current_section = 'account'
    @inbox = Inbox.find(params[:inbox_id])
    #@message = Message.find(params[:id])
    @message = @inbox.message
    
    @inbox.read = true
    @inbox.save
  end

  def read
  end

  def delete
  end
end
