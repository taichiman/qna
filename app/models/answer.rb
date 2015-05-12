class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :my, ->(user) { Answer.where(user: user) }

end

