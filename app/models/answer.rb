class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :my, ->(user) { Answer.where(user: user) }

  def select_as_best
    new_best = self
    old_best = get_old_best_answer

    if old_best != new_best
      old_best.try(:update, {best: false})
    end
    new_best.toggle!(:best)
    old_best
  end

  private
  
  def get_old_best_answer
    self.question.answers.where(best: true).take
  
  end

end

