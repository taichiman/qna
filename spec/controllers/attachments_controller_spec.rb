require 'rails_helper'

describe AttachmentsController do
  describe 'destroy #DELETE' do
    let!(:attachment){ create :attachment_with_question }
    let(:question){ attachment.attachable }

    context 'when user is owner of the attachable' do

      before do |example|
        @request.env['devise.mapping'] = Devise.mappings[:user]
        sign_in question.user

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

    context 'when user is not owner the attachable' do
      sign_in_user :user

      before do
        xhr :post, :destroy, id: attachment
      end

      it 'should can not delete attachment' do
        expect( Attachment.find(attachment.id) ).to be_a(Attachment)
        
      end

    end

  end

end

