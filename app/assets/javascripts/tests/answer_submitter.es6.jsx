const INTERVAL_ANSWER_UPDATE = 2000;

class AnswerSubmitter {
  constructor(submitUrl, responseFunc) {
    this.submitUrl_ = submitUrl;
    this.responseFunc_ = responseFunc;

    this.queue_ = [];
    this.submitting_ = false;
    this.submittingQueue_ = [];
    this.timer_ = null;
  }

  queue(answerObject) {
    this.queue_.push(answerObject);
  }

  start() {
    this.timer_ = window.setInterval(this.beginSubmission, INTERVAL_ANSWER_UPDATE);
  }

  beginSubmission() {
    // Do not submit if is submitting
    if (this.submitting_) return;
    // Set submitting to true
    this.submitting_ = true;
    // Dump queue into submitting
    this.submittingQueue_ = this.queue_;
    // Swap out queue to fresh queue
    this.queue_ = [];

    $.ajax({
      url: this.submitUrl_,
      method: 'POST',
      dataType: 'json',
      contentType: 'application/json'
    }).done((response) => {
      if (response.constructor !== Array) return;
      // Select unsuccessful ids from old queue
      var residue = $.grep(this.submittingQueue_, function(answer, index) {
        return response.indexOf(answer) < 0;
      });
      console.log(residue);
      Array.prototype.push.apply(this.queue_, residue);
      this.responseFunc_(response);
      // Release
      this.submitting_ = false;
    });
  }

  retire() {
    if (!this.timer_) return;
    window.clearInterval(this.timer_);
  }

}
