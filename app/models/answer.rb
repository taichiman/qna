class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :my, ->(user) { Answer.where(user: user) }
  scope :best_answer, ->(question) { question.answers.where(best: true) }

  def select_as_best
    new_best = self
    old_best = Answer.best_answer(self.question).take
  
    if old_best != new_best
      old_best.try(:update, {best: false})
    end
    new_best.toggle!(:best)
    old_best

  end

end

