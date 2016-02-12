class QuestionBox extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      loading: true,
      progress: 0,
      answeredCount: 0,
      questions: [],
      currentQuestionId: 0
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
        this.setState({
          questions: data.questions,
          answeredCount: data.answeredCount,
          loading: false
        });
        this.updateProgress();
      }
    });
  }

  updateProgress() {
    let totalQuestionsCount = this.state.questions.length + this.state.answeredCount;
    var newProgress = 0;
    if (totalQuestionsCount > 0) {
      newProgress = (this.state.currentQuestionId + this.state.answeredCount) / totalQuestionsCount;
    }
    this.setState({ progress: newProgress });
  }

  render () {
    if (this.state.loading) {
      return loadingView(this.props.feedbackUrl);
    }

    return (
      <div className="question-box">
        <QuestionProgress progress={this.state.progress} />
        <QuestionContent question={this.state.questions[this.state.currentQuestionId]} />
        <QuestionActions />
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
