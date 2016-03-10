class Educators::EducatorReminderService

  def check_batch_completion(code_usage)
    batch_code_usages = code_usage.batch_code_usages
    batch_code_usages.each do |bcu|
      batch = bcu.batch
      if batch.code_usages.all? { |cu| cu.completed? }
        Educators::EducatorMailer.batch_completion_email(batch.educator, batch_name).deliver_now
      end
    end
  end

end
