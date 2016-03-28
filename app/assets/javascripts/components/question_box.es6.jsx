// ------------------------------------------------------------------------------------------------
// CONSTANTS
// ------------------------------------------------------------------------------------------------
const DEBUG_SUBMIT_ANSWERS = true;

const COUNT_CHOICES_YESNO = 2;

/* Key definitions */
const KEYCODE_ARROW_LEFT = 37;
const KEYCODE_ARROW_RIGHT = 39;
const KEYCODE_ARROW_DOWN = 40;

const KEYCODE_NEXT_QUESTION = KEYCODE_ARROW_DOWN;
const KEYCODE_PREVIOUS_VALUE = KEYCODE_ARROW_LEFT;
const KEYCODE_NEXT_VALUE = KEYCODE_ARROW_RIGHT;

// ------------------------------------------------------------------------------------------------
// MAIN CLASS
// ------------------------------------------------------------------------------------------------
class QuestionBox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      loading: true,
      answeredCount: 0,

      currentQuestionId: 0,
      currentAnswerValue: null,
      overridingParentValue: false,

      progress: 0,
      updatedToServerCount: 0,
      questions: []
    };
  }

  componentDidMount() {
    this.loadQuestions();
    this.registerKeyboardShortcuts();
  }

  loadQuestions() {
    $.ajax({
      url: this.props.questionsFetchUrl,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json'
    }).done((data) => {
      // FIXME: Debug (swap last and first)
      // var firstQuestion = data.questions[0];
      // data.questions[0] = data.questions[data.questions.length - 1];
      // data.questions[data.questions.length - 1] = firstQuestion;

      // Initialize answer submitter
      let answerSubmitter = new AnswerSubmitter(
        this.props.answersPostUrl,
        this.receiveAnswersSubmitResponse.bind(this)
      );

      // Get data about first question
      let firstQuestion = data.questions[0];
      // Initialize currentAnswerValue
      let currentAnswerValue = null;
      if (isMcqQuestion(firstQuestion)) {
        currentAnswerValue = getDefaultValueForMcq(firstQuestion);
      }

      // Populate the initial data to the component
      this.setState({
        questions: data.questions,
        answeredCount: data.answeredCount,
        loading: false,
        answerSubmitter: answerSubmitter,

        currentAnswerValue: currentAnswerValue
      });
      this.updateProgress();

      // Start submitting
      if (DEBUG_SUBMIT_ANSWERS) {
        answerSubmitter.start();
      }
    });
  }

  /**
   * Set some universal keyboard shortcuts to make user interaction
   * with the component faster and more convenient. Key definitions
   * are in constants definitions at the start of this document.
   */
  registerKeyboardShortcuts() {
    document.addEventListener('keydown', (e) => {

      let windowEvent = e || window.event;
      switch(windowEvent.keyCode) {
        case KEYCODE_NEXT_QUESTION:
          this.goToNextQuestion();
          break;
        case KEYCODE_PREVIOUS_VALUE:
          // Check for null currentAnswerValue
          let currentAnswerValue = this.state.currentAnswerValue || 0;
          this.setCurrentAnswerValue(currentAnswerValue - 1);
          break;
        case KEYCODE_NEXT_VALUE:
          // Check for null currentAnswerValue
          var currentAnswerValue = this.state.currentAnswerValue;
          if (currentAnswerValue === null || currentAnswerValue === undefined) {
            let currentQuestion = this.getCurrentQuestion();
            let maxValue = currentQuestion.scale || currentQuestion.choices.length;
            let limit = maxValue - 1;
            this.setCurrentAnswerValue(limit);
          } else {
            this.setCurrentAnswerValue(currentAnswerValue + 1);
          }
          break;
        default:
          return true;
      }
      windowEvent.preventDefault();
      return false;
    }, false);
  }

  updateProgress(currentQuestionId = 0) {
    let totalQuestionsCount = this.state.questions.length + this.state.answeredCount;
    var newProgress = 0;
    if (totalQuestionsCount > 0) {
      newProgress = (currentQuestionId + this.state.answeredCount) / totalQuestionsCount;
    }
    this.setState({
      progress: newProgress
    });
  }

  /**
   * Check if we can advance to the next question
   * @return Boolean whether this action is allowed
   */
  canGoToNext() {
    return this.state.currentAnswerValue != null;
  }

  /**
   * Advance to the next question if this action is allowed (determined by
   * the state value `isNextEnabled`. Will also queue the previous answer
   * value for submitting to server.
   * @param force Boolean whether to force the question to go forward
   * @param questionId Number the questionId forced to go to
   */
  goToNextQuestion() {
    // Prevent going to next question if next is disabled
    if (!this.canGoToNext()) {
      return;
    }

    // Queue current question for submission
    let answerObject = {
      questionId: this.getCurrentQuestion().id,
      value: this.state.currentAnswerValue
    };

    this.state.answerSubmitter.queue(answerObject);
    console.log('queued',answerObject);

    // Advance the question ID
    var nextQuestionId = this.state.currentQuestionId + 1;

    // Determine whether the `Next` button is going to be allowed
    // by seeing whether the next question is a MCQ question or not.
    // By default, MCQ questions do not have a pre-selected value and
    // thus the user needs to select a choice before advancing
    //
    // This is in contrast to slider-based questions where the new
    // answer value is always the middle value.
    var newAnswerValue = null;

    // The following condition also tests whether the questionnaire has ended
    // In which case, the questionId will be larger than or equal to the number
    // of available questions
    if (nextQuestionId < this.state.questions.length &&
        this.state.questions[nextQuestionId].choices.length > COUNT_CHOICES_YESNO) {
      newAnswerValue = Math.floor(this.state.questions[nextQuestionId].scale / 2);
    }

    // Finally, update state
    this.setState({
      currentQuestionId: nextQuestionId,
      currentAnswerValue: newAnswerValue
    });

    // Update progress bar
    this.updateProgress(nextQuestionId);
  }

  /**
   * Update the current state for the chosen value, which will then
   * be later sent to the server. This will also trickle down the
   * update to child components. A side-effect of this function is
   * that it will also enable the `Next` button (provided the `answerValue` is
   * neither null nor undefined.
   *
   * @param answerValue Number The answer value received from child component
   */
  setCurrentAnswerValue(answerValue) {
    let currentQuestion = this.getCurrentQuestion();
    let limit = currentQuestion.scale || currentQuestion.choices.length;
    let maxValue = limit - 1;

    answerValue = answerValue.constrain(0, maxValue);

    // Does not update repeated value
    if (answerValue === this.state.currentAnswerValue) {
      return;
    }

    this.setState({
      currentAnswerValue: answerValue
    });
  }

  /**
   * @param doesOverride Boolean Determines whether
   * to override or to un-override parent's value
   */
  setOverrideParentValue(doesOverride) {
    this.setState({
      overridingParentValue: doesOverride
    });
  }

  /**
   * Convenient method to get the long-ass current question
   * @return Object The object that represents the current question
   * as defined by currentQuestionId
   */
  getCurrentQuestion() {
    return this.state.questions[this.state.currentQuestionId];
  }

  isTestCompleted() {
    return this.state.currentQuestionId >= this.state.questions.length;
  }

  isStillUploadingAnswersToServer() {
    return this.state.updatedToServerCount < this.state.questions.length;
  }

  /**
   * This method is triggered by the `answerSubmitter` once
   * it receives a response from the remote server that the questions
   * are updated. The server sends back an array of the `questionIds`
   * that are successfully updated
   *
   * This method will add all these questionIds to a Set object to
   * make sure all the added IDs are unique. That way we can make
   * sure that we account for every single question without duplicates
   *
   * @param response Array{Integer} An array containing all the question IDs
   * where their answers have been successfully registered
   */
  receiveAnswersSubmitResponse(response) {
    if (response.constructor !== Array) return;
    response.forEach((questionId) => {
      this.props.answeredSet.add(questionId);
    });
    // Update count
    this.setState({
      updatedToServerCount: this.props.answeredSet.size
    });
  }

  render () {

    // If this component is still trying to fetch questions from
    // the server, then we will display the loading view instead.
    if (this.state.loading) {
      return loadingView(this.props.feedbackUrl);
    }

    var currentQuestion = this.getCurrentQuestion();

    // If the test has not concluded, display the question
    if (!this.isTestCompleted()) {
      return (
        <div className="question-box">
          <QuestionProgress progress={this.state.progress} />
          <QuestionContent
            question={this.getCurrentQuestion()}
            answerValue={this.state.currentAnswerValue}
            overridingParentValue={this.state.overridingParentValue}
            updateParentCurrentAnswerValue={this.setCurrentAnswerValue.bind(this)}
            updateParentSetOverrideValue={this.setOverrideParentValue.bind(this)}
          />
          <QuestionActions
            nextQuestion={this.goToNextQuestion.bind(this)}
            isNextEnabled={this.canGoToNext()}
          />
        </div>
      );
    } else {
      // Wait for updating to server to conclude
      if (this.isStillUploadingAnswersToServer()) {
        return updatingToServerView();
      } else {
        // Redirect to specified page after finishing test
        window.location = this.props.finishTestUrl;
      }
    }
  }
}

QuestionBox.propTypes = {
  questionsFetchUrl: React.PropTypes.string.isRequired,
  answersPostUrl: React.PropTypes.string.isRequired,
  finishTestUrl: React.PropTypes.string.isRequired,
  feedbackUrl: React.PropTypes.string.isRequired
};

QuestionBox.defaultProps = {
  answeredSet: new Set()
};

//-------------------------------------------------------------------------------------------------
// VIEWS DEFINITION
//-------------------------------------------------------------------------------------------------
let loadingView = function(feedbackUrl) {
  return (
    <div className="test-loader">
      <h1>Loading...</h1>
      <p>
        If the tests are unable to load, it's probably because your browser has its
        JavaScript turned off. If you notice any issues, please provide some feedback
        to us <span><a href={feedbackUrl} className="link">here</a></span>.
      </p>
    </div>
  )
};

let updatingToServerView = function() {
  return (
    <div className="test-loader">
      <h1>Finishing Up...</h1>
      <p>
        Congratulations on completing the test! Now just sit back and relax while
        we do some housekeeping. Should only take a jiffy!
      </p>
    </div>
  );
};

//-------------------------------------------------------------------------------------------------
// HELPER FUNCTIONS
//-------------------------------------------------------------------------------------------------
Number.prototype.constrain = function(min, max) {
  if (this < min) { return min; }
  if (this > max) { return max; }
  return this.valueOf();
};

let isMcqQuestion = function(question) {
  return question.scale != null;
};

let getDefaultValueForMcq = function(question) {
  return Math.floor(question.scale / 2);
};
