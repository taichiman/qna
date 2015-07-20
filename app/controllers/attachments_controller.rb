class AttachmentsController < ApplicationController
  before_action :set_attachment
  before_action :only_owner

  def destroy
    @attachment.destroy

  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
    
  end

  def only_owner
    owner = if current_user.nil?
      false
    else
      @attachment.attachable.user_id == current_user.id
    end
    
    render(text: "You not #{@attachment.attachable_type} owner") unless owner

  end

end

