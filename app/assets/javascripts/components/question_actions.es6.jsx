class QuestionActions extends React.Component {
  render() {
    let nextButtonClasses = classNames(
      'question__next-button',
      'button', 'ghost', 'no-select',
      { 'disabled': !this.props.isNextEnabled }
    );

    var nextButtonClick = function() { return false; }
    if (this.props.isNextEnabled) {
      nextButtonClick = this.props.nextQuestion;
    }

    return (
      <div className="question__actions">
        <div className={nextButtonClasses} onClick={nextButtonClick}>
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

QuestionActions.propTypes = {
  nextQuestion: React.PropTypes.func.isRequired
};
