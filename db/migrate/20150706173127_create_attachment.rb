class CreateAttachment < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file

    end
  end
end
