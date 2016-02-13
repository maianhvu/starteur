const INTERVAL_ANSWER_UPDATE = 2000;

class AnswerSubmitter {
  constructor(submitUrl, responseFunc) {
    this.submitUrl_ = submitUrl;
    this.responseFunc_ = responseFunc;

    this.queue_ = {};
    this.isSubmitting_ = false;
    this.submittingQueue_ = {};
    this.timer_ = null;
  }

  queue(answerObject) {
    this.queue_[answerObject.questionId] = answerObject.value;
  }

  start() {
    this.timer_ = window.setInterval(this.beginSubmission.bind(this), INTERVAL_ANSWER_UPDATE);
  }

  beginSubmission() {
    // Do not submit if is submitting or queue empty
    if (this.isSubmitting_ || Object.keys(this.queue_).length === 0) {
      return;
    }
    // Set submitting to true
    this.isSubmitting_ = true;
    // Dump queue into submitting
    this.submittingQueue_ = this.queue_;
    // Swap out queue to fresh queue
    this.queue_ = {};

    $.ajax({
      url: this.submitUrl_,
      method: 'POST',
      dataType: 'json',
      contentType: 'application/json',
      data: JSON.stringify({ values: this.submittingQueue_ })
    }).done((response) => {
      // Do not modify queue if response is not array
      if (response.constructor !== Array) return this.responseFunc_(response);

      // Residue contains questionIds that are unsuccessfully updated
      var residue = this.submittingQueue_;
      response.forEach((questionId) => {
        delete residue[questionId];
      });
      // Add residue back into queue
      Object.keys(residue).forEach((residueQuestionId) => {
        this.queue_[residueQuestionId] = residue[residueQuestionId];
      });

      this.responseFunc_(response);
      // Release
      this.isSubmitting_ = false;
    });
  }

  retire() {
    if (!this.timer_) return;
    window.clearInterval(this.timer_);
  }

}
