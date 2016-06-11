const OPACITY_CHOICE_HIGHLIGHTED = 1;
const OPACITY_CHOICE_DEFAULT = 0.375;
const SCALE_GROWTH_FACTOR = 0.5;

class QuestionContent extends React.Component {
  render() {
    var answeringNode = null;

    if (this.props.question.choices.length > COUNT_CHOICES_YESNO) {
      // Multiple choice
      answeringNode = (
        <QuestionSlider
          choices={this.props.question.choices}
          scale={this.props.question.scale}
          value={this.props.answerValue}
          overridingParentValue={this.props.overridingParentValue}
          updateParentSetOverrideValue={this.props.updateParentSetOverrideValue}
          updateParentCurrentAnswerValue={this.props.updateParentCurrentAnswerValue}
        />
      );
    } else {
      // Yes-No type question
      answeringNode = (
        <QuestionYesNo
          choices={this.props.question.choices}
          currentChoiceId={this.props.answerValue}
          updateParentCurrentAnswerValue={this.props.updateParentCurrentAnswerValue}
        />
      );
    }

    return (
      <div className="question__content">
        <div className="question__text">{this.props.question.content}</div>
        {answeringNode}
      </div>
    );
  }
}

class QuestionSlider extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      sliderValue: props.defaultSliderValue
    };
  }

  getDivision() {
    let divisionCount = this.props.scale || this.props.choices.length;
    return {
      count: divisionCount,
      amount: 1 / divisionCount
    };
  }

  /**
   * Calculates the actual slider value from the answerValue passed down
   * from the parent node
   * @param fromValue Number The value to use instead of the current props
   * @return Number The slider value bounded between 0 and 1
   */
  calculateSliderValue() {
    var value = this.props.value;
    let division = this.getDivision();
    let sliderValue = ((value + 0.5) * division.amount)
      .constrain(0, 1 - division.amount / 2);
    return sliderValue;
  }

  /**
   * Calculate the answer value that corresponds to the
   * current state of the sliderValue (or the specified
   * fromValue)
   * @param fromValue Number(optional) The value to override
   */
  calculateAnswerValue(fromValue) {
    let sliderValue = fromValue || this.state.sliderValue;
    let divisionAmount = this.getDivision().amount;
    return Math.floor(sliderValue / divisionAmount);
  }

  styleForNode(nodeId) {
    let division = 1/(this.props.choices.length-1);
    let tolerance = division/2;

    // Calculate opacity
    let nodeCenter = division * nodeId;
    let distanceFromValue = Math.abs(this.state.sliderValue - nodeCenter);
    var opacityMultiplier = 0;
    if (distanceFromValue < tolerance) {
      opacityMultiplier = 1 - (distanceFromValue / tolerance);
    }
    let opacity = OPACITY_CHOICE_DEFAULT +
      (OPACITY_CHOICE_HIGHLIGHTED - OPACITY_CHOICE_DEFAULT) * opacityMultiplier;

    // Calculate scale
    var scaleMultiplier = 1;
    if (distanceFromValue < tolerance) {
      scaleMultiplier += (1 - (distanceFromValue / tolerance)) * SCALE_GROWTH_FACTOR;
    }

    return {
      opacity: 1,
      transform: `scale(0.9)`
//      transform: `scale(${scaleMultiplier})`
    };
  }

  componentDidMount() {
    // Set mouse event listeners
    let knob = this.refs.sliderKnob;
    let sliderBarRect = this.refs.sliderBar.getBoundingClientRect();
    let sliderBarWidth = sliderBarRect.right - sliderBarRect.left;

    let moveKnob = (e) => {
      var newSliderValue = ((e.clientX - sliderBarRect.left) / sliderBarWidth).constrain(0, 1);
      this.setState({
        sliderValue: newSliderValue
      });
    };

    let knobMouseDownEvent = (e) => {
      // Add cursor movement tracker listener to be active
      window.addEventListener('mousemove', moveKnob, true);
      window.addEventListener('mouseup', knobMouseUpEvent, false);
      // Set override parent value
      this.props.updateParentSetOverrideValue(true);
      // Add styling class to DOM element of slider knob
      $(ReactDOM.findDOMNode(this.refs.sliderKnob)).addClass('dragging');
    };

    let knobMouseUpEvent = (e) => {
      // Disable cursor movement tracker
      window.removeEventListener('mousemove', moveKnob, true);

      // Update value to parent
      let answerValue = this.calculateAnswerValue();
      this.props.updateParentCurrentAnswerValue(answerValue);

      // Set UN-override parent value
      this.props.updateParentSetOverrideValue(false);

      // Update internal state of sliderValue
      this.setState({
        sliderValue: this.calculateSliderValue()
      });

      // Remove styling class from element
      $(ReactDOM.findDOMNode(this.refs.sliderKnob)).removeClass('dragging');

      // Remove listener
      window.removeEventListener('mouseup', knobMouseUpEvent, false);
    };

    // Register listeners
    knob.addEventListener('mousedown', knobMouseDownEvent, false);
  }

  handleSliderBarClick(e) {
    let windowEvent = e || window.event;
    let sliderBarRect = this.refs.sliderBar.getBoundingClientRect();
    let sliderBarWidth = sliderBarRect.right - sliderBarRect.left;

    var newSliderValue = ((windowEvent.clientX - sliderBarRect.left) / sliderBarWidth).constrain(0, 1);
    this.props.updateParentCurrentAnswerValue(
      this.calculateAnswerValue(newSliderValue)
    );
    this.setState({ sliderValue: this.calculateSliderValue() });
  }

  getCurrentChoiceId() {
    let choices = this.props.choices;
    let choiceIndex = Math.floor(this.state.sliderValue * choices.length)
      .constrain(0, choices.length - 1);
    return choiceIndex;
  }

  render() {
    let choices = this.props.choices;
    let division = 1 / choices.length;

    let choicesNodes = choices.map((choice, index) => {
      let nodeStyle = this.styleForNode(index);
      return (
        <div className="question__choice" key={index} style={nodeStyle} >
          {choice}
        </div>);
    });

    // Calculate index of current choice
    let choiceText = choices[this.getCurrentChoiceId()];

    // Generate marks for slider
    let sliderMarks = [];
    for (var i = 0; i < Math.floor(choices.length / 2); i++) {
      let markStyle = {
        width: `${division*100}%`,
        left: ((i*2+1) * 100 / choices.length) + "%"
      };
      sliderMarks.push(
        <div key={i} className="question__slider-mark" style={markStyle} />
      );
    }

    var perceivedSliderPosition = null;
    if (this.props.overridingParentValue) {
      perceivedSliderPosition = this.state.sliderValue;
    } else {
      perceivedSliderPosition = this.calculateSliderValue();
    }
    perceivedSliderPosition = perceivedSliderPosition * 100 + '%';

    return (
      <div className="question__slider--wrapper">
        <div className="question__choices no-select">
          {choicesNodes}
        </div>
        <div className="question__slider" ref="sliderBar" onClick={this.handleSliderBarClick.bind(this)}>
          <div
            className="question__slider-knob"
            style={{ left: perceivedSliderPosition }}
            ref="sliderKnob"
          />
          {sliderMarks}
        </div>
           <div className="question__choice-text no-select">{ }</div>
   </div>
    );
  }
}
//        <div className="question__choice-text no-select">{choiceText}</div>

QuestionSlider.defaultProps = {
  defaultSliderValue: 0.5
};

class QuestionYesNo extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      currentChoiceId: null
    };
  }

  render() {
    let choiceNodes = this.props.choices.map((choice, index) => {
      let classes = classNames('question__answer', 'no-select', {
        'chosen': this.props.currentChoiceId == index
      });
      return (
        <div key={index} className={classes}
          onClick={this.props.updateParentCurrentAnswerValue.bind(this, index)}>
          {choice}
        </div>
      );
    });

    return (
      <div className="question__yesno--wrapper">
        {choiceNodes}
      </div>
    );
  }
}
