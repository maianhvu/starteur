const OPACITY_CHOICE_HIGHLIGHTED = 1;
const OPACITY_CHOICE_DEFAULT = 0.375;
const SCALE_GROWTH_FACTOR = 0.5;

const KEYCODE_ARROW_LEFT = 37;
const KEYCODE_ARROW_RIGHT = 39;
const KEYCODE_ARROW_DOWN = 40;

class QuestionContent extends React.Component {

  componentDidMount() {
    document.addEventListener('keydown', (e) => {
      let windowEvent = e || window.event;
      if (windowEvent.keyCode === KEYCODE_ARROW_DOWN) {
        this.props.nextQuestion();
        e.preventDefault();
        return false;
      }
    }, false);
  }

  render() {
    var answeringNode = null;

    if (this.props.question.choices.length > COUNT_CHOICES_YESNO) {
      // Multiple choice
      answeringNode = (
        <QuestionSlider
          choices={this.props.question.choices}
          scale={this.props.question.scale}
          updateParentCurrentAnswerValue={this.props.updateParentCurrentAnswerValue}
        />
      );
    } else {
      answeringNode = (
        <QuestionYesNo
          choices={this.props.question.choices}
          updateParentNextButtonEnabled={this.props.updateParentNextButtonEnabled}
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
      sliderValue: 0.5,
      previousAnswerValueUpdatedToParent: null
    };
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
      opacity: opacity,
      transform: `scale(${scaleMultiplier})`
    };
  }

  componentDidMount() {
    // Set mouse event listeners
    let knob = this.refs.sliderKnob;
    let sliderBar = this.refs.sliderBar;
    let sliderBarRect = sliderBar.getBoundingClientRect();
    let sliderStartX = sliderBarRect.left;
    let sliderBarWidth = sliderBarRect.right - sliderStartX;

    let moveKnob = (e) => {
      var newSliderValue = (e.clientX - sliderStartX) / sliderBarWidth;
      if (newSliderValue < 0) newSliderValue = 0;
      if (newSliderValue > 1) newSliderValue = 1;
      this.setState({
        sliderValue: newSliderValue
      });
    };

    let knobMouseDownEvent = (e) => {
      window.addEventListener('mousemove', moveKnob, true);
      $(ReactDOM.findDOMNode(this.refs.sliderKnob)).addClass('dragging');
    };

    let knobMouseUpEvent = (e) => {
      window.removeEventListener('mousemove', moveKnob, true);
      // Update new value to parent ONLY when the knob is released
      // and that the index has changed. Notice that the value returned
      // is NOT the choiceId but rather the sliderValue mapped to the
      // scale
      let divisionsCount = this.props.scale || this.choices.length;
      let division = 1 / divisionsCount;
      var newValue = Math.floor(this.state.sliderValue / division).constraint(0, divisionsCount - 1);
      if (newValue === this.state.previousAnswerValueUpdatedToParent) return;
      this.props.updateParentCurrentAnswerValue(newValue);
      this.setState({
        previousAnswerValueUpdatedToParent: newValue,
      });
      $(ReactDOM.findDOMNode(this.refs.sliderKnob)).removeClass('dragging');
    };

    knob.addEventListener('mousedown', knobMouseDownEvent, false);
    window.addEventListener('mouseup', knobMouseUpEvent, false);

    // Set keyboard event listeners
    document.addEventListener('keydown', (e) => {
      // Skip if knob is being dragged
      if ($(ReactDOM.findDOMNode(this.refs.sliderKnob)).hasClass('dragging'))
        return true;

      let windowEvent = e || window.event;

      // Skip irrelevant keys
      if (e.keyCode !== KEYCODE_ARROW_LEFT && e.keyCode !== KEYCODE_ARROW_RIGHT)
        return true;

      // Skip if value is already at extreme
      let divisionsCount = this.props.scale || this.choices.length;
      let division = 1 / divisionsCount;
      if (e.keyCode === KEYCODE_ARROW_LEFT  && this.state.sliderValue <= division) return;
      if (e.keyCode === KEYCODE_ARROW_RIGHT && this.state.sliderValue > division * divisionsCount) return;

      // Calculate new value
      var newValue = Math.floor(this.state.sliderValue / division).constraint(0, divisionsCount - 1);
      if (e.keyCode === KEYCODE_ARROW_LEFT) newValue--;
      else if (e.keyCode === KEYCODE_ARROW_RIGHT) newValue++;

      // Set new sliderValue
      var newSliderValue = ((newValue + 0.5) * division).constraint(0, division * (divisionsCount - 0.5));
      this.setState({ sliderValue: newSliderValue });
      this.props.updateParentCurrentAnswerValue(newValue);
      this.setState({ previousAnswerValueUpdatedToParent: newValue });
    });
  }

  getCurrentChoiceId() {
    let choices = this.props.choices;
    let choiceIndex = Math.floor(this.state.sliderValue * choices.length).constraint(0, choices.length - 1);
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

    return (
      <div className="question__slider--wrapper">
        <div className="question__choices no-select">
          {choicesNodes}
        </div>
        <div className="question__slider" ref="sliderBar">
          <div
            className="question__slider-knob"
            style={{ left: this.state.sliderValue*100 + '%' }}
            ref="sliderKnob"
          />
          {sliderMarks}
        </div>
        <div className="question__choice-text no-select">{choiceText}</div>
      </div>
    );
  }
}

class QuestionYesNo extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      currentChoiceId: null
    };
  }

  componentDidMount() {
    // Set arrow keys detection
    document.addEventListener('keydown', (e) => {
      let windowEvent = window.event || e;
      switch (windowEvent.keyCode) {
        case KEYCODE_ARROW_LEFT:
          if (!this.state.currentChoiceId) {
            // Update empty state with extreme left choiceId
            this.updateChoice(0);
          } else {
            // Else decrement choiceId
            this.updateChoice(this.state.currentChoiceId - 1);
          }
          break;
        case KEYCODE_ARROW_RIGHT:
          if (!this.state.currentChoiceId) {
            // Update empty state with extreme right choiceId
            this.updateChoice(this.props.choices.length - 1);
          } else {
            // Else increment choiceId
            this.updateChoice(this.state.currentChoiceId + 1);
          }
          break;
        default:
          return true;
      }
      e.preventDefault();
    }, false);
  }

  updateChoice(index) {
    if (index < 0 || index >= this.props.choices.length) return;
    // Does not update again for repeated id
    if (index === this.state.currentChoiceId) return;
    this.props.updateParentNextButtonEnabled(true);
    this.setState({
      currentChoiceId: index
    });
    this.props.updateParentCurrentAnswerValue(index);
  }

  render() {
    let choiceNodes = this.props.choices.map((choice, index) => {
      let classes = classNames('question__answer', 'no-select', {
        'chosen': this.state.currentChoiceId == index
      });
      return (
        <div key={index} className={classes} onClick={this.updateChoice.bind(this, index)}>
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
