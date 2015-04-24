class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  belongs_to :user
 
  scope :my, -> (user){ where( user: user) } 
end
