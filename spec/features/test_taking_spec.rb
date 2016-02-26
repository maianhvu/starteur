require 'rails_helper'

RSpec.feature 'Test Taking', type: :feature do

  given(:user) { FactoryGirl.create(:user, :confirmed) }
  given(:test) { FactoryGirl.create(:test, :full) }
  given(:access_code) { FactoryGirl.create(:access_code, test: test) }

  background do
    CodeUsage.create!(
      user: user,
      test: test,
      access_code: access_code,
      state: CodeUsage.states[:used]
    )
    define_real_score_function
  end

  scenario 'User takes a full test from start to end', :js => true do
    expect(test.categories.count).to be(Category.count)
    expect(test.questions.count).to be(Question.count)

    cu = CodeUsage.last
    expect(cu.user_id).to be(user.id)
    expect(cu.test_id).to be(test.id)
    expect(cu.access_code_id).to be(access_code.id)
    expect(cu).to be_used

    sign_in_using(user)
    visit take_test_path(test.id)

    # Start spamming answers to test
    question_box = find '.question-box'

    expect {
      within question_box do

        loop do
          # Detect MCQ questions
          if mcq_choice = first(:css, '.question__answer')
            mcq_choice.click
          end

          # Go to next question
          if next_button = first(:css, '.question__next-button')
            next_button.click
          else
            break
          end
        end

        wait_for_ajax
      end
    }.to change { Result.count }.by(1)
      .and change { Score.count }.by(test.categories.count)
      .and change { Answer.count }.by(test.questions.count)

    expect(cu.reload).to be_completed

    result = Result.last
    expect(result.user_id).to be(user.id)
    expect(result.test_id).to be(test.id)

    scores = Score.where(test: test, user: user, result: result)
    expect(scores.count).to be(test.categories.count)
  end

end
