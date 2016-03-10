class Educators::EducatorReminderService

  def check_batch_completion(code_usage)
    batch = code_usage.batch
    if batch && batch.code_usages.all? { |cu| cu.complete? }
      Educators::EducatorMailer.batch_completion_email(batch.educator, batch_name).deliver_now
    end
  end

end
