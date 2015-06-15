class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  scope :my, ->(user) { Answer.where(user: user) }
  scope :best_answer, ->(question) { question.answers.where(best: true) }

  answers = Answer.arel_table
  scope :best_in_first, ->(question) do
    #question.answers.order(best: :desc, created_at: :asc)
    Answer.find_by_sql(answers.project(Arel.star).where(answers[:question_id].eq(question.id)).order(answers[:best].desc, answers[:created_at].asc).to_sql)
  end

  def select_as_best
    new_best = self
    old_best = Answer.best_answer(self.question).take
  
    if old_best != new_best
      old_best.try(:update, {best: false})
    end
    new_best.toggle!(:best)
    old_best

  end

  def owner? user
    if user.nil?
      false
    else
      self.user_id == user.id
    end

  end

end

