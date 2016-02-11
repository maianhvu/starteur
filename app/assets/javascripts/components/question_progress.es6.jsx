const MILESTONES_COUNT = 6;

class QuestionProgress extends React.Component {
  render() {
    return (
      <div className="question__progress">
        <div className="progress__label">Progress</div>
        <ProgressBar progress={this.props.progress} milestonesCount={MILESTONES_COUNT} />
      </div>
    );
  }
}

QuestionProgress.propTypes = {
  progress: React.PropTypes.number.isRequired
};

class ProgressBar extends React.Component {
  render() {

    // Define nodes and populate milestones
    let division = 1 / (this.props.milestonesCount-1);
    var milestoneNodes = [];
    // Get positions
    for (var i = 1; i <= this.props.milestonesCount; i++) {
      milestoneNodes.push(i);
    }
    // Map each position to a node
    milestoneNodes = milestoneNodes.map((element, index) => {
      let classes = classNames("progress__milestone", {
        "completed": index*division < this.props.progress
      });
      return (
        <div key={element} className={classes} />
      );
    });

    return (
      <div className="progress">
        <div className="progress__bar">
          <div className="progress__line" style={{ width: `${this.props.progress*100}%`}} />
        </div>
        {milestoneNodes}
      </div>
    );
  }
}

ProgressBar.propTypes = {
  progress: React.PropTypes.number.isRequired,
  milestonesCount: React.PropTypes.number.isRequired
};
