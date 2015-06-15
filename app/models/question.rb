class Question < ActiveRecord::Base
  has_many :answers, dependent: :restrict_with_exception

  validates :title, :body, presence: true

  belongs_to :user
 
  scope :my, -> (user) { where( user: user) }

  def owner? user
    if user.nil?
      false
    else
      self.user_id == user.id
    end

  end

end

