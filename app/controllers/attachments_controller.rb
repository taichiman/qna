class AttachmentsController < ApplicationController
  before_action :authenticate_user!
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
    if @attachment.attachable.user_id != current_user.id
      render(text: "You not #{@attachment.attachable_type} owner")
    end

  end

end

