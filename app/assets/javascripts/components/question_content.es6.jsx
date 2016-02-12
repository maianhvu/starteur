const COUNT_CHOICES_YESNO = 2;
const OPACITY_CHOICE_HIGHLIGHTED = 1;
const OPACITY_CHOICE_DEFAULT = 0.375;
const SCALE_GROWTH_FACTOR = 0.5;

class QuestionContent extends React.Component {
  render() {
    var answeringNode = null;

    if (this.props.question.choices.length > COUNT_CHOICES_YESNO) {
      // Multiple choice
      answeringNode = (<QuestionSlider choices={this.props.question.choices} />);
    } else {
      answeringNode = (<QuestionYesNo />);
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
      sliderValue: 0.5
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
    // Set listeners
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

    let knobMouseDownEvent = function(e) {
      window.addEventListener('mousemove', moveKnob, true);
    };
    let knobMouseUpEvent = function(e) {
      window.removeEventListener('mousemove', moveKnob, true);
    };

    knob.addEventListener('mousedown', knobMouseDownEvent, false);
    window.addEventListener('mouseup', knobMouseUpEvent, false);
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
    let choiceIndex = Math.floor(this.state.sliderValue * choices.length);
    if (choiceIndex >= choices.length) choiceIndex = choices.length - 1;
    let choiceText  = choices[choiceIndex];

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
        <div className="question__choices">
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
        <div className="question__choice-text">{choiceText}</div>
      </div>
    );
  }
}

class QuestionYesNo extends React.Component {
  render() {
    return (<div className="question__yesno">Hello, QuestionYesNo</div>);
  }
}
