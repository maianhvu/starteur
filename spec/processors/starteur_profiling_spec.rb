require 'rails_helper'
require File.join(Rails.root, 'app', 'processors', 'starteur_profiling_assessment', 'processor.rb')

describe Processor do

  before(:all) do
    define_real_score_function
  end

  # Generate test
  let!(:test) { FactoryGirl.create(:test, :full) }

  # Create dummy code usages
  let!(:user) { FactoryGirl.create(:user, :confirmed, :generic) }
  let!(:access_code) { FactoryGirl.create(:access_code, test: test) }
  let!(:code_usage) {
    cu = CodeUsage.create(access_code: access_code, test: test)
    cu.use!(user)
    cu
  }

  context 'Testing roles' do
    processor = Processor.new(nil)
    processor.get_roles
  end

  context 'With high score answers' do

    before(:each) do
      # Give high answers
      create_answers(Processor::SCORE_POTENTIAL_MAX)
    end

    it 'should give high tier scores' do
      processor = Processor.new(Result.last.id)
      result = processor.get_tier_scores
      expect(result.keys).to eq(Processor::get_tiers)
      expect(result.values.uniq).to(
        contain_exactly(Processor::get_human_readable_score(Processor::SCORE_POTENTIAL_MAX))
      )

      # High scores should give exceptional
      potential = processor.get_potential
      expect(potential[:tier]).to be(3)
      expect(potential[:name]).to eq('Exceptional')
    end
  end

  context 'With medium score answers' do
    let!(:medium_score) { Processor::SCORE_POTENTIAL_MAX / 2 }

    before(:each) do
      # Give medium answers
      create_answers(medium_score)
    end

    it 'should give medium tier scores' do
      processor = Processor.new(Result.last.id)
      result = processor.get_tier_scores
      result.values.each do |average_tier_score|
        expect(average_tier_score).to be_within(1).of(medium_score)
      end

      # Medium scores should still give beginning
      potential = processor.get_potential
      expect(potential[:tier]).to be(0)
      expect(potential[:name]).to eq('Beginning')
    end
  end

  context 'With low score answers' do
    before(:each) do
      # Give low answers
      create_answers(Processor::SCORE_POTENTIAL_MIN)
    end

    it 'should give low tier scores' do
      processor = Processor.new(Result.last.id)
      result = processor.get_tier_scores
      expect(result.values.uniq).to(
        contain_exactly(Processor::get_human_readable_score(Processor::SCORE_POTENTIAL_MIN))
      )

      # Low scores should definitely give beginning
      potential = processor.get_potential
      expect(potential[:tier]).to be(0)
      expect(potential[:name]).to eq('Beginning')
    end
  end

  context 'With scores sufficient to get developing' do
    let!(:developing_tier) { 1 }

    before(:each) do
      answer_high_up_to_tier(developing_tier)
    end

    it 'should give developing potential' do
      processor = Processor.new(Result.last.id)
      potential = processor.get_potential
      expect(potential[:tier]).to be(developing_tier)
      expect(potential[:name]).to eq('Developing')
    end
  end

  context 'With scores sufficient to get maturing' do
    let!(:maturing_tier) { 2 }

    before(:each) do
      answer_high_up_to_tier(maturing_tier)
    end

    it 'should give maturing potential' do
      processor = Processor.new(Result.last.id)
      potential = processor.get_potential
      expect(potential[:tier]).to be(maturing_tier)
      expect(potential[:name]).to eq('Maturing')
    end
  end

  private

  def create_answers(average_value)
    test.questions.each do |question|
      value = average_value
      value = question.polarity - value if question.polarity < 0
      Answer.create!(user: user, test: test, question: question, value: value)
    end
    code_usage.complete!
  end

  def answer_high_up_to_tier(tier)
    # Get all the tiers first
    tiers = Processor::get_tiers

    test.categories.each do |attribute|
      if tiers.include?(attribute.rank)
        # Rank is within potential scoring scope, pay attention to
        # specific answers
        if attribute.rank <= tier # Up to this tier only
          # Answer just at threshold
          attribute.questions.each do |question|
            value = Processor::SCORE_POTENTIAL_THRESHOLD
            value = Processor::SCORE_POTENTIAL_MAX - value if question.polarity < 0
            Answer.create!(user: user, test: test, question: question, value: value)
          end
        else
          # Answer below threshold
          attribute.questions.each do |question|
            value = 0
            value = Processor::SCORE_POTENTIAL_MAX - value if question.polarity < 0
            Answer.create!(user: user, test: test, question: question, value: value)
          end
        end

      else
        # Rank is beyond scope of potentials, can answer anything
        attribute.questions.each do |q|
          Answer.create!(user: user, test: test, question: q, value: 0)
        end
      end
    end
    code_usage.complete!
  end

end
