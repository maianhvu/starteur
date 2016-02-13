const COUNT_CHOICES_YESNO = 2;

class QuestionBox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      loading: true,
      progress: 0,
      answeredCount: 0,
      updatedToServerCount: 0,
      questions: [],
      currentQuestionId: 0,
      isNextEnabled: false,
    };
  }

  componentDidMount() {
    this.loadQuestions();
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

      // Check if first question can allow next button to activate
      let firstQuestionAllowNextEnable = data.questions[0].choices.length > COUNT_CHOICES_YESNO;

      this.setState({
        questions: data.questions,
        answeredCount: data.answeredCount,
        loading: false,
        isNextEnabled: firstQuestionAllowNextEnable,
        answerSubmitter: answerSubmitter
      });
      this.updateProgress();

      // Start submitting
      answerSubmitter.start();
    });
  }

  setNextButtonEnabled(status) {
    this.setState({
      isNextEnabled: status
    });
  }

  updateProgress() {
    let totalQuestionsCount = this.state.questions.length + this.state.answeredCount;
    var newProgress = 0;
    if (totalQuestionsCount > 0) {
      newProgress = (this.state.currentQuestionId + this.state.answeredCount) / totalQuestionsCount;
    }
    // Based on question, see whether Next button should be enabled
    this.setState({ progress: newProgress });
  }

  goToNextQuestion() {
    // Prevent going to next question if next is disabled
    if (!this.state.isNextEnabled) return;

    // Queue current question for submission
    this.state.answerSubmitter.queue({
      questionId: this.getCurrentQuestion().id,
      value: this.state.currentAnswerValue
    });

    // Update state to display the next question
    var nextQuestionId = this.state.currentQuestionId + 1;
    var nextButtonEnabled = false;
    if (nextQuestionId < this.state.questions.length) {
      nextButtonEnabled = this.state.questions[nextQuestionId].choices.length > COUNT_CHOICES_YESNO;
    }
    this.setState({
      currentQuestionId: nextQuestionId,
      isNextEnabled: nextButtonEnabled
    });
    this.updateProgress();
  }

  setCurrentAnswerValue(answerValue) {
    this.setState({ currentAnswerValue: answerValue });
  }

  getCurrentQuestion() {
    return this.state.questions[this.state.currentQuestionId];
  }

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
    if (this.state.loading) {
      return loadingView(this.props.feedbackUrl);
    }

    var currentQuestion = this.getCurrentQuestion();
    // If the test has not concluded, display the question
    if (currentQuestion) {
      return (
        <div className="question-box">
          <QuestionProgress progress={this.state.progress} />
          <QuestionContent
            question={this.getCurrentQuestion()}
            updateParentNextButtonEnabled={this.setNextButtonEnabled.bind(this)}
            updateParentCurrentAnswerValue={this.setCurrentAnswerValue.bind(this)}
            nextQuestion={this.goToNextQuestion.bind(this)}
          />
          <QuestionActions
            nextQuestion={this.goToNextQuestion.bind(this)}
            isNextEnabled={this.state.isNextEnabled}
          />
        </div>
      );
    } else {
      // Wait for updating to server to conclude
      if (this.state.updatedToServerCount < this.state.questions.length) {
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

Number.prototype.constraint = function(min, max) {
  if (this < min) { return min; }
  if (this > max) { return max; }
  return this.valueOf();
};
