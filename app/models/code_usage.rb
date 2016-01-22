class CodeUsage < ActiveRecord::Base
  include AASM

  belongs_to :access_code, counter_cache: true
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
        guards: :check_completion_status,
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

  def check_completion_status
    return false unless self.user
    return false unless test = self.access_code.test
    self.user.completed?(test)
  end

  def generate_result
    answers_hash = {}
    test = self.access_code.test
    user_answers_for_test = self.user.answers.where(test: test)
    user_answers_for_test.all.each do |ans|
      answers_hash[ans.question_id] = ans.value
    end
    # Create result object
    Result.create!(answers: answers_hash, user: self.user, test: test, code_usage: self)
    # Remove temporary answer objects
    user_answers_for_test.destroy_all
  end

  def set_uuid
    self.uuid = SecureRandom.uuid
    self.save!
  end

end
