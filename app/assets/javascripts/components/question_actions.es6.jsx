class QuestionActions extends React.Component {

  notifyParentNextQuestion() {
    console.log('next question');
  }

  render() {
    return (
      <div className="question__actions">
        <div className="question__next-button button ghost" onClick={this.notifyParentNextQuestion}>
          Next <span className="chevron" />
        </div>
        <div className="question__minor-actions">
          <div className="actions__skip-question">Skip, answer this question later</div>
          <div className="actions__help">Need help?</div>
        </div>
      </div>
    );
  }
}
