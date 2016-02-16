class CodeUsage < ActiveRecord::Base
  include AASM
  include SQLHelper

  belongs_to :access_code, counter_cache: true
  belongs_to :test
  belongs_to :user
  has_many :batch_code_usages
  has_many :batches, through: :batch_code_usages
  has_one :result

  validates_presence_of :access_code
  validate :unique_under_single_use_code
  after_create :set_uuid

  enum state: {
    generated: 1,
    used: 4,
    completed: 8
  }

  aasm :column => :state, enum: true do
    state :generated, :initial => true
    state :used
    state :completed

    event :use do
      transitions :from => :generated, :to => :used,
        guards: :validate_user
    end

    event :complete do
      transitions :from => :used, :to => :completed,
        guards: :check_test_completion_status,
        after: [ :generate_result ]
    end
  end

  private

  def unique_under_single_use_code
    code = self.access_code
    return true if code.universal?
    if code.code_usages.count >= code.permits && self.id.nil?
      errors.add(:access_code, "is valid for one-time use only")
    end
  end

  def validate_user(user)
    if user
      self.user = user
      self.save!
      return true
    end
    false
  end

  def check_test_completion_status
    check_sql = <<-SQL
    SELECT true WHERE
    (SELECT COUNT(*) FROM questions q WHERE q.test_id=#{self.test_id})
    <=
    (SELECT COUNT(*) FROM answers a WHERE a.test_id=#{self.test_id}
    AND a.user_id=#{self.user_id} AND a.result_id IS NULL)
    SQL

    extract_boolean(raw_query(check_sql))
  end

  def generate_result
    # First, create the new result object
    result = Result.create!(
      user_id: self.user_id,
      test_id: self.test_id,
      code_usage: self
    )

    # Then generate all the corresponding results to the scores table

    # 1. Generate scores to questions with scale
    scores_generator = <<-SQL
    INSERT INTO scores(user_id, test_id, result_id, category_id, value, upon)
    (SELECT #{self.user_id}, #{self.test_id}, #{result.id}, c.id,
    SUM(real_score(a.value, q.polarity, q.scale)), SUM(q.scale-1)
    FROM answers a, questions q, categories c WHERE a.test_id=#{self.test_id}
    AND a.question_id=q.id AND q.scale IS NOT NULL AND q.category_id=c.id GROUP BY c.id);
    SQL
    raw_query(scores_generator)

    # 2. Generate scores to questions that are Yes/No
    scores_generator = <<-SQL
    INSERT INTO scores(user_id, test_id, result_id, category_id, value, upon)
    (SELECT #{self.user_id}, #{self.test_id}, #{result.id}, c.id,
    SUM(real_score(a.value, q.polarity, 2)), SUM(1)
    FROM answers a, questions q, categories c WHERE a.test_id=#{self.test_id}
    AND a.question_id=q.id AND q.scale IS NULL AND q.category_id=c.id GROUP BY c.id);
    SQL
    raw_query(scores_generator)

    # Finally, update all floating answers to point to the created result
    answers_updater = <<-SQL
    UPDATE answers SET result_id=#{result.id}
    WHERE user_id=#{self.user_id} AND test_id=#{self.test_id}
    AND result_id IS NULL
    SQL
    raw_query(answers_updater)
  end

  def set_uuid
    self.uuid = SecureRandom.uuid
    self.save!
  end

end
