const COUNT_CHOICES_YESNO = 2;

class QuestionBox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      loading: true,
      progress: 0,
      answeredCount: 0,
      questions: [],
      currentQuestionId: 0,
      isNextEnabled: false,
      currentAnswerValue: null
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
      contentType: 'application/json',
      success: (data) => {

        // FIXME: Debug (swap last and first)
        // var firstQuestion = data.questions[0];
        // data.questions[0] = data.questions[data.questions.length - 1];
        // data.questions[data.questions.length - 1] = firstQuestion;

        this.setState({
          questions: data.questions,
          answeredCount: data.answeredCount,
          loading: false
        });
        this.updateProgress();
      }
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

    var nextQuestionId = this.state.currentQuestionId + 1;
    let nextButtonEnabled = this.state.questions[nextQuestionId].choices.length > COUNT_CHOICES_YESNO;
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

  render () {
    if (this.state.loading) {
      return loadingView(this.props.feedbackUrl);
    }

    return (
      <div className="question-box">
        <QuestionProgress progress={this.state.progress} />
        <QuestionContent
          question={this.state.questions[this.state.currentQuestionId]}
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
  }
}

QuestionBox.propTypes = {
  questionsFetchUrl: React.PropTypes.string.isRequired,
  questionsPostUrl: React.PropTypes.string.isRequired,
  feedbackUrl: React.PropTypes.string.isRequired
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

Number.prototype.constraint = function(min, max) {
  if (this < min) { return min; }
  if (this > max) { return max; }
  return this.valueOf();
};
