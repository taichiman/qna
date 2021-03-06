class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions, dependent: :restrict_with_exception
  has_many :answers, dependent: :delete_all

  def owner_of? object
    self.id == object.user_id
  end

end

