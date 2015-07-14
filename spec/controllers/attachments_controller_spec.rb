require 'rails_helper'

describe AttachmentsController do
  describe 'destroy #DELETE' do
    let!(:attachment){ create :attachment_with_question }
    let(:question){ attachment.attachable }

    before do |example|
      unless example.metadata[:skip_request]
        xhr :post, :destroy, id: attachment
      end
    end

    it 'assigns an attached file id' do
      expect(assigns(:attachment)).to eq attachment
    end

    it 'deletes one an attachment from Attachment', skip_request: true do
      expect{
        xhr :post, :destroy, id: attachment
      }.to change(Attachment,:count).by(-1) 
    end

    it 'deletes the attached question' do
      expect{ Attachment.find(attachment.id) }.to raise_error 
    end

    it 'render js view' do
      expect(response).to render_template(:destroy)
    end

  end
end

